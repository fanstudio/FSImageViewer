//
//  AppDelegate.m
//  oc_controls
//
//  Created by fzhang on 16/2/29.
//  Copyright © 2016年 fanstudio. All rights reserved.
//

#import "AppDelegate.h"
#import "FSMainController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [FSMainController new];
    [self.window makeKeyAndVisible];

    return YES;
}



@end
