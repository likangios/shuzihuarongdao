//
//  DiffViewController.m
//  shuzihuarongdao
//
//  Created by perfay on 2018/10/18.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "DiffViewController.h"
#import "GameViewController.h"
@interface DiffViewController ()
@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIImageView *bgImageView;
@end

@implementation DiffViewController

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
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIView * subView = [[UIView alloc]init];
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton *lastBtn;
    NSArray *diff = @[@"简单",@"普通",@"困难"];
    for (int i = 0; i< diff.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [subView addSubview:btn];
        btn.tag = i + 1;
        [btn setImage:[UIImage imageNamed:@"icon_"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kAUTOSCALE_WIDTH(243*0.8), 118*0.8));
            if (lastBtn) {
                make.top.equalTo(lastBtn.mas_bottom).offset(30);
            }
            else{
                make.top.mas_equalTo(0);
            }
        }];
        UILabel *label = [UILabel new];
        label.text = diff[i];
        label.textColor = [[UIColor orangeColor] colorWithAlphaComponent:0.6];
        label.font = [UIFont boldSystemFontOfSize:30];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.centerY.equalTo(btn.mas_centerY).offset(3);
        }];
        lastBtn = btn;
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self HRD_pushToGameMainViewControllerWithType:x.tag];
        }];
    }
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
    }];
}
- (void)HRD_pushToGameMainViewControllerWithType:(NSInteger)type{
    GameViewController *game =[[GameViewController alloc]init];
    game.gameLevel = self.gameLevel;
    game.gameType = type;
    [self.navigationController pushViewController:game animated:YES];
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
