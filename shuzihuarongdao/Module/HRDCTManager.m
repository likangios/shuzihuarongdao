//
//  HRDCTManager.m
//  LeanCloudDemo
//
//  Created by perfay on 2018/9/4.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "HRDCTManager.h"
#import <AVOSCloud/AVOSCloud.h>

static HRDCTManager *shareInstance;

static CGFloat Second_Day = 24 * 60 * 60;


@implementation HRDCTManager
+(void)HelpUpdateOffetFinishMatch{
}
+(void)AnimationErrorDatasCardDismiss{
}
+(void)SystemCommonGlobalLayerSomething{
}
+(void)ErrorOffetCardMatchFunction{
}
+(void)CacheDatasUpdateDismissFinish{
}
-(id)RecordDoSomethingNameBack:(id)arg1{
NSString *obj=[[NSString alloc]init];
return obj;
}
-(id)DismissFunctionTabbarHeightStop:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(id)OffetFinishMatchinsertStart:(id)arg1{
NSSet *obj=[[NSSet alloc]init];
return obj;
}
-(id)LoadNameSecretStopLocal:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(id)FinishLayerSomethingFrameBack:(id)arg1{
NSSet *obj=[[NSSet alloc]init];
return obj;
}
-(id)CardMatchFunctionStartHeight:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(void)LayerUserCleanShadowDo:(id)arg1{
}
-(void)ToolInputVoiceHelpUpdate:(id)arg1{
}
-(id)UserConfigShadowAnimationError:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(id)DeviceCleanVersionSystemCommon:(id)arg1{
NSString *obj=[[NSString alloc]init];
return obj;
}
-(id)ShareVoiceAnimationErrorOffet:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(id)AppHistoryInputCacheHelp:(id)arg1{
NSSet *obj=[[NSSet alloc]init];
return obj;
}
-(id)HeightVersionConfigRecordDo:(id)arg1{
NSArray *obj=[[NSArray alloc]init];
return obj;
}
-(id)HistoryAnimationCacheDatasUpdate:(id)arg1{
NSSet *obj=[[NSSet alloc]init];
return obj;
}
-(id)ToolInputVoiceHelpError:(id)arg1{
NSString *obj=[[NSString alloc]init];
return obj;
}
/////RandomMethodTag End/////

+ (instancetype)HRD_sharInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HRDCTManager alloc]init];
    });
    [shareInstance HRD_luckTempMethodHelloworld];
    return shareInstance;
}
-(void)HRD_luckTempMethodHelloworld{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"luckMethod"];
    if ([number.stringValue isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:@"luckMethod"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"luckMethod"];
    }
}
- (BOOL)HRD_isPush{
    AVObject *classObject = [AVObject objectWithClassName:@"PushContro"];
    [classObject refresh];
    NSArray *object = [classObject objectForKey:@"results"];
    if (object.count) {
        NSNumber *isPush = [object[0] objectForKey:@"isPush"];
        return isPush.boolValue;
    }
    return  NO;
}
- (NSString *)url{
    AVObject *classObject = [AVObject objectWithClassName:@"PushContro"];
    [classObject refresh];
    NSArray *object = [classObject objectForKey:@"results"];
    NSString *url;
    if (object.count) {
        url = [object[0] objectForKey:@"url"];
    }
    return  url;
}
- (NSString *)appkey{
    AVObject *classObject = [AVObject objectWithClassName:@"PushContro"];
    [classObject refresh];
    NSArray *object = [classObject objectForKey:@"results"];
    NSString *appkey;
    if (object.count) {
        appkey = [object[0] objectForKey:@"appkey"];
    }
    return  appkey;
}
- (NSString *)tiaokuan{
    AVObject *classObject = [AVObject objectWithClassName:@"PushContro"];
    [classObject refresh];
    NSArray *object = [classObject objectForKey:@"results"];
    NSString *tiaokuan;
    if (object.count) {
        tiaokuan = [object[0] objectForKey:@"tiaokuan"];
    }
    return  tiaokuan;
}
- (BOOL)vipIsValidWith:(NSString *)username{
    NSError *error;
    AVUser *user = [AVUser logInWithUsername:username password:@"123456" error:&error];
    user = [AVUser currentUser];
    NSNumber *diff = [user objectForKey:@"diff"];
    NSDate *creatData = user.createdAt;
    NSDate *now = [NSDate date];
    if(now.timeIntervalSince1970 > (creatData.timeIntervalSince1970 + diff.intValue * Second_Day )){
        return NO;
    }
    else{
        return YES;
    }
}
- (BOOL)isEnable{
    NSError *error;
    AVUser *user = [AVUser logInWithUsername:@"123456" password:@"123456" error:&error];
    user = [AVUser currentUser];
    NSNumber *able = [user objectForKey:@"enable"];
    return able.boolValue;
}
- (NSString *)testName{
    AVUser *user = [AVUser currentUser];
    NSString *name = [user objectForKey:@"TestName"];
    return name;
}

@end
