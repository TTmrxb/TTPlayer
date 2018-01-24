//
//  TTVideoModel.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/19.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kVideoUrl;
extern NSString * const kVideoTitle;
extern NSString * const kVideoTotalTime;

@interface TTVideoModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger totalTime;

- (void)configWithVideoInfo:(NSDictionary *)videoInfo;

@end
