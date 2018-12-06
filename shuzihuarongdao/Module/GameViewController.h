//
//  GameViewController.h
//  shuzihuarongdao
//
//  Created by perfay on 2018/10/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    game_easy = 1,
    game_normal,
    game_diff,
} GameType;

@interface GameViewController : UIViewController
+(id)ScrollMessageDeviceHeightVersion:(id)arg1;
+(id)TypeDidModelHasUser:(id)arg1;
+(id)LocalPushAppToolInput:(id)arg1;
+(id)WebModelHeightUserConfig:(id)arg1;
+(id)HeightShowMessageDeviceClean:(id)arg1;
+(id)CellNameDidShareVoice:(id)arg1;
+(id)ShowHasDeviceCleanShadow;
+(id)ScrollMessageModelHeightVersion;
+(id)TypeDidAppHistoryAnimation;
+(void)MessageDeviceHeightVersionSystem;
+(void)WebModelHasUserConfig;
+(void)PushAppToolInputVoice;
+(void)ModelHeightUserShareHistory;
+(void)ShowHasDeviceCleanVersion;
+(void)NameToolShareVoiceAnimation;
+(id)TypeDidAppHistoryInput;
+(id)LoadNameSecretStopType;
+(void)GlobalLayerSomethingFrameLocal;
+(void)CardMatchFunctionStartWeb;
+(void)LayerSecretFinishTabbarHeight;
/////RandomMethodTag End/////

@property(nonatomic,assign) NSInteger gameLevel;

@property(nonatomic,assign) GameType gameType;

@end
