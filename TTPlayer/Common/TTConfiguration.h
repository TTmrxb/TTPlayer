//
//  TTConfiguration.h
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#ifndef TTConfiguration_h
#define TTConfiguration_h

#pragma mark - 快捷代码

//屏幕宽高
#define TT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//设备信息
#define TT_IOS_VERSION [UIDevice currentDevice].systemVersion.floatValue

//UI安全区域
#define TT_TOP_SAFE_HEIGHT (CGFloat)(TT_SCREEN_HEIGHT < 800 ? 0 : 44.0)
#define TT_BOTTOM_SAFE_HEIGHT (CGFloat)(TT_SCREEN_HEIGHT < 800 ? 0 : 34.0)

//字符串、数组 是否非空
#define TT_STRING_NOT_EMPTY(string) (string && ![string isEqualToString:@""])
#define TT_ARRAY_NOT_EMPTY(array) (array && array.count > 0)

#pragma mark - UI常量

//颜色
#define TT_APP_THEME_COLOR [UIColor colorWithHex:0x4D99E6]

#pragma mark - 日志

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] \
lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else
#define DLog( s, ... )

#endif

#endif /* TTConfiguration_h */
