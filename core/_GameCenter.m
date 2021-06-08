/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GameCenter.h"

#import "_Canvas.h"
#import "_Main.h"

@implementation _GameCenter

- (id)initWithMain:(_Main*)m
{
	self = [super init];
	if( self != nil )
	{
		_m = m;
	}
	return self;
}

/*
 * Game Center クラスが利用可能かどうかのテスト
 */
- (BOOL)isAvailable
{
	// GKLocalPlayer クラスが存在するかどうかをチェックする
	BOOL class = (NSClassFromString( @"GKLocalPlayer" ) != nil);

	// デバイスは iOS 4.1 以降で動作していなければならない
	NSString* reqVer = @"4.1";
	NSString* curVer = [[UIDevice currentDevice] systemVersion];
	BOOL ver = ([curVer compare:reqVer options:NSNumericSearch] != NSOrderedAscending);

	return (class && ver);
}

/*
 * ローカルプレーヤーの認証
 */
- (void)auth
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	[localPlayer authenticateWithCompletionHandler:^( NSError* error ){
		if( localPlayer.isAuthenticated )
		{
			[_m _gameCenterAuthOK];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _gameCenterAuthOK];
			}
		}
		else
		{
			[_m _gameCenterAuthNG];
			if( [_m getCurrent] != nil )
			{
				[[_m getCurrent] _gameCenterAuthNG];
			}
		}
	}];
}
- (void)disable
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	[localPlayer authenticateWithCompletionHandler:nil];
}

/*
 * アチーブメントの達成状況の報告
 */
- (void)reportAchievement:(NSString*)identifier :(float)percent
{
#ifdef NO_OBJC_ARC
	GKAchievement* achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
#else
	GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
#endif // NO_OBJC_ARC
	if( achievement != nil )
	{
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^( NSError* error ){
			if( error != nil )
			{
				[_m _gameCenterReportAchievementNG:identifier :percent];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _gameCenterReportAchievementNG:identifier :percent];
				}
			}
			else
			{
				[_m _gameCenterReportAchievementOK:identifier :percent];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _gameCenterReportAchievementOK:identifier :percent];
				}
			}
		}];
	}
}

/*
 * アチーブメントの達成状況のリセット
 */
- (void)resetAchievements
{
	[GKAchievement resetAchievementsWithCompletionHandler:^( NSError* error ){}];
}

/*
 * 標準アチーブメントビューの表示
 */
- (void)showAchievementView
{
	GKAchievementViewController* achievements = [[GKAchievementViewController alloc] init];
	if( achievements != nil )
	{
		achievements.achievementDelegate = self;

		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] clearTouch];
		}

		[[_m getViewController] presentModalViewController:achievements animated:YES];

#ifdef NO_OBJC_ARC
		[achievements release];
#endif // NO_OBJC_ARC
	}
}
- (void)achievementViewControllerDidFinish:(GKAchievementViewController*)viewController
{
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] clearTouch];
	}

	[[_m getViewController] dismissModalViewControllerAnimated:YES];

	[_m _gameCenterCloseAchievementView];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _gameCenterCloseAchievementView];
	}
}

/*
 * スコアの報告
 */
- (void)reportScore:(NSString*)category :(int64_t)score
{
#ifdef NO_OBJC_ARC
	GKScore* scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
#else
	GKScore* scoreReporter = [[GKScore alloc] initWithCategory:category];
#endif // NO_OBJC_ARC
	if( scoreReporter != nil )
	{
		scoreReporter.value = score;
		[scoreReporter reportScoreWithCompletionHandler:^( NSError *error ){
			if( error != nil )
			{
				[_m _gameCenterReportScoreNG:category :score];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _gameCenterReportScoreNG:category :score];
				}
			}
			else
			{
				[_m _gameCenterReportScoreOK:category :score];
				if( [_m getCurrent] != nil )
				{
					[[_m getCurrent] _gameCenterReportScoreOK:category :score];
				}
			}
		}];
	}
}

/*
 * 標準 Leaderboard ビューの表示
 */
- (void)showLeaderboardView:(NSString*)category
{
	GKLeaderboardViewController* leaderboardController = [[GKLeaderboardViewController alloc] init];
	if( leaderboardController != nil )
	{
		leaderboardController.leaderboardDelegate = self;
		leaderboardController.category = category;

		if( [_m getCurrent] != nil )
		{
			[[_m getCurrent] clearTouch];
		}

		[[_m getViewController] presentModalViewController:leaderboardController animated:YES];
	}
#ifdef NO_OBJC_ARC
	[leaderboardController release];
#endif // NO_OBJC_ARC
}
- (void)showLeaderboardView
{
	[self showLeaderboardView:nil];
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] clearTouch];
	}

	[[_m getViewController] dismissModalViewControllerAnimated:YES];

	[_m _gameCenterCloseLeaderboardView];
	if( [_m getCurrent] != nil )
	{
		[[_m getCurrent] _gameCenterCloseLeaderboardView];
	}
}

@end
