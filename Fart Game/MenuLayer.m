// Import the interfaces
#import "MenuLayer.h"
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - MenuLayer

@implementation MenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MenuLayer *layer = [MenuLayer node];
	[scene addChild: layer];
	return scene;
}

- (void) startGame: (CCMenuItem  *) menuItem
{
	//NSLog(@"The first menu was called");
    CCScene *gameScene = [GameLayer scene];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) showHelp: (CCMenuItem *)menuItem
{
    NSLog(@"Show help");
    CCSprite *help = [CCSprite spriteWithFile:@"help.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //int minY = monster.contentSize.height / 2;
    //int maxY = winSize.height - monster.contentSize.height/2;
    //int rangeY = maxY - minY;
    //int actualY = (arc4random() % rangeY) + minY;
    help.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:help];

}

-(void) setUpMenu
{
    CCLabelTTF *newGame = [CCLabelTTF labelWithString:@"New Game" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *start = [CCMenuItemLabel itemWithLabel:newGame target:self selector:@selector(startGame:)];

    CCLabelTTF *help = [CCLabelTTF labelWithString:@"Help" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *showHelp = [CCMenuItemLabel itemWithLabel:help target:self selector:@selector(showHelp:)];

    CCMenu *menu = [CCMenu menuWithItems:start, showHelp, nil];
    [menu alignItemsVertically];
    [self addChild:menu];
}

-(id) init
{
	if( (self=[super init]) ) {
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Fart Game" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height - 100 );
		
		// add the label as a child to this Layer
		[self addChild: label];

		[self setUpMenu];
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		//[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			
//			
//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//			
//			[achivementViewController release];
//		}
//									   ];
//        
//		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
		//							   ];
		
		//CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		//[menu alignItemsHorizontallyWithPadding:20];
		//[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		//[self addChild:menu];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

//-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
//
//-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
@end
