//
//  FSImageViewerItemView.m
//  oc_controls
//
//  Created by fzhang on 16/3/1.
//  Copyright © 2016年 fanstudio. All rights reserved.
// 双击与单击参考自：http://blog.csdn.net/hopedark/article/details/17607325

#import "FSImageViewerItemView.h"
#import "FSCommon.h"


@interface FSImageViewerItemView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL needChangeOffset;
@property (nonatomic, assign) CGPoint zoomedPoint;

@end

@implementation FSImageViewerItemView

#pragma mark - lifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupScrollView];
        [self setupImageView];
        [self addGestureRecognizer];
        [self listenImageViewValueChange];
    }
    return self;
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - setupSubviews

- (void)setupScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
}

- (void)addGestureRecognizer {
    // 添加单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:
                                                self action:@selector(onSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapGesture];
    
    // 添加双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:
                                                self action:@selector(onDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
    // 注册双击时，单击手势无效
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)setupImageView {
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:_imageView];
    _imageView.backgroundColor = [UIColor grayColor];
}

- (void)listenImageViewValueChange {
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    // 自适应图片的大小
    self.imageView.size = [self image:self.imageView.image fitSize:self.size];
    self.imageView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
    // 自适应图片能放大的比例
    self.scrollView.maximumZoomScale = [self autoScale];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - 事件

#pragma mark 缩放完毕，调整contentSize,使之能完整显示图片

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 注意scrollView的自身的放大与缩小，以及通过设置scrollView的zoomScale的方式来缩放，被缩放的对象原点x,y值是不会变化的
    scrollView.contentSize = CGSizeMake(scrollView.width * scrollView.zoomScale,
                                        scrollView.height * scrollView.zoomScale);
}

#pragma mark 手势单击

- (void)onSingleTap:(UIGestureRecognizer *)sender {
    if (self.didUserSingleTap) self.didUserSingleTap();
}

#pragma mark 手势双击：从点击点放大到最大或复原

- (void)onDoubleTap:(UIGestureRecognizer *)sender {
    CGFloat zoomScale = self.scrollView.minimumZoomScale;   // 缩小
    CGPoint touchPoint = [sender locationInView:self];
    self.needChangeOffset = NO;
    
    if (self.scrollView.zoomScale != self.scrollView.maximumZoomScale) {
        zoomScale = self.scrollView.maximumZoomScale;       // 放大
        self.zoomedPoint = [self zoomedPointOnScrollView:touchPoint zoomScale:zoomScale];
        self.needChangeOffset = YES;
    }
    [self animationChangeZoom:zoomScale];
}

- (void)animationChangeZoom:(CGFloat)zoomScale {
    WEAK_REF(weakSelf, self);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollView.zoomScale = zoomScale;
        // 默认通过zooScale来缩放，是基于图像的中心来进行缩放，
        // 这里优化一下，用户点击哪个位置，放大后，该点为中心点,以便于查看
        if (!weakSelf.needChangeOffset) return;
        [weakSelf changePointToScrollViewCenter:weakSelf.zoomedPoint zoomScale:zoomScale];
    }];
}

#pragma mark UIImage的值发生改变时，自适应图片的比例

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // 图片切换时，恢复到默认，并手动触发一次重新自适应图片的大小
    self.scrollView.zoomScale = 1.0;
    [self setNeedsLayout];
}

#pragma mark - 工具方法

/*************************************************
 * 作用：获取一个点被放大后在scrollView的位置
 * 参数：
 *  touchOnScrollViewPoint - 在scrollView上触摸的位置
 *  zoomScale - scrollView最终会被放大的级别
 ************************************************/
- (CGPoint)zoomedPointOnScrollView:(CGPoint)originalPoint zoomScale:(CGFloat)zoomScale {
    // 1.将触摸在scrollView上的点转换为在图像上的位置
    CGPoint onImagePoint = [self.scrollView convertPoint:originalPoint toView:self.imageView];
    
    /* 2.计算图像被放大后在的位置，注意，这里的算法应该同scrollView
     代理方法中的scrollViewDidZoom:方法一致，这里是等比例缩放 */
    CGFloat touchZoomedX = onImagePoint.x * zoomScale;
    CGFloat touchZoomedY = onImagePoint.y * zoomScale;
    CGPoint zoomedPointOnImage = CGPointMake(touchZoomedX, touchZoomedY);
    
    // 3.再将图像上的位置转换为在scrollView上的位置
    return [self.imageView convertPoint:zoomedPointOnImage toView:self.scrollView];
}

/*******************************************************************
 * 作用：将指定的点偏移至scrollView的中心
 * 参数：
 *  point - 相对于scrollView的点，放大后的该点将置为scrollView的视角中心
 *  zoomScale - scrollView最终会被放大的级别
 *******************************************************************/
- (void)changePointToScrollViewCenter:(CGPoint)point zoomScale:(CGFloat)zoomScale {
    // 1.计算偏移量
    CGFloat offsetX = point.x - self.scrollView.width * 0.5;
    CGFloat offsetY = point.y - self.scrollView.height * 0.5;
    
    // 2.修正offset,使其不会偏移到contentSize之外，如果想强制该点至中心，将revise至为NO
    BOOL revise = YES;
    if (revise) {
        CGFloat maxOffsetX = self.scrollView.width * zoomScale - self.scrollView.width;
        CGFloat maxOffsetY = self.scrollView.height * zoomScale - self.scrollView.height;
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        if (offsetX < 0) offsetX = 0;
        if (offsetY > maxOffsetY) offsetY = maxOffsetY;
        if (offsetY < 0) offsetY = 0;
    }
    // 3.设置偏移量
    self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
}

/**
 将传入的image自适应size的大小，返回一个刚好能装满image的大小
 */
- (CGSize)image:(UIImage *)image fitSize:(CGSize)size {
    if (!image) {
        return CGSizeMake(self.width, self.height * 0.5);
    }
    CGFloat width = size.width;
    CGFloat height = width * image.size.height / image.size.width;
    if (height > size.height) {
        height = size.height;
        width = height * image.size.width / image.size.height;
    }

    return CGSizeMake(width, height);
}

/**
 自动配置图片能放大的比例，这里刚好放大到真实的尺寸
 */
- (CGFloat)autoScale {
    CGFloat scale = 1.0;
    if (!self.imageView.image) {
        return scale;
    }
    
    scale = self.imageView.image.size.width / self.imageView.width;
    if (scale < 1.0) scale = 1.0;
    return scale;
}

@end
