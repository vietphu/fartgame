#import "HUDLayer.h"


@implementation HUDLayer
{
    CCLabelTTF *fartLabel;
    CCProgressTimer *fartBar;
    CCProgressTimer *gasBar;
    CCLabelTTF *gasLabel;
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
    [fartLabel setString:[NSString stringWithFormat:@"Fart: %d",fart]];
    [fartBar setPercentage:fart];
}

-(void) updateGasLabel:(int)gas {
    [gasLabel setString:[NSString stringWithFormat:@"Gas: %d",gas]];
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
        
        // Fart bar
        fartBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"green_health_bar.png"]];
        fartBar.type = kCCProgressTimerTypeBar;
        fartBar.midpoint = ccp(0,0);
        fartBar.position = ccp(60, size.height - 70);
        fartBar.barChangeRate = ccp(1,0);
        fartBar.scale = 5;
        fartBar.percentage = 70;
        [self addChild:fartBar];

        // Gas bar
        gasBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"red_health_bar.png"]];
        gasBar.type = kCCProgressTimerTypeBar;
        gasBar.midpoint = ccp(0,0);
        gasBar.position = ccp(60, size.height - 100);
        gasBar.barChangeRate = ccp(1,0);
        gasBar.scale = 5;
        gasBar.percentage = 100;
        [self addChild:gasBar];

        
        // Score Label
        scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:20];
        scoreLabel.position =  ccp( size.width - 50 , size.height - 20 );
		[self addChild: scoreLabel];

        // Fart Label
        fartLabel = [CCLabelTTF labelWithString:@"Fart: 100" fontName:@"Marker Felt" fontSize:16];
        fartLabel.position =  ccp( 30 , size.height - 20 );
        fartLabel.horizontalAlignment = kCCTextAlignmentLeft;
		[self addChild: fartLabel];

        // Gas Label
        gasLabel = [CCLabelTTF labelWithString:@"Gas: 100" fontName:@"Marker Felt" fontSize:16];
        gasLabel.position =  ccp( 30 , size.height - 40 );
		[self addChild: gasLabel];
    }
	return self;
}

@end
