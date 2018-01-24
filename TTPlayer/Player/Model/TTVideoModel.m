//
//  TTVideoModel.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/19.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "TTVideoModel.h"

NSString * const kVideoUrl          = @"url";
NSString * const kVideoTitle        = @"title";
NSString * const kVideoTotalTime    = @"totalTime";

@implementation TTVideoModel

- (void)configWithVideoInfo:(NSDictionary *)videoInfo {
    
    self.url = videoInfo[kVideoUrl];
    self.title = videoInfo[kVideoTitle];
    self.totalTime = [videoInfo[kVideoTotalTime] integerValue];
}

@end
