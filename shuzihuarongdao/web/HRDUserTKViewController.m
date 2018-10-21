//
//  HRDUserTKViewController.m
//  yezjk
//
//  Created by perfay on 2018/10/12.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "HRDUserTKViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"

@interface HRDUserTKViewController ()

@property(nonatomic,strong) WKWebView *webView;

@property(nonatomic,strong) UIButton *confirmButton;


@end

@implementation HRDUserTKViewController

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"阅读并同意隐私政策" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.backgroundColor = [UIColor purpleColor];
    }
    return _confirmButton;
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.allowsLinkPreview = false;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.confirmButton];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.yinsitiaokuanUrl.length) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:app.yinsitiaokuanUrl]]];
    }
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
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
