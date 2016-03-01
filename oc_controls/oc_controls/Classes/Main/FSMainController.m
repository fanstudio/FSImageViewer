//
//  FSMainController.m
//  oc_controls
//
//  Created by fzhang on 16/2/29.
//  Copyright © 2016年 fanstudio. All rights reserved.
//

#import "FSMainController.h"
#import "FSImageViewerItemView.h"
#import "FSCommon.h"

@interface FSMainController ()

@property (nonatomic, weak) FSImageViewerItemView *itemView;
@property (nonatomic, weak) UIView *textContentView;

@end

@implementation FSMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItemView];
    [self setupTextView];
}

- (void)setupItemView {
    FSImageViewerItemView *itemView = [FSImageViewerItemView new];
    [self.view addSubview:itemView];
    self.itemView = itemView;
    itemView.backgroundColor = [UIColor whiteColor];
}

- (void)setupTextView {
    UIView *textContentView = [UIView new];
    [self.view addSubview:textContentView];
    self.textContentView = textContentView;
    textContentView.backgroundColor = FS_ARGB(88, 0, 0, 0);
}

- (void)viewWillLayoutSubviews {

    self.itemView.frame = self.view.bounds;
    CGFloat textContentViewW = self.view.width;
    CGFloat textContentViewH = self.view.height * 0.2;
    self.textContentView.frame = CGRectMake(0, self.view.height - textContentViewH,
                                            textContentViewW, textContentViewH);
}


@end
