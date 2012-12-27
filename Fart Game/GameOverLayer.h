#import "cocos2d.h"

@interface GameOverLayer : CCLayer

+(CCScene *) sceneWithScore:(int)score;
- (id)initWithScore:(int)score;

@end
