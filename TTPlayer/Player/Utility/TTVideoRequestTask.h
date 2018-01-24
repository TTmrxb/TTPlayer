//
//  TTVideoRequestTask.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/2.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTVideoRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, readonly) NSInteger offset;

@end
