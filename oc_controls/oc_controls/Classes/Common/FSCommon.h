//
//  FSCommon.h
//  oc_controls
//
//  Created by fzhang on 16/3/1.
//  Copyright © 2016年 fanstudio. All rights reserved.
//

#ifndef FSCommon_h
#define FSCommon_h
#import <UIKit/UIKit.h>
#import "UIView+FSLayout.h"


/*****************日志宏**********************/
#ifdef DEBUG
    #define FSLOG(...) NSLog(__VA_ARGS__);
    #define FSTrace NSLog(@"enter %s", __func__)
#else
    #define FSGLOG(...)
    #define FSTrace
#endif

/***********************内存管理***************************/
#define WEAK_REF(obj_ref, obj) __weak typeof(obj) obj_ref = obj

/******************颜色宏*******************/
#define FS_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]         // RGB颜色
#define FS_ARGB(a, r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a / 255.0] // RGB颜色
#define FS_RANDOM_COLOR FS_COLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)) // 随机色



#endif /* FSCommon_h */
