//
//  MMWelcomeScreen.m
//  MazeMadness
//
//  Created by David Xiang on 3/22/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMWelcomeScreen.h"
#import "MMMyScene.h"

@implementation MMWelcomeScreen

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        
        myLabel.text = @"M A Z E - M A D N E S S";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) + 70);
        
        [self addChild:myLabel];
        
        
        SKLabelNode *prompt = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        prompt.text = @"Drag your finger to the";
        prompt.fontSize = 20;
        prompt.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame) + 22);
        [self addChild:prompt];
        
        
        SKLabelNode *prompt2 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        prompt2.text = @"finish as fast as possible";
        prompt2.fontSize = 20;
        prompt2.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [self addChild:prompt2];

        
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
        playButton.anchorPoint = CGPointMake(.5,.5);
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 80);
        
        [self addChild:playButton];
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKScene * mainGameScene = [[MMMyScene alloc]initWithSize:self.view.bounds.size andTimeLimit:20 score:0];
    mainGameScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:mainGameScene];
}


@end
