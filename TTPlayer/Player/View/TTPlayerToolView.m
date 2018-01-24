//
//  TTPlayerToolView.m
//  TTPlayer
//
//  Created by jyzx101 on 2018/1/3.
//  Copyright © 2018年 Elliot Wang. All rights reserved.
//

#import "TTPlayerToolView.h"

#import "TTTimer.h"
#import "TTPlayerToolProtocol.h"
#import "TTConfiguration.h"
#import "UIColor+TT.h"
#import "NSString+TT.h"
#import <Masonry.h>

static CGFloat kTopToolHeight = 50.0;
static CGFloat kBottomToolHeight = 40.0;

@interface TTPlayerToolView () {
    
    BOOL _isShowTool;
}

@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *topContainer;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *bottomContainer;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *currentTimeLbl;
@property (nonatomic, strong) UILabel *totalLbl;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIProgressView *bufferProgressView;   //缓冲进度条
@property (nonatomic, strong) UISlider *playProgressSlider;         //播放进度条

@property (nonatomic, strong) TTTimer *toolTimer;   //计时器，用于自动隐藏工具栏

@end

@implementation TTPlayerToolView

@synthesize title = _title;
@synthesize playProgress = _playProgress;
@synthesize bufferProgress = _bufferProgress;
@synthesize totalTime = _totalTime;

- (void)dealloc {
    
    [self destroyTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _isShowTool = YES;
        
        [self addSubview:self.topScrollView];
        [self.topScrollView addSubview:self.topContainer];
        [self.topContainer addSubview:self.backView];
        [self.topContainer addSubview:self.titleLbl];
        
        [self addSubview:self.bottomScrollView];
        [self.bottomScrollView addSubview:self.bottomContainer];
        [self.bottomContainer addSubview:self.playBtn];
        [self.bottomContainer addSubview:self.currentTimeLbl];
        [self.bottomContainer addSubview:self.totalLbl];
        [self.bottomContainer addSubview:self.fullScreenBtn];
        [self.bottomContainer addSubview:self.bufferProgressView];
        [self.bottomContainer addSubview:self.playProgressSlider];
        
        [self makeConstraints];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        [self setupTimer];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)pauseTool {
    
    self.playBtn.selected = YES;
    [self destroyTimer];
}

- (void)resumeTool {
    
    self.playBtn.selected = NO;
    [self setupTimer];
}

- (void)hidTool {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topScrollView.contentOffset = CGPointMake(0, kTopToolHeight);
        self.bottomScrollView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        _isShowTool = NO;
        self.topScrollView.hidden = YES;
        self.bottomScrollView.hidden = YES;
        [self destroyTimer];
    }];
}

- (void)showTool {
    
    self.topScrollView.hidden = NO;
    self.bottomScrollView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.topScrollView.contentOffset = CGPointZero;
        self.bottomScrollView.contentOffset = CGPointMake(0, kBottomToolHeight);
    } completion:^(BOOL finished) {
        _isShowTool = YES;
        if (!self.playBtn.selected) {
            [self setupTimer];
        }
    }];
}

#pragma mark - Event Response

- (void)backClicked:(UIGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(backClicked)]) {
        [self.delegate backClicked];
    }
}

- (void)tap:(UIGestureRecognizer *)sender {
    
    if (_isShowTool) {
        [self hidTool];
    }else {
        [self showTool];
    }
}

- (void)playClicked:(UIButton *)sender {
    
    //播放完成，不响应操作
    if (self.playProgress >= 1) return;
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(pausePlay)]) {
            [self.delegate pausePlay];
        }
        
        [self destroyTimer];
    }else {
        if ([self.delegate respondsToSelector:@selector(resumePlay)]) {
            [self.delegate resumePlay];
        }
        
        [self setupTimer];
    }
}

- (void)fullScreenClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(fullScreenPlay)]) {
        [self.delegate fullScreenPlay];
    }
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    
    DLog(@"播放进度 = %.2f", sender.value);
    self.playProgress = sender.value;
    
    if ([self.delegate respondsToSelector:@selector(progressChanged:)]) {
        [self.delegate progressChanged:sender];
    }
}

- (void)progressSliderTouchDown:(UISlider *)sender {
    
    DLog(@"进度条触摸开始");
    [self destroyTimer];
}

- (void)progressSliderTouchUp:(UISlider *)sender {
    
    DLog(@"进度条触摸结束");
    if (!self.playBtn.selected) {
        [self setupTimer];
    }
}

#pragma mark - Private Methods

- (void)setupTimer {
    
    __weak typeof(self) weakSelf = self;

    self.toolTimer = [[TTTimer alloc] init];
    self.toolTimer.tickInterval = 1;
    self.toolTimer.duration = 6;
    [self.toolTimer tickDownCompletion:^{
        [weakSelf hidTool];
    }];
}

- (void)destroyTimer {
    
    [self.toolTimer destroy];
}

- (void)makeConstraints {

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainer);
        make.top.equalTo(self.topContainer).with.offset(TT_TOP_SAFE_HEIGHT == 0 ? 20.0 : 0);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];

    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_right).with.offset(4);
        make.right.equalTo(self.topContainer).with.offset(-2);
        make.top.bottom.equalTo(self.backView);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomContainer);
        make.centerY.equalTo(self.bottomContainer);
        make.size.mas_equalTo(CGSizeMake(38, 32));
    }];

    [self.currentTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).with.offset(2);
        make.top.bottom.equalTo(self.playBtn);
        make.width.mas_equalTo(48);
    }];

    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomContainer);
        make.centerY.equalTo(self.playBtn);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left).with.offset(-2);
        make.top.bottom.width.equalTo(self.currentTimeLbl);
    }];

    [self.bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLbl.mas_right).with.offset(2);
        make.right.equalTo(self.totalLbl.mas_left).with.offset(-2);
        make.centerY.equalTo(self.playBtn).with.offset(1);
        make.height.mas_equalTo(2);
    }];
    
    [self.playProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bufferProgressView);
        make.top.bottom.equalTo(self.bottomContainer);
    }];
}

#pragma mark - Getter

- (UIScrollView *)topScrollView {
    
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        TT_SCREEN_WIDTH,
                                                                        kTopToolHeight)];
        _topScrollView.backgroundColor = [UIColor clearColor];
        _topScrollView.contentSize = CGSizeMake(TT_SCREEN_WIDTH, 2 * kTopToolHeight);
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [_topScrollView addGestureRecognizer:tap];
    }
    
    return _topScrollView;
}

- (UIView *)topContainer {
    
    if (!_topContainer) {
        _topContainer = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 TT_SCREEN_WIDTH,
                                                                 kTopToolHeight)];
        _topContainer.backgroundColor = [UIColor colorWithR:0 G:0 B:0 alpha:0.2];
    }
    
    return _topContainer;
}

- (UIImageView *)backView {
    
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.image = [UIImage imageNamed:@"player_back"];
        _backView.contentMode = UIViewContentModeCenter;
        
        _backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap
        = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(backClicked:)];
        [_backView addGestureRecognizer:tap];
    }
    
    return _backView;
}

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.font = [UIFont systemFontOfSize:15.0];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLbl;
}

- (UIScrollView *)bottomScrollView {
    
    if (!_bottomScrollView) {
        CGFloat scrollViewY = self.bounds.size.height - kBottomToolHeight;
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           scrollViewY,
                                                                           TT_SCREEN_WIDTH,
                                                                           kBottomToolHeight)];
        _bottomScrollView.backgroundColor = [UIColor clearColor];
        _bottomScrollView.contentSize = CGSizeMake(TT_SCREEN_WIDTH, 2 * kBottomToolHeight);
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.scrollEnabled = NO;
        _bottomScrollView.contentOffset = CGPointMake(0, kBottomToolHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [_bottomScrollView addGestureRecognizer:tap];
    }
    
    return _bottomScrollView;
}

- (UIView *)bottomContainer {
    
    if (!_bottomContainer) {
        _bottomContainer = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    kBottomToolHeight,
                                                                    TT_SCREEN_WIDTH,
                                                                    kBottomToolHeight)];
        _bottomContainer.backgroundColor = [UIColor colorWithR:0 G:0 B:0 alpha:0.2];
    }
    
    return _bottomContainer;
}

- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = [UIColor clearColor];
        [_playBtn setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateSelected];
        
        [_playBtn addTarget:self
                     action:@selector(playClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playBtn;
}

- (UILabel *)currentTimeLbl {
    
    if (!_currentTimeLbl) {
        _currentTimeLbl = [[UILabel alloc] init];
        _currentTimeLbl.backgroundColor = [UIColor clearColor];
        _currentTimeLbl.font = [UIFont systemFontOfSize:13.0];
        _currentTimeLbl.textAlignment = NSTextAlignmentLeft;
        _currentTimeLbl.textColor = [UIColor whiteColor];
        _currentTimeLbl.text = @"00:00";
    }
    
    return _currentTimeLbl;
}

- (UILabel *)totalLbl {
    
    if (!_totalLbl) {
        _totalLbl = [[UILabel alloc] init];
        _totalLbl.backgroundColor = [UIColor clearColor];
        _totalLbl.font = [UIFont systemFontOfSize:13.0];
        _totalLbl.textAlignment = NSTextAlignmentRight;
        _totalLbl.textColor = [UIColor whiteColor];
        _totalLbl.text = @"00:00";
    }
    
    return _totalLbl;
}

- (UIButton *)fullScreenBtn {
    
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenBtn.backgroundColor = [UIColor clearColor];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"player_full_screen"]
                        forState:UIControlStateNormal];
        
        [_fullScreenBtn addTarget:self
                           action:@selector(fullScreenClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fullScreenBtn;
}

- (UIProgressView *)bufferProgressView {
    
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIProgressView alloc] init];
        _bufferProgressView.progressTintColor = [UIColor lightGrayColor];
        _bufferProgressView.trackTintColor = [UIColor whiteColor];
        _bufferProgressView.progress = 0.1;
        _bufferProgressView.layer.masksToBounds = YES;
        _bufferProgressView.layer.cornerRadius = 0;
    }
    
    return _bufferProgressView;
}

- (UISlider *)playProgressSlider {

    if (!_playProgressSlider) {
        _playProgressSlider = [[UISlider alloc] init];
        _playProgressSlider.minimumTrackTintColor = TT_APP_THEME_COLOR;
        _playProgressSlider.maximumTrackTintColor = [UIColor clearColor];
        _playProgressSlider.minimumValue = 0;
        _playProgressSlider.maximumValue = 1.0;
        _playProgressSlider.value = 0;
        [_playProgressSlider addTarget:self
                                action:@selector(progressSliderValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
        [_playProgressSlider addTarget:self
                                action:@selector(progressSliderTouchDown:)
                      forControlEvents:UIControlEventTouchDown];
        [_playProgressSlider addTarget:self
                                action:@selector(progressSliderTouchUp:)
                      forControlEvents:UIControlEventTouchUpInside];
    }

    return _playProgressSlider;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLbl.text = self.title;
}

- (void)setPlayProgress:(CGFloat)playProgress {
    
    _playProgress = playProgress;
    
    if (self.playProgress >= 1) {
        [self showTool];
    }
    
    NSInteger currentTime = self.totalTime * self.playProgress;
    NSInteger minute = currentTime / 60;
    NSInteger second = currentTime % 60;
    NSString *showMinute = [NSString towCharsWithValue:minute];
    NSString *showSecond = [NSString towCharsWithValue:second];
    self.currentTimeLbl.text = [NSString stringWithFormat:@"%@:%@", showMinute, showSecond];
    
    self.playProgressSlider.value = self.playProgress;
}

- (void)setBufferProgress:(CGFloat)bufferProgress {
    
    _bufferProgress = bufferProgress;
    self.bufferProgressView.progress = self.bufferProgress;
}

- (void)setTotalTime:(NSInteger)totalTime {
    
    _totalTime = totalTime;
    NSInteger minute = self.totalTime / 60;
    NSInteger second = self.totalTime % 60;
    
    NSString *showMinute = [NSString towCharsWithValue:minute];
    NSString *showSecond = [NSString towCharsWithValue:second];
    self.totalLbl.text = [NSString stringWithFormat:@"%@:%@", showMinute, showSecond];
}

@end
