//
//  TTVideoRequestTask.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/2.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "TTVideoRequestTask.h"

@interface TTVideoRequestTask ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, copy) NSString *tempPath;
@property (nonatomic, strong) NSMutableArray *taskArr;

@end

@implementation TTVideoRequestTask

- (instancetype)init {
    
    if (self = [super init]) {
        _taskArr = [NSMutableArray array];
        
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES).lastObject;
        _tempPath = [docPath stringByAppendingPathComponent:@"temp.mp4"];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:_tempPath]) {
            [fileMgr removeItemAtPath:_tempPath error:nil];
        }
        [fileMgr createFileAtPath:_tempPath contents:nil attributes:nil];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)laodWithUrl:(NSURL *)url offset:(NSInteger)offset {
    
    self.url = url;
    self.offset = offset;
}

@end
