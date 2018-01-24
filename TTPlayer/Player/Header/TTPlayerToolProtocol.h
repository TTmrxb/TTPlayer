//
//  TTPlayerToolProtocol.h
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/3.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#ifndef TTPlayerToolProtocol_h
#define TTPlayerToolProtocol_h

@protocol TTPlayerToolViewDelegate <NSObject>

@optional

- (void)backClicked;

- (void)resumePlay;

- (void)pausePlay;

- (void)fullScreenPlay;

- (void)progressChanged:(UISlider *)slider;

@end

#endif /* TTPlayerToolProtocol_h */
