#import "HUDLayer.h"


@implementation HUDLayer
{
    //CCLabelTTF *fartLabel;
    CCProgressTimer *fartBar;
    CCProgressTimer *gasBar;
    //CCLabelTTF *gasLabel;
    CCLabelTTF *scoreLabel;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HUDLayer *layer = [HUDLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) updateFartLabel:(int)fart {
    //[fartLabel setString:[NSString stringWithFormat:@"Fart: %d",fart]];
    [fartBar setPercentage:fart];
}

-(void) updateGasLabel:(int)gas {
    //[gasLabel setString:[NSString stringWithFormat:@"Gas: %d",gas]];
    [gasBar setPercentage:gas];
}

-(void) updateScoreLabel:(int)score
{
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %d",score]];
}

-(id) init
{
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];

        // Bars Interface
        CCSprite *bars = [CCSprite spriteWithFile:@"bars.png"];
        bars.anchorPoint = ccp(0,0);
        bars.position = ccp(10,size.height-35);
        [self addChild:bars];

        // Fart bar
        fartBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"bar-fart.png"]];
        fartBar.anchorPoint = ccp(0,0);
        fartBar.type = kCCProgressTimerTypeBar;
        fartBar.midpoint = ccp(0,0);
        fartBar.position = ccp(12, size.height-22);
        fartBar.barChangeRate = ccp(1,0);
        fartBar.percentage = 70;
        [self addChild:fartBar];

        // Gas bar
        gasBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"bar-gas.png"]];
        gasBar.anchorPoint = ccp(0,0);
        gasBar.type = kCCProgressTimerTypeBar;
        gasBar.midpoint = ccp(0,0);
        gasBar.position = ccp(12, size.height-33);
        gasBar.barChangeRate = ccp(1,0);
        gasBar.percentage = 100;
        [self addChild:gasBar];
        
        // Score Label
        scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:20];
        scoreLabel.color = ccc3(0,0,0);
        scoreLabel.position =  ccp( size.width - 50 , size.height - 20 );
		[self addChild: scoreLabel];
    }
	return self;
}

@end
