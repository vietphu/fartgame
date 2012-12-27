#import "cocos2d.h"
#import "HUDLayer.h"

@interface GameLayer : CCLayer

@property (nonatomic, retain) HUDLayer *myHUDLayer;

//@property (assign) BOOL farting;

+(CCScene *) scene;

@end
