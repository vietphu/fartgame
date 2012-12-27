#import "GameLayer.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer {
    bool carPassing;
    bool farting;
    bool gameOver;
    bool gassing;
    int delay;
    int fart;
    int gas;
    int score;
    float regen;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
    GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
    
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud];
	
    layer.myHUDLayer = hud;
    
    return scene;
}

- (void)addCar
{
    CCSprite * car = [CCSprite spriteWithFile:@"muscle_car.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //int minY = monster.contentSize.height / 2;
    //int maxY = winSize.height - monster.contentSize.height/2;
    //int rangeY = maxY - minY;
    //int actualY = (arc4random() % rangeY) + minY;
    car.position = ccp(winSize.width + car.contentSize.width/2, winSize.height/2);
    [self addChild:car];

    CCMoveTo * actionMove = [CCMoveBy actionWithDuration:2
                                                position:ccp(-(winSize.width+car.contentSize.width),0)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        carPassing = NO;
        //set next car delay
    }];
    [car runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    //[car runAction: [CCMoveBy actionWithDuration:2 position:ccp(-(winSize.width+car.contentSize.width),0)]];
}

- (void)update:(ccTime)dt
{
    if (fart == 100) { // Game Over!
        gameOver = YES;
    }
    
    if (gameOver) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Busted!" fontName:@"Marker Felt" fontSize:30];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 );
		[self addChild: label];
        if (delay == 10) {
            [self unschedule:@selector(update:)];
            CCScene *gameOverScene = [GameOverLayer sceneWithScore:score];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        delay++;
        return;
    }
    
    // Generate random car if no car is passing
    // range 1-10
    if (!carPassing) {
        if ((arc4random() % 20) + 1 == 7) {
            carPassing = YES;
            [[SimpleAudioEngine sharedEngine] playEffect:@"car.caf"]; // 2 sec audio file
            [self addCar];
        }
    }
    else {

    }
    
    score++;
    [self.myHUDLayer updateScoreLabel:score];

    if (farting && fart > 0) {
        if (!carPassing) { // busted!
            //NSLog(@"Busted!");
            gameOver = YES;
        }
        fart--;
        [self.myHUDLayer updateFartLabel:fart];
    }
    
    if (gassing && gas > 0) {
        fart--;
        [self.myHUDLayer updateFartLabel:fart];
        gas--;
        [self.myHUDLayer updateGasLabel:gas];
    }
    
    if (!farting && !gassing) {
        regen++;
        if (regen == 2) { // higher value = slower fart regeneration
            regen = 0;
            fart++;
            [self.myHUDLayer updateFartLabel:fart];
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGSize size = [[CCDirector sharedDirector] winSize];

    if (location.x < size.width/2) {
        farting = YES;
    }
    else {
        gassing = YES;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    farting = NO;
    gassing = NO;
}

-(id) init
{
	if( (self=[super init]) ) {
        // Init vars
        carPassing = NO;
        delay = 0;
        fart = 70;
        farting = NO;
        gameOver = NO;
        gas = 100;
        gassing = NO;
        regen = 0;
        score = 0;
        
        // Enable Touches
        [self setIsTouchEnabled:YES];
        
        // Start Game-loop
        [self schedule:@selector(update:) interval:0.1];
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
