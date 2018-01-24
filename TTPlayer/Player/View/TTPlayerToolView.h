//
//  TTPlayerToolView.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/3.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTPlayerToolViewDelegate;

@interface TTPlayerToolView : UIView

@property (nonatomic, weak) id<TTPlayerToolViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
/** 当前播放进度 */
@property (nonatomic, assign) CGFloat playProgress;
/** 当前缓冲进度 */
@property (nonatomic, assign) CGFloat bufferProgress;
/** 视频总时间（单位：秒） */
@property (nonatomic, assign) NSInteger totalTime;

- (void)pauseTool;

- (void)resumeTool;

- (void)hidTool;

- (void)showTool;

@end
