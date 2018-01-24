//
//  TTPlayerVC.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import "TTPlayerVC.h"

#import "TTPlayerToolProtocol.h"
#import "TTPlayerView.h"
#import "TTVideoModel.h"
#import "TTPlayerConfiguration.h"

#import "TTProgressHUD.h"
#import "UIColor+TT.h"
#import "TTConfiguration.h"

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, TTPlayerCellType) {
    TTPlayerCellTypeVideo = 0,
    TTPlayerCellTypeOther
};

static NSString * const kDefaultCell = @"DefaultCell";
static CGFloat const kVideoHeight = 220.0;

@interface TTPlayerVC ()
<UITableViewDataSource,
TTPlayerToolViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TTPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVURLAsset *videoAsset;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;

@property (nonatomic, assign) TTPlayerState playerStatue;
@property (nonatomic, strong) TTProgressHUD *playerHud;

@end

@implementation TTPlayerVC

#pragma mark - Life Cycle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)loadView {
    
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tableView];
    
    [self setupPlayer];
    [self.player play];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCell
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

#pragma mark - TTVideoCellDelegate

- (void)backClicked {

    [self destroyPalyer];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resumePlay {
    
    DLog(@"继续播放");
    [self.player play];
}

- (void)pausePlay {
    
    DLog(@"暂停播放");
    [self.player pause];
}

- (void)fullScreenPlay {
    
    DLog(@"全屏播放");
}

- (void)progressChanged:(UISlider *)slider {
    
    [self playAtProgress:slider.value];
}

#pragma mark - Notification

- (void)finishedPlay:(NSNotification *)notification {
    
    DLog(@"视频播放完成");
    [self.playerView.toolView pauseTool];
    self.playerStatue = TTPlayerStateStoppped;
}

#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus playStatus = [change[@"new"] intValue];
        
        switch (playStatus) {
                
            case AVPlayerStatusReadyToPlay: {
                DLog(@"视频加载成功");
                self.playerStatue = TTPlayerStatePlaying;
            }
                break;
                
            case AVPlayerStatusFailed: {
                DLog(@"视频播放失败");
            }
                break;
                
            default: {
                DLog(@"视频发生未知错误");
            }
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        CMTimeRange timeRange = [self.currentPlayerItem.loadedTimeRanges.firstObject CMTimeRangeValue];
        CGFloat start = CMTimeGetSeconds(timeRange.start);
        CGFloat current = CMTimeGetSeconds(timeRange.duration);
        CGFloat buffer = start + current;
        
        self.playerView.toolView.bufferProgress = buffer;
    }
}

- (void)playAtProgress:(CGFloat)progress {
    
    //播放完成后，再次滑动进度条，修改播放按钮状态
    if (self.playerStatue == TTPlayerStateStoppped) {
        [self.playerView.toolView resumeTool];
    }
    
    NSInteger second = self.playerView.toolView.totalTime * progress;
    [self.player pause];
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:CMTimeMake(second, 1) completionHandler:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.player play];
    }];
}

#pragma mark - Private Methdos

- (void)setupPlayer {
    
    if(!TT_STRING_NOT_EMPTY(self.video.url)) return;
    
    _playerHud = [TTProgressHUD showHUDAddedTo:self.playerView animated:YES];
    
    if(![self.video.url hasPrefix:@"http"]) {
        NSURL *videoUrl = [NSURL fileURLWithPath:self.video.url];
        self.videoAsset = [AVURLAsset assetWithURL:videoUrl];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:self.videoAsset];
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.playerView.bounds;
        [self.playerView.layer insertSublayer:self.playerLayer atIndex:0];
    }
    
    //视频播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlay:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    //监测视频播放进度
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                              queue:dispatch_get_main_queue()
                                         usingBlock:^(CMTime time)
    {
        CGFloat totalTime = CMTimeGetSeconds(weakSelf.currentPlayerItem.duration);
        CGFloat currentTime = CMTimeGetSeconds(time);
        weakSelf.playerView.toolView.playProgress = currentTime / totalTime;
        weakSelf.playerView.toolView.totalTime = totalTime;
    }];
    
    //监测播放状态与缓冲进度
    [self.currentPlayerItem addObserver:self
                             forKeyPath:@"status"
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    [self.currentPlayerItem addObserver:self
                             forKeyPath:@"loadedTimeRanges"
                                options:NSKeyValueObservingOptionNew
                                context:nil];
}

- (void)destroyPalyer {
    
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
}

#pragma mark - Getter

- (TTPlayerView *)playerView {
    
    if (!_playerView) {
        _playerView = [[TTPlayerView alloc] initWithFrame:CGRectMake(0,
                                                                     TT_TOP_SAFE_HEIGHT,
                                                                     TT_SCREEN_WIDTH,
                                                                     kVideoHeight)];
        _playerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _playerView.toolView.title = self.video.title;
        _playerView.toolView.delegate = self;
    }
    
    return _playerView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGFloat tableX = 0;
        CGFloat tableY = CGRectGetMaxY(self.playerView.frame);
        CGFloat tableW = self.view.bounds.size.width;
        CGFloat tableH = self.view.bounds.size.height - tableY;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCell];
    }
    
    return _tableView;
}

#pragma mark - Setter

- (void)setPlayerStatue:(TTPlayerState)playerStatue {
    
    _playerStatue = playerStatue;
    
    if (self.playerStatue != TTPlayerStateBuffering) {
        [self.playerHud hideAnimated:YES];
    }
}

@end
