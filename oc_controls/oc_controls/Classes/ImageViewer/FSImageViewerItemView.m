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
@property (nonatomic, weak)  UIImageView *imageView;

@end

@implementation FSImageViewerItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupScrollView];
        [self setupImageView];
        [self addGestureRecognizer];
    }
    return self;
}

- (void)setupScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
}

// 放大手势
// 缩小手势，
// 双击手势，从点击点放大或复原
// 单击手势,退出
- (void)addGestureRecognizer {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:
                                                self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.scrollView addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:
                                                self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)setupImageView {
    UIImageView *imageView = [UIImageView new];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    imageView.image = [UIImage imageNamed:@"bg"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.imageView.size = CGSizeMake(self.width, self.height * 0.5);
    self.imageView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - 事件

#pragma mark 缩放完毕，调整contentSize,使之能完整显示图片

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    scrollView.contentSize = CGSizeMake(scrollView.width * scrollView.zoomScale,
                                        scrollView.height * scrollView.zoomScale);
}

#pragma mark 手势单击

- (void)handleSingleTap:(UIGestureRecognizer *)sender {
    NSLog(@"单击事件");
}

#pragma mark 手势双击

- (void)handleDoubleTap:(UIGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat zoomScale = self.scrollView.minimumZoomScale;   // 缩小
    if (self.scrollView.zoomScale != self.scrollView.maximumZoomScale) {
        zoomScale = self.scrollView.maximumZoomScale;       // 放大
        [self touchPointWantToBeCenter:touchPoint];
    }
    [self animationChangeZoom:zoomScale];
}

#pragma mark - 工具方法

- (void)animationChangeZoom:(CGFloat)zoomScale {
    WEAK_REF(weakSelf, self);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollView.zoomScale = zoomScale;
    }];
}

// 点击的位置想成为中点，但是滚不动则不滚了
- (void)touchPointWantToBeCenter:(CGPoint)touchPoint {
//    CGFloat offsetX;
//    CGFloat offsetY;
//    WEAK_REF(weakSelf, self);
//    [UIView animateWithDuration:0.25 animations:^{
//        [weakSelf.scrollView setContentOffset:CGPointMake(offsetX, offsetY)];
//    }];
}

@end
