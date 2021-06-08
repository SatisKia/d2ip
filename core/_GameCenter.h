/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class _Main;

@interface _GameCenter : NSObject <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
@private
	_Main* _m;
}

- (id)initWithMain:(_Main*)m;
- (BOOL)isAvailable;
- (void)auth;
- (void)disable;
- (void)reportAchievement:(NSString*)identifier :(float)percent;
- (void)resetAchievements;
- (void)showAchievementView;
- (void)reportScore:(NSString*)category :(int64_t)score;
- (void)showLeaderboardView:(NSString*)category;
- (void)showLeaderboardView;

@end
