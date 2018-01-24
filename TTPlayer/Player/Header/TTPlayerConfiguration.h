//
//  TTPlayerConfiguration.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/22.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#ifndef TTPlayerConfiguration_h
#define TTPlayerConfiguration_h

typedef NS_ENUM(NSUInteger, TTPlayerState) {
    TTPlayerStateBuffering  = 0,    //视频缓冲状态
    TTPlayerStatePlaying,           //视频播放状态
    TTPlayerStateStoppped,          //视频停止状态
    TTPlayerStatePause              //视频暂停状态
};

#endif /* TTPlayerConfiguration_h */
