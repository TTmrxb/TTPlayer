//
//  TTTimer.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/9.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTimer : NSObject

/** 计时器总时长 */
@property (nonatomic, assign) NSInteger duration;
/** 钟摆间隔 */
@property (nonatomic, assign) NSInteger tickInterval;

/**
 倒计时
 */
- (void)tickDownProgress:(void(^)(void))progress;

- (void)tickDownCompletion:(void(^)(void))completion;

- (void)suspend;

- (void)resume;

- (void)destroy;

@end
