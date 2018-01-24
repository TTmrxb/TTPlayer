//
//  UIView+TT.h
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/22.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TT)

@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

- (void)removeAllSubviews;

- (UIViewController *)getController;

@end
