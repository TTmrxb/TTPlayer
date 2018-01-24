//
//  NSString+TT.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/15.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TT)

/**
 数值转字符串，用0站位。如：0-9，返回00-09；大于9的，直接返回，如：10 ，返回10。
 */
+ (NSString *)towCharsWithValue:(NSInteger)value;

@end
