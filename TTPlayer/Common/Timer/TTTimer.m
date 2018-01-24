//
//  TTTimer.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/9.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "TTTimer.h"

@interface TTTimer () {
    
    BOOL _isTickComplete;
    BOOL _isSuspend;
}

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TTTimer

- (instancetype)init {
    
    if (self = [super init]) {
        _duration = 0;
        _tickInterval = 0;
        _isTickComplete = NO;
        _isSuspend = YES;
    }
    
    return self;
}

- (void)tickDownProgress:(void(^)(void))progress {
    
    if(self.duration == 0) return;
    
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer,
                                  dispatch_walltime(NULL, 0),
                                  self.tickInterval * NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress();
                });
            }
        });
        
        [self resume];
    }
}

- (void)tickDownCompletion:(void(^)(void))completion {
    
    if(self.duration == 0) return;
    
    __block NSInteger timeOut = self.duration;
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer,
                                  dispatch_walltime(NULL, 0),
                                  self.tickInterval * NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (timeOut <= 0) {
                [self destroy];
                if(completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                }
                
                _isTickComplete = YES;
            }else {
                timeOut = timeOut - self.tickInterval;
            }
        });
        
        [self resume];
    }
}

- (void)suspend {
    
    if (self.timer && !_isSuspend) {
        dispatch_suspend(self.timer);
        _isSuspend = YES;
    }
}

- (void)resume {
    
    if (self.timer && _isSuspend) {
        dispatch_resume(self.timer);
        _isSuspend = NO;
    }
}

- (void)destroy {
    
    if (self.timer) {
        if (!_isTickComplete) {
            [self resume];
        }
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
