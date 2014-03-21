//
//  MMMyScene.m
//  MazeMadness
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMMyScene.h"
#import "MMCoreMaze.h"

static const CGFloat MMMySceneCellSize = 40;
static const CGFloat MMMySceneMargin = 20;

@interface MMMyScene()
@property MMCoreMaze * maze;
@end

@implementation MMMyScene

#pragma mark - SKScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.anchorPoint = CGPointMake(0,1);
        
        NSInteger numCols = ((self.size.width - 2*MMMySceneMargin) / MMMySceneCellSize);
        NSInteger numRows = ((self.size.height - 2*MMMySceneMargin) / MMMySceneCellSize);
        
        _maze = [[MMCoreMaze alloc]initWithRows:numRows andColumns:numCols];
       
        [self drawMaze];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - UIResponder
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

#pragma mark - Private
-(void)drawMaze
{
    for(NSInteger i = 0; i < _maze.rows; ++i){
        for(NSInteger j = 0; j < _maze.columns; ++j){
            MMCoreMazeCell * cell = [_maze getCellForRow:i andColumn:j];
            
            if([cell isEqual:[_maze getEndPointCell]])
            {
                SKSpriteNode *end = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
                end.anchorPoint = CGPointMake(.5,.5);
                end.position  = CGPointMake((cell.column)*MMMySceneCellSize + MMMySceneMargin + MMMySceneCellSize/2 , -((cell.row)*MMMySceneCellSize + MMMySceneMargin + MMMySceneCellSize/2));
                [self addChild:end];
            }
            
            if(i == 0 && j == 0){
                SKSpriteNode *start = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)];
                start.anchorPoint = CGPointMake(.5,.5);
                start.position  = CGPointMake(MMMySceneMargin + MMMySceneCellSize/2 , -(MMMySceneMargin + MMMySceneCellSize/2));
                [self addChild:start];
            }
            
            // Draw right border
            if([cell hasRightWall]){
                SKSpriteNode *rightBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(1, MMMySceneCellSize)];
                rightBorder.anchorPoint = CGPointMake(0, 1);
                rightBorder.position  = CGPointMake((j+1)*MMMySceneCellSize + MMMySceneMargin, -((i)*MMMySceneCellSize + MMMySceneMargin));
                [self addChild:rightBorder];
            }
            
            // Draw a left border
            if([cell hasLeftWall]){
                SKSpriteNode *leftBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(1, MMMySceneCellSize)];
                leftBorder.anchorPoint = CGPointMake(0, 1);
                leftBorder.position  = CGPointMake((j)*MMMySceneCellSize + MMMySceneMargin, -(i*MMMySceneCellSize + MMMySceneMargin));
                [self addChild:leftBorder];
            }
            
            // Draw a top border
            if([cell hasTopWall]){
                SKSpriteNode *topBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(MMMySceneCellSize,1)];
                topBorder.anchorPoint = CGPointMake(0, 0);
                topBorder.position  = CGPointMake(j*MMMySceneCellSize + MMMySceneMargin, -((i)*MMMySceneCellSize + MMMySceneMargin));
                [self addChild:topBorder];
            }
            
            // Draw a bottom border
            if([cell hasBottomWall]){
                SKSpriteNode *bottomBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(MMMySceneCellSize,1)];
                bottomBorder.anchorPoint = CGPointMake(0, 0);
                bottomBorder.position  = CGPointMake(j*MMMySceneCellSize + MMMySceneMargin, -( (i+1)*MMMySceneCellSize + MMMySceneMargin));
                [self addChild:bottomBorder];
            }
        }
    }
}

@end
