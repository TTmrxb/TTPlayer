//
//  UIColor+TT.h
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TT)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*)colorWithHex:(NSInteger)hexValue;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;

@end
