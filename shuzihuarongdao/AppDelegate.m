//
//  AppDelegate.m
//  shuzihuarongdao
//
//  Created by perfay on 2018/10/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "AppDelegate.h"
#import "GDTSplashAd.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AdSupport/AdSupport.h>
#import "HRDCTManager.h"
@interface AppDelegate ()<GDTSplashAdDelegate>
@property(nonatomic,strong) NSDictionary *launchOptions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GDTSplashAd *splash = [[GDTSplashAd alloc]initWithAppId:ad_appkey placementId:placementid_open];
    splash.delegate = self;
    splash.fetchDelay = 3;
    [splash loadAdAndShowInWindow:self.window];
    self.launchOptions = launchOptions;
    [self initCloud];
    [self initCloudSettingData];
    [self luckTempMethodHelloworld];
    
    return YES;
}
-(void)luckTempMethodHelloworld{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"luckMethod"];
    if ([number.stringValue isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"luckMethod"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"luckMethod"];
    }
}
- (void)initCloud{
    [AVOSCloud setApplicationId:@"qul5URmksGr5q7Ow7VnX5YrU-gzGzoHsz" clientKey:@"iyczScYMD93QjrsugGApaVuj"];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    NSString *udid = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    [self loginWithName:udid pwd:@"123456"];
}
- (void)initCloudSettingData{
    HRDCTManager *manager = [HRDCTManager sharInstance];
    NSString *appkey = [manager appkey];
    self.yinsitiaokuanUrl = [manager tiaokuan];
    self.push = [manager isPush];
    self.url = [manager url];
    //test
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil];
    [self initNoitficationApplication:appkey];
    
}
- (void)loginWithName:(NSString *)name pwd:(NSString *)pwd
{
    NSError *error;
    [AVUser logInWithUsername:name password:pwd error:&error];
    if (error) {
        NSLog(@"========login error is %@",error.description);
        if (error.code == 211) {
            AVUser *user = [[AVUser alloc]init];
            user.username = name;
            user.password = @"123456";
            [user signUp:&error];
            NSLog(@"========signUp error is %@",error.description);
            if (error) {
                //                注册失败 稍后再试
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loginWithName:name pwd:pwd];
                });
            }
            else{
                //                注册成功马上登录
                [self loginWithName:name pwd:pwd];
            }
        }
        else{
            //登录失败 稍后再试
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginWithName:name pwd:pwd];
            });
        }
    }
    else{
        //        登录成功
        NSString *nickName = [[UIDevice currentDevice] name];
        [[AVUser currentUser] setObject:nickName forKey:@"nickName"];
        [[AVUser currentUser] save];
        NSLog(@"========登录 成功 ！！！");
    }
}
- (void)initNoitficationApplication:(NSString *)appkey{
    
    [UMConfigure initWithAppkey:appkey channel:@"App Store"];
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:self.launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"获取token成功:%@",[deviceToken.description stringByReplacingOccurrencesOfString:@" " withString:@""]);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"获取token失败：error:%@",error.description);
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    NSLog(@"开屏广告展示成功");
}
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"开屏广告展示失败：%@",error.description);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
