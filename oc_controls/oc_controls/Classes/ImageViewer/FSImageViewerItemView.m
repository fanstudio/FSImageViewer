//
//  FSImageViewerItemView.m
//  oc_controls
//
//  Created by fzhang on 16/3/1.
//  Copyright © 2016年 fanstudio. All rights reserved.
//

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
    }
    return self;
}

- (void)setupScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
//    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 10.0;
    scrollView.minimumZoomScale = 0.5;
}

- (void)setupImageView {
    UIImageView *imageView = [UIImageView new];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    imageView.image = [UIImage imageNamed:@"bg"];
    
    
    // 放大手势
    // 缩小手势，
    // 双击手势，从点击点放大或复原
    // 单击手势,退出
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.imageView.size = CGSizeMake(self.width, self.height * 0.5);
    self.imageView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    self.scrollView.maximumZoomScale = self.imageView.image.size.width / self.imageView.width;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"zoomScale:%f", scrollView.zoomScale);
    NSLog(@"frame:%@", NSStringFromCGRect(self.imageView.frame));

    // 不管以哪种形式放大或者缩小，UIImageView的实际位置始终于处于scrollView视觉的正中央。
    
    // 未放大时通过坐标使其始终在正中央,放大时通过contentOffset让其在正中央
    CGFloat x = (self.scrollView.width - self.imageView.width) * 0.5; if (x < 0) x = 0;
    CGFloat y = (self.scrollView.height - self.imageView.height) * 0.5; if (y < 0) y = 0;
    self.imageView.origin = CGPointMake(x, y);
    
    // 计算contentSize
    scrollView.contentSize = self.imageView.size;
    
    
    // 缩放操作时始终显示在正中央
    CGFloat offsetX = (scrollView.contentSize.width - scrollView.width) * 0.5; if (offsetX < 0) offsetX = 0;
    CGFloat offsetY = (scrollView.contentSize.height - scrollView.height) * 0.5; if (offsetY < 0) offsetY = 0;
    scrollView.contentOffset = CGPointMake(offsetX , offsetY);
    
    
    
    // 1.取出放大的UIImageView的大小
    // 根据不同的缩放位置，contentOffset位置不一样。
    

}

@end
