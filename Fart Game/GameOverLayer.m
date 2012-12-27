#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameOverLayer

+(CCScene *) sceneWithScore:(int)score {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithScore:score] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithScore:(int)score {
    if ((self = [super init])) {
        
        // Play sound: Oops!
        [[SimpleAudioEngine sharedEngine] playEffect:@"oops.caf"];
        
        NSString * message;
        //if (won) {
        //    message = @"You Won!";
        //} else {
            message = @"Game Over!";
        //}
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        //label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
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
