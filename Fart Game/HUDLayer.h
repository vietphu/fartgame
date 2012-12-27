#import "cocos2d.h"

@interface HUDLayer : CCLayer

+(CCScene *) scene;
-(void) updateFartLabel:(int)fart;
-(void) updateGasLabel:(int)gas;
-(void) updateScoreLabel:(int)score;

@end
