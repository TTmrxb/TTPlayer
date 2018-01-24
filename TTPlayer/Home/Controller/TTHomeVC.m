//
//  TTHomeVC.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/20.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import "TTHomeVC.h"

#import "TTPlayerVC.h"
#import "TTVideoModel.h"

#import "UIColor+TT.h"
#import "TTAlertHud.h"
#import "TTConfiguration.h"

static NSString * const kDefaultCell = @"DefaultCell";

@interface TTHomeVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoArr;

@end

@implementation TTHomeVC

#pragma mark - Life Cycle

- (void)loadView {
    
    [super loadView];
    
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadVideoData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCell
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //调整cell分割线左右顶格
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    TTVideoModel *video = self.videoArr[indexPath.row];
    cell.textLabel.text = video.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTPlayerVC *playerVC = [[TTPlayerVC alloc] init];
    playerVC.video = self.videoArr[indexPath.row];
    [self.navigationController pushViewController:playerVC animated:YES];
}

#pragma mark - Networking

- (void)loadVideoData {
    
    [[TTAlertHud sharedAlertHud] showHudAddTo:self.tableView animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(loadVideoDataSuccess)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)loadVideoDataSuccess {
    
    [[TTAlertHud sharedAlertHud] dismissAnimated:YES];
    
    TTVideoModel *video1 = [[TTVideoModel alloc] init];
    NSString *videoPath1 = [[NSBundle mainBundle] pathForResource:@"紫砂壶鉴赏"
                                                           ofType:@"MP4"];
    NSDictionary *videoInfo1 = @{kVideoUrl : videoPath1 ? videoPath1 : @"",
                                kVideoTitle : @"すばらしい！滑らかな紫の壺鑑賞",
                                kVideoTotalTime : @(8 * 60 + 47)};
    [video1 configWithVideoInfo:videoInfo1];
    [self.videoArr addObject:video1];
    
    TTVideoModel *video2 = [[TTVideoModel alloc] init];
    NSString *videoPath2 = [[NSBundle mainBundle] pathForResource:@"五年奋斗历程"
                                                           ofType:@"MP4"];
    NSDictionary *videoInfo2 = @{kVideoUrl : videoPath2 ? videoPath2 : @"" ,
                                kVideoTitle : @"先生の物語月火水はメールだけで 木金ずっと放っとかれてて",
                                kVideoTotalTime : @(56 * 60 + 9)};
    [video2 configWithVideoInfo:videoInfo2];
    [self.videoArr addObject:video2];
    
    [self.tableView reloadData];
}

#pragma mark - Getter

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCell];
    }
    
    return _tableView;
}

- (NSMutableArray *)videoArr {
    
    if (!_videoArr) {
        _videoArr = [NSMutableArray array];
    }
    
    return _videoArr;
}

@end
