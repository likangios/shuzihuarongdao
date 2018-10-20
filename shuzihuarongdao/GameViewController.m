//
//  GameViewController.m
//  shuzihuarongdao
//
//  Created by perfay on 2018/10/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "GameViewController.h"
#import "ItemButton.h"
#import "GDTMobBannerView.h"
#import "GDTMobInterstitial.h"
@interface GameViewController ()<GDTMobBannerViewDelegate,GDTMobInterstitialDelegate>

@property(nonatomic,strong) UIButton *backButton;

@property(nonatomic,strong) UIButton *refreshButton;

@property(nonatomic,strong) UIImageView *levelImageView;

@property(nonatomic,strong) UIImageView *timeImageView;

@property(nonatomic,strong) UIImageView *stepImageView;

@property(nonatomic,strong) UILabel *timeLabel;

@property(nonatomic,strong) UILabel *stepLabel;

@property(nonatomic,strong) UILabel *levelLabel;


@property(nonatomic,strong) UIImageView *mainGameView;

@property(nonatomic,strong) UIView *containView;

@property(nonatomic,strong) NSMutableArray *buttonsArray;

@property(nonatomic,strong) ItemButton *emptyButton;

@property(nonatomic,strong) UIImageView *bgImageView;

@property(nonatomic,assign) NSInteger step;

@property(nonatomic,assign) NSInteger seconds;

@property(nonatomic,strong) GDTMobBannerView *bannerView;

@property(nonatomic,strong) GDTMobInterstitial *intersitialView;


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.bannerView loadAdAndShow];
    self.buttonsArray = [NSMutableArray array];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.refreshButton];
    [self.view addSubview:self.levelImageView];
    [self.levelImageView addSubview:self.levelLabel];
    [self.view addSubview:self.timeImageView];
    [self.timeImageView addSubview:self.timeLabel];
    [self.view addSubview:self.stepImageView];
    [self.stepImageView addSubview:self.stepLabel];
    [self.view addSubview:self.mainGameView];
    [self.mainGameView addSubview:self.containView];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(48, 51));
    }];
    
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(192/2.0, 109/2.0));
    }];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.levelImageView);
        make.centerY.equalTo(self.levelImageView).offset(0);
    }];
    
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelImageView.mas_bottom).offset(20);
        make.left.equalTo(self.backButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(97, 36));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.timeImageView);
    }];
    [self.stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeImageView);
        make.left.equalTo(self.timeImageView.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(97, 36));
    }];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.stepImageView);
    }];
    [self.mainGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(self.view.bounds.size.width);
        make.height.equalTo(self.mainGameView.mas_width).multipliedBy(53/56.0);
    }];
    CGFloat side = 30;
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kAUTOSCALE_WIDTH(side), kAUTOSCALE_WIDTH(side), kAUTOSCALE_WIDTH(side), kAUTOSCALE_WIDTH(side)));
    }];
    [self.view layoutIfNeeded];

    for (int i = 0; i< self.gameLevel; i++) {
        for (int j = 0; j<self.gameLevel; j++) {
            ItemButton *button = [ItemButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = YES;
            button.adjustsImageWhenDisabled = YES;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:45 - self.gameLevel * 2];
            [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]  forState:UIControlStateNormal];
            button.tag = (i << 8)|j;
            button.currentPosition = (i << 8)|j;
            [button setBackgroundImage:[UIImage imageNamed:@"icon_square"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%ld",i * self.gameLevel + j + 1] forState:UIControlStateNormal];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof ItemButton * _Nullable x) {
                [self itemClickAction:x];
            }];
            if (i+1 == self.gameLevel && j+1 == self.gameLevel) {
                self.emptyButton = button;
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            [self.buttonsArray addObject:button];
        }
    }
    [self refeshItemPosition];
    @weakify(self);
    [RACObserve(self, step) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.stepLabel.text = [NSString stringWithFormat:@"步数:%ld",x.integerValue];
    }];
    [RACObserve(self, seconds) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = [NSString stringWithFormat:@"时间:%ld″",x.integerValue];
        });
    }];
}
dispatch_source_t timer;

- (void)cancelTimer{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}
- (void)resumeTimer{
    [self cancelTimer];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        [self updateGameSeconds];
    });
    dispatch_resume(timer);
}
- (void)updateGameSeconds{
    self.seconds ++;
}
- (void)refeshItemPosition{
    self.seconds = 0;
    [self resumeTimer];
    for (UIView *view in self.containView.subviews) {
        [view removeFromSuperview];
    }
    self.step = 0;
    for (int i = 0; i< self.gameLevel; i++) {
        for (int j = 0; j<self.gameLevel; j++) {
            ItemButton *button = self.buttonsArray[i * self.gameLevel + j];
            button.currentPosition = (i << 8)|j;
            [self.containView addSubview:button];
        }
    }
    NSMutableArray *newButtons =  [self.buttonsArray mutableCopy];
    /*
     3x3  30\60\90
     4x4  40\80\120
     */
    NSInteger randomCount = self.gameLevel * 30 * self.gameType;
    NSLog(@"randomCount:%ld",randomCount);
    while (randomCount) {
        NSInteger empty_button_index = [newButtons indexOfObject:self.emptyButton];
        int empty_button_x = (self.emptyButton.currentPosition >> 8 & 0xF);
        int empty_button_y = (self.emptyButton.currentPosition & 0x0f);
        NSMutableArray *numberArray = [NSMutableArray array];
        if (0 <= (empty_button_x - 1)) {
            [numberArray addObject:@1];
        }
        if (0 <= (empty_button_y - 1)) {
            [numberArray addObject:@2];
        }
        if ((empty_button_x + 1) < self.gameLevel) {
            [numberArray addObject:@3];
        }
        if ((empty_button_y + 1) < self.gameLevel) {
            [numberArray addObject:@4];
        }
//        NSLog(@"当前空白按钮位置(%d,%d)",empty_button_x,empty_button_y);
//        NSLog(@"可用于交换的 方位 数：%ld",numberArray.count);
        NSInteger  randomIndex = arc4random_uniform(numberArray.count);
//        NSLog(@"随机到的数字：%ld",randomIndex);
        NSNumber *randomExchanagedPosition = numberArray[randomIndex];
//        NSLog(@"和%d 方位的按钮交换",randomExchanagedPosition.intValue);
        NSInteger index;
        switch (randomExchanagedPosition.integerValue) {
            case 1:
                index = empty_button_index - self.gameLevel;
                break;
            case 2:
                index = empty_button_index - 1;
                break;
            case 3:
                index = empty_button_index + self.gameLevel;
                break;
            case 4:
                index = empty_button_index + 1;
                break;
            default:
                index = empty_button_index;
                break;
        }
//        NSLog(@"emptyIndex:%ld  buttonIndex:%ld",empty_button_index,index);
        ItemButton *button = newButtons[index];
        NSInteger tempPosition = button.currentPosition;
        button.currentPosition = self.emptyButton.currentPosition;
        self.emptyButton.currentPosition = tempPosition;
        [newButtons  exchangeObjectAtIndex:empty_button_index withObjectAtIndex:index];
        randomCount --;
    }    
    CGFloat buttonWidth = CGRectGetWidth(self.containView.frame)/self.gameLevel;
    CGFloat buttonHeight = buttonWidth * 53 / 56.0;
    
    for (int i = 0; i< self.gameLevel; i++) {
        for (int j = 0; j<self.gameLevel; j++) {
            ItemButton *button = newButtons[i * self.gameLevel + j];
            button.frame = CGRectMake(j * buttonWidth, i * buttonWidth, buttonWidth, buttonHeight);
            [self.containView addSubview:button];
        }
    }
    
}
#pragma mark - action
- (void)itemClickAction:(ItemButton *)button{
    if (button == self.emptyButton) {
        return;
    }
    self.step ++;
    int button_x = (button.currentPosition >> 8 & 0xF);
    int button_y = (button.currentPosition & 0x0f);
    
    int empty_button_x = (self.emptyButton.currentPosition >> 8 & 0xF);
    int empty_button_y = (self.emptyButton.currentPosition & 0x0f);
    
    if ((abs(button_x - empty_button_x) == 1 && button_y == empty_button_y) ||(abs(button_y - empty_button_y) == 1 && button_x == empty_button_x)) {
        NSLog(@"交换位置");
        CGRect tempFrame = button.frame;
        NSInteger tempPosition = button.currentPosition;
        
        [UIView animateWithDuration:0.15 animations:^{
            button.frame = self.emptyButton.frame;
            button.currentPosition = self.emptyButton.currentPosition;
            
            self.emptyButton.frame = tempFrame;
            self.emptyButton.currentPosition = tempPosition;
        }];

    }
    else{
        NSLog(@"不可 移动");
    }
    
    if (self.emptyButton.currentPosition == self.emptyButton.tag) {
        BOOL finish = [self.buttonsArray bk_all:^BOOL(ItemButton *obj) {
            return  obj.currentPosition == obj.tag;
        }];
        if (finish) {
            [self finishGame];
        }
    }
    NSLog(@"button tag :%ld point:(%ld,%ld)",button.tag,(long)button_x,(long)button_y);
}
- (void)finishGame{
    [self cancelTimer];
    [UIAlertView bk_showAlertViewWithTitle:nil message:@"恭喜成功！" cancelButtonTitle:nil otherButtonTitles:@[@"OK"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshGameAction{
    [self.intersitialView presentFromRootViewController:self];
    [self.intersitialView loadAd];
    [self refeshItemPosition];
}
#pragma mark lazy init
-(UIView *)containView{
    if (!_containView) {
        _containView = [UIView new];
        _containView.backgroundColor = [UIColor blackColor];
    }
    return _containView;
}
- (UIImageView *)mainGameView{
    if(!_mainGameView) {
        _mainGameView = [UIImageView new];
        _mainGameView.contentMode = UIViewContentModeScaleAspectFill;
        _mainGameView.image = [UIImage imageNamed:@"bg_369x383_"];
        _mainGameView.userInteractionEnabled = YES;
    }
    return _mainGameView;
}
- (UIImageView *)bgImageView{
    if(!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.image = [UIImage imageNamed:@"home_bg"];
        _bgImageView.clipsToBounds = YES;

    }
    return _bgImageView;
}
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        @weakify(self);
        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self backAction];
        }];
    }
    return _backButton;
}
- (UIButton *)refreshButton{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
        @weakify(self);
        [[_refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self refreshGameAction];
        }];
    }
    return _refreshButton;
}
- (UIImageView *)timeImageView{
    if(!_timeImageView) {
        _timeImageView = [UIImageView new];
        _timeImageView.contentMode = UIViewContentModeScaleToFill;
        _timeImageView.image = [UIImage imageNamed:@"icon_"];
    }
    return _timeImageView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"0″";
        
    }
    return _timeLabel;
}
- (UIImageView *)stepImageView{
    if(!_stepImageView) {
        _stepImageView = [UIImageView new];
        _stepImageView.contentMode = UIViewContentModeScaleToFill;
        _stepImageView.image = [UIImage imageNamed:@"icon_"];
    }
    return _stepImageView;
}
- (UILabel *)stepLabel{
    if (!_stepLabel) {
        _stepLabel = [UILabel new];
        _stepLabel.font = [UIFont systemFontOfSize:13];
        _stepLabel.textColor = [UIColor whiteColor];
        _stepLabel.textAlignment = NSTextAlignmentCenter;
        _stepLabel.text = @"0";
    }
    return _stepLabel;
}
- (UIImageView *)levelImageView{
    if(!_levelImageView) {
        _levelImageView = [UIImageView new];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImageView.image = [UIImage imageNamed:@"icon_3x3"];
    }
    return _levelImageView;
}
- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [UILabel new];
        _levelLabel.font = [UIFont boldSystemFontOfSize:25];
        _levelLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75] ;
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.text = [NSString stringWithFormat:@"%ld X %ld",self.gameLevel,self.gameLevel];
    }
    return _levelLabel;
}

- (GDTMobBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[GDTMobBannerView alloc]initWithAppId:ad_appkey placementId:placementid_banner];
        _bannerView.delegate = self;
        _bannerView.currentViewController = self;
        _bannerView.interval = 30;
        _bannerView.isGpsOn = NO;
    }
    return _bannerView;
}
- (GDTMobInterstitial *)intersitialView{
    if (!_intersitialView) {
        _intersitialView = [[GDTMobInterstitial alloc]initWithAppId:ad_appkey placementId:placementid_center];
        _intersitialView.delegate = self;
        _intersitialView.isGpsOn = NO;
        [_intersitialView loadAd];
    }
    return _intersitialView;
}
#pragma mark - ad delegate
- (void)bannerViewDidReceived{
    NSLog(@"banner---请求广告成功");
}
- (void)bannerViewFailToReceived:(NSError *)error{
    NSLog(@"banner---请求广告失败：%@",error.description);
}
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial{
    NSLog(@"插屏---请求广告成功");
}
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error{
    NSLog(@"插屏---请求广告失败：%@",error.description);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
