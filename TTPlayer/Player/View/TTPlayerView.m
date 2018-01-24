//
//  TTPlayerView.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/4.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "TTPlayerView.h"
#import "TTVideoModel.h"

@implementation TTPlayerView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.toolView];
    }
    
    return self;
}

#pragma mark - Getter

- (TTPlayerToolView *)toolView {
    
    if (!_toolView) {
        _toolView = [[TTPlayerToolView alloc] initWithFrame:self.bounds];
    }
    
    return _toolView;
}

@end
