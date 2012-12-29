#import "GameLayer.h"
#import "GameOverLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer {
    CCSprite *boy;
    CCSprite *girl;
    bool driving;
    bool farting;
    bool gassing;
    int fart; //fart bar length
    int fartScore;
    int fartSound; //fart loop
    int gas;
    int gasSound;
    int score;
    float regen;
}

#pragma mark End Game

- (void)gameOver:(ccTime)dt
{
    [self unschedule:@selector(gameOver:)];
    CCScene *gameOverScene = [GameOverLayer sceneWithScore:score];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];

}

- (void)endGame
{
    // Disable touches
    [self setIsTouchEnabled:NO];
    
    // Finish fart sound but end loop
    [self playFart];
    alSourcei(fartSound, AL_LOOPING, 0);
    
    // Unschedule update
    [self unschedule:@selector(update:)];

    // Unschedule traffic
    [self unschedule:@selector(addCar:)];

    // Show Oops & Angry
    [boy setTexture:[[CCTextureCache sharedTextureCache] addImage:@"boy_oops.png"]];
    [girl setTexture:[[CCTextureCache sharedTextureCache] addImage:@"girl_angry.png"]];
    
    // Clean sprites/scenes?

    // Show Game Over after 3 seconds
    [self schedule:@selector(gameOver:) interval:3];
}

#pragma mark Sound Control

- (void)playFart
{
    if (!fartSound) {
        fartSound = [[SimpleAudioEngine sharedEngine] playEffect:@"fart.caf"];
        alSourcei(fartSound, AL_LOOPING, 1);
    }
    else {
        ALint state;
        alGetSourcei(fartSound, AL_SOURCE_STATE, &state);
        if (state != AL_PLAYING) {
            alSourcePlay(fartSound);
        }
    }
}

- (void)pauseFart
{
    if (fartSound) {
        ALint state;
        alGetSourcei(fartSound, AL_SOURCE_STATE, &state);
        if (state == AL_PLAYING) {
            alSourcePause(fartSound);
        }
    }
}

# pragma mark Game Control

- (void)fart:(ccTime)dt
{
    fartScore += fartScore;
}

- (void)endFart
{
    farting = NO;
    [self unschedule:@selector(fart:)];
    //Add Score
    score += fartScore;
    fartScore = 25; // Reset
    [self.myHUDLayer updateScoreLabel:score];

}

- (void)addCar:(ccTime)dt
{
    [self unschedule:@selector(addCar:)];
    
    // Create car
    driving = YES;
    CCSprite * car = [CCSprite spriteWithFile:@"car_small.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    car.position = ccp(winSize.width + car.contentSize.width/2, winSize.height/2-5);
    [self addChild:car];

    // Movement
    CCMoveTo * actionMove = [CCMoveBy actionWithDuration:2 position:ccp(-(winSize.width+car.contentSize.width),0)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        driving = NO;
        [self schedule:@selector(addCar:) interval:((arc4random() % (3)) + 1)]; // Schedule next car //( (arc4random() % (max-min+1)) + min )
    }];
    
    // Run
    [[SimpleAudioEngine sharedEngine] playEffect:@"car.caf"]; // 2 sec audio file
    [car runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)addScore
{
    [self.myHUDLayer updateScoreLabel:score];    
}

- (void)update:(ccTime)dt
{
    // Game Over!
    if (fart == 100) { [self endGame]; return; }

    // Fart
    if (farting && fart > 0)
    {
        //Busted
        if (!driving) { [self endGame]; return; }
        else {
            fart--;
            [self playFart];
            [self.myHUDLayer updateFartLabel:fart];
        }
    }
    
    // Gas
    if (gassing && gas > 0) {
        fart--;
        [self.myHUDLayer updateFartLabel:fart];
        gas--;
        [self.myHUDLayer updateGasLabel:gas];
    }
    
    // Regen
    if (!farting && !gassing) {
        regen++;
        if (regen == 1) { // higher value = slower fart regeneration
            regen = 0;
            fart++;
            [self.myHUDLayer updateFartLabel:fart];
        }
    }
}

#pragma mark Handle Touches

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGSize size = [[CCDirector sharedDirector] winSize];
    if (location.x < size.width/2) { farting = YES; [self schedule:@selector(fart:) interval:0.5]; }
    else { gassing = YES; }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (farting) {
        [self endFart];
    }
    gassing = NO;
    [self pauseFart];
}

#pragma mark Init

-(id) init
{
	if( (self=[super init]) ) {
        // Init vars
        driving = NO;
        farting = NO;
        gassing = NO;
        
        fart = 60;
        gas = 100;
        score = 0;
        
        fartScore = 25;
        regen = 0;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Enable Touches
        [self setIsTouchEnabled:YES];
        
        // Start Game-loop
        [self schedule:@selector(update:) interval:0.1];

        // Set Background
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
        bg.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:bg];

        // Set People
        boy = [CCSprite spriteWithFile:@"boy.png"];
        girl = [CCSprite spriteWithFile:@"girl.png"];
        boy.position = ccp(80,120);
        girl.position = ccp(190,120);
        [self addChild:boy z:15];
        [self addChild:girl z:16];
        
        // Traffic
        [self schedule:@selector(addCar:) interval:1]; // First car after 1 second
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
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

@end
