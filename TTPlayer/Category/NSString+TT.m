//
//  NSString+TT.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/15.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "NSString+TT.h"

@implementation NSString (TT)

+ (NSString *)towCharsWithValue:(NSInteger)value {
    
    NSString *showTime;
    if (value >= 0 && value <= 9) {
        showTime = [NSString stringWithFormat:@"0%ld", (long)value];
    }else if (value > 9) {
        showTime = [NSString stringWithFormat:@"%ld", (long)value];
    }else {
        showTime = @"";
    }

    return showTime;
}

@end
