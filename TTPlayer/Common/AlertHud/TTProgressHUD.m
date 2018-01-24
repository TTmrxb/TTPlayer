//
//  TTProgressHUD.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/27.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import "TTProgressHUD.h"

@implementation TTProgressHUD

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    
    TTProgressHUD *hud = [[super alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    
    [view addSubview:hud];
    [hud showAnimated:animated];
    
    return hud;
}

@end
