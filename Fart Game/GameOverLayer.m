#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import "MenuLayer.h"

@implementation GameOverLayer

+(CCScene *) sceneWithScore:(int)score {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithScore:score] autorelease];
    [scene addChild: layer];
    return scene;
}

- (void) startGame: (CCMenuItem  *) menuItem
{
    CCScene *gameScene = [GameLayer scene];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) goHome: (CCMenuItem  *) menuItem
{
    CCScene *menuScene = [MenuLayer scene];
    [[CCDirector sharedDirector] replaceScene:menuScene];
}

- (id)initWithScore:(int)score {
    if ((self = [super init])) {
        
        // Play sound: Oops!
        [[SimpleAudioEngine sharedEngine] playEffect:@"oops.caf"];
        
        NSString * message;
        message = @"Game Over!";
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Marker Felt" fontSize:64];
        label.position = ccp(winSize.width/2, winSize.height- 100);

        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d",score] fontName:@"Marker Felt" fontSize:18];
        scoreLabel.position = ccp(winSize.width/2, winSize.height- 160);
        
        [self addChild:label];
        [self addChild:scoreLabel];
        
        CCLabelTTF *tryAgain = [CCLabelTTF labelWithString:@"Try Again" fontName:@"Marker Felt" fontSize:24];
        CCMenuItemLabel *retry = [CCMenuItemLabel itemWithLabel:tryAgain target:self selector:@selector(startGame:)];
        
        CCLabelTTF *home = [CCLabelTTF labelWithString:@"Home" fontName:@"Marker Felt" fontSize:24];
        CCMenuItemLabel *goHome = [CCMenuItemLabel itemWithLabel:home target:self selector:@selector(goHome:)];
        
        CCMenu *menu = [CCMenu menuWithItems:goHome, retry, nil];
        [menu alignItemsHorizontallyWithPadding:50];
        menu.position = ccp(winSize.width/2, 100);
        [self addChild:menu];

//        
//        [self runAction:
//         [CCSequence actions:
//          [CCDelayTime actionWithDuration:3],
//          [CCCallBlockN actionWithBlock:^(CCNode *node) {
//             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
//         }],
//          nil]];
    }
    return self;
}

@end
