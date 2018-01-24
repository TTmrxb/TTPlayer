//
//  AppDelegate.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import "AppDelegate.h"

#import "TTHomeVC.h"

#import "UIColor+TT.h"
#import "TTConfiguration.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *homeNavi = [[UINavigationController alloc]
                                        initWithRootViewController:[[TTHomeVC alloc] init]];
    
    self.window.rootViewController = homeNavi;
    [self.window makeKeyAndVisible];
    
    [self configNaviBar];
    
    return YES;
}

#pragma mark - Appearance

- (void)configNaviBar {
    
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.tintColor = [UIColor whiteColor];
    naviBar.barTintColor = TT_APP_THEME_COLOR;
    naviBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    naviBar.translucent = NO;
    
    UIImage *naviImage = [[UIImage imageNamed:@"naviBack"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naviBar.backIndicatorImage = naviImage;
    naviBar.backIndicatorTransitionMaskImage = naviImage;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-TT_SCREEN_WIDTH, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
}

@end
