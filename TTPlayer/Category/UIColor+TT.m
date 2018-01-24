//
//  UIColor+TT.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import "UIColor+TT.h"

@implementation UIColor (TT)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue {
    
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

@end
