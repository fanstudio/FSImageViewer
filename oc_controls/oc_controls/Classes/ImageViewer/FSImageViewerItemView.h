//
//  FSImageViewerItemView.h
//  oc_controls
//
//  Created by fzhang on 16/3/1.
//  Copyright © 2016年 fanstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSImageViewerItemView : UIView

/** 用于图片展示 */
@property (nonatomic, strong, readonly) UIImageView *imageView;
/** 单击回调方法 */
@property (nonatomic, strong) void (^didUserSingleTap)();

@end
