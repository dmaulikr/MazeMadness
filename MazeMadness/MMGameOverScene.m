//
//  MMGameOverScene.m
//  MazeMadness
//
//  Created by David Xiang on 3/22/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMGameOverScene.h"
#import "MMMyScene.h"

@implementation MMGameOverScene
-(id)initWithSize:(CGSize)size finalScore:(NSInteger) score{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self runAction:[SKAction playSoundFileNamed:@"smb_gameover.caf" waitForCompletion:YES]];
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        
        myLabel.text = @"Game Over!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) + 70);
        
        [self addChild:myLabel];
        
        
        SKLabelNode *prompt = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        prompt.text = [NSString stringWithFormat:@"Score: %d", score];
        prompt.fontSize = 20;
        prompt.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame) + 22);
        [self addChild:prompt];
        
        
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
