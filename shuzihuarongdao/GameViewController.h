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

@property(nonatomic,assign) NSInteger gameLevel;

@property(nonatomic,assign) GameType gameType;


@end
