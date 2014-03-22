//
//  MMMyScene.m
//  MazeMadness
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMMyScene.h"
#import "MMGameOverScene.h"
#import "MMCoreMaze.h"

static const CGFloat MMMySceneCellSize = 35;
static const CGFloat MMMySceneMarkerSize = 15;
static const CGFloat MMMySceneMarginHorizontal = 21.5;
static const CGFloat MMMySceneMarginVertical = 20;

@interface MMMyScene()
@property MMCoreMaze * maze;
@property NSMutableArray *markers;
@property NSMutableArray *markersShowing;
@property MMCoreMazeCell *startCell;
@property MMCoreMazeCell *endCell;
@property MMCoreMazeCell *currentCell;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property NSTimeInterval timeLeft;
@property NSTimeInterval maxTime;
@property SKLabelNode *timeLeftLabel;
@property SKLabelNode *scoreLabel;
@property NSTimeInterval updateInterval;
@property NSInteger score;
@end

@implementation MMMyScene

#pragma mark - SKScene
-(id)initWithSize:(CGSize)size andTimeLimit:(NSTimeInterval)time score:(NSInteger)score
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // Scene anchor is set up in the top left to make maze layout correspond more closely to row
        // major ordering
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.anchorPoint = CGPointMake(0,1);
        
        NSInteger numCols = ((self.size.width - 2*MMMySceneMarginHorizontal) / MMMySceneCellSize);
        NSInteger numRows = ((self.size.height - 2*MMMySceneMarginVertical) / MMMySceneCellSize);
        
        _maze = [[MMCoreMaze alloc]initWithRows:numRows andColumns:numCols];
       
        [self initMazeInScene];
        
        // Init count down
        _timeLeftLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _timeLeft = time;
        _maxTime = _timeLeft;
        _timeLeftLabel.text = [NSString stringWithFormat:@"%.2f", _timeLeft];
        _timeLeftLabel.fontSize = 80;
        _timeLeftLabel.alpha = 0.5;
        _updateInterval = 0;
        _timeLeftLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:_timeLeftLabel];
        
        // Init count down
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _scoreLabel.text = [NSString stringWithFormat:@"Levels Completed: %ld", (long)score];
        _scoreLabel.fontSize = 14;
        _scoreLabel.alpha = 1;
        _scoreLabel.position = CGPointMake(CGRectGetWidth(self.frame)/2, -(CGRectGetHeight(self.frame) - 5));
        [self addChild:_scoreLabel];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    /* Called before each frame is rendered */
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

-(void) updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast{
    if(self.updateInterval > .1){
        self.timeLeft -= self.updateInterval;
        
        if(self.timeLeft <= 0 ){
            //game over
            SKScene * gameover = [[MMGameOverScene alloc]initWithSize:self.view.bounds.size];
            gameover.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:gameover];
        }else if(self.timeLeft <= 4){
            self.timeLeftLabel.fontColor = [UIColor redColor];
        }
        
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%.2f", self.timeLeft];
        self.updateInterval = 0;
    }{
        self.updateInterval += timeSinceLast;
    }
}

#pragma mark - UIResponder
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if([event allTouches].count ==1){
        UITouch *touch = [touches anyObject];
        [self trackTouch:touch];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}

#pragma mark - Private

-(void)trackTouch:(UITouch*)touch
{
    MMCoreMazeCell *cellUnderTouch = [self getCellForTouch:touch];
    MMCoreMazeCell *prev = self.currentCell;
    if(cellUnderTouch && ![cellUnderTouch isEqual:self.currentCell]){
        
        // Check if cell under touch is accessible from the current cell
        NSArray * neighbors = [self.maze getNeighborAccessibleForCell:self.currentCell];
        for(MMCoreMazeCell * neighbor in neighbors){
            if([cellUnderTouch isEqual:neighbor]){
                // Cell we are touching is an accessible neighbor to the current cell
                MMCoreMazeCell * newCurrentCell = cellUnderTouch;
                
                // Update the new current cell
                [self updateCurrentCellAtRow:cellUnderTouch.row andColumn:cellUnderTouch.column];
                if(![self isMarkerShowing:newCurrentCell.row andColumn:newCurrentCell.column]){
                    [self showMarkerAtRow:newCurrentCell.row andColumn:newCurrentCell.column];
                } else{
                    [self hideMarkerAtRow:prev.row andColumn:prev.column];
                }
                
                // Win
                if([newCurrentCell isEqual:self.endCell]){
                    
                    // Play win sound
                    
                    SKScene * mainGameScene = [[MMMyScene alloc]initWithSize:self.view.bounds.size andTimeLimit:self.maxTime * .95 score:self.score + 1];
                    mainGameScene.scaleMode = SKSceneScaleModeAspectFill;
                    [self.view presentScene:mainGameScene];
                }
                
            }
        }
    }
}

-(MMCoreMazeCell*)getCellForTouch:(UITouch*)touch
{
    MMCoreMazeCell *location = nil;
    CGPoint touchLoc = [touch locationInNode:self];
    CGFloat absY = fabsf(touchLoc.y);
    CGFloat absX = fabsf(touchLoc.x);
    // Touch must be in bounds of maze
    if((absX > MMMySceneMarginHorizontal) &&
       (absX < (self.size.width - MMMySceneMarginHorizontal)) &&
       (absY > MMMySceneMarginVertical) &&
       (absY < (self.size.height - MMMySceneMarginVertical)))
    {
        NSInteger mazeColumn = (touchLoc.x - MMMySceneMarginHorizontal) / MMMySceneCellSize ;
        NSInteger mazeRow = (absY - MMMySceneMarginVertical) / MMMySceneCellSize;
        
        //NSLog(@"maze column count %d,",mazeColumn);
        //NSLog(@"maze column count %d,",mazeRow);
        
        //[self showMarkerAtRow:mazeRow andColumn:mazeColumn
        location = [self.maze getCellForRow:mazeRow andColumn:mazeColumn];
    }
    
    return location;
}

-(void)hideMarkerAtRow:(NSInteger)row andColumn:(NSInteger)column{
    [_markers[row * _maze.columns + column] setAlpha:0];
    _markersShowing[row * _maze.columns + column] = @NO;
}

-(void)showMarkerAtRow:(NSInteger)row andColumn:(NSInteger)column{
    [_markers[row * _maze.columns + column] setAlpha:1];
    _markersShowing[row * _maze.columns + column] = @YES;
}

-(BOOL)isMarkerShowing:(NSInteger)row andColumn:(NSInteger)column{
    if([self.markersShowing[row * self.maze.columns + column] isEqual:@YES]){
        return YES;
    }else{
        return NO;
    }
}

-(SKSpriteNode*)getNodeAtRow:(NSInteger)row andColumn:(NSInteger)column{
    return self.markers[row * self.maze.columns + column];
}

-(void)updateCurrentCellAtRow:(NSInteger)row andColumn:(NSInteger)column{
    // remove aura from old current cell
    if(self.currentCell){
        [ [self getNodeAtRow:self.currentCell.row  andColumn:self.currentCell.column] removeActionForKey:@"aura"];
        [[self getNodeAtRow:self.currentCell.row andColumn:self.currentCell.column] runAction:[SKAction scaleTo:1 duration:0]];
    }
    
    // re assign new current
    self.currentCell = [self.maze getCellForRow:row andColumn:column];
    
    // start aura'ing
    SKAction* grow = [SKAction scaleTo:1.4 duration:0.3];
    SKAction*shrink =[SKAction scaleTo:1 duration:0.3];
    SKAction*sequence = [SKAction sequence:@[grow, shrink]];
    [[self getNodeAtRow:row andColumn:column] runAction:[SKAction repeatActionForever:sequence] withKey:@"aura" ];
}

-(void)initMazeInScene
{
    _markers = [NSMutableArray array];
    _markersShowing = [NSMutableArray array];
    
    for(NSInteger i = 0; i < _maze.rows; ++i){
        for(NSInteger j = 0; j < _maze.columns; ++j){
            MMCoreMazeCell * cell = [_maze getCellForRow:i andColumn:j];
            
            SKSpriteNode* newMarker = [SKSpriteNode spriteNodeWithImageNamed:@"ball_yellow"];
            newMarker.anchorPoint = CGPointMake(0.5, 0.5);
            newMarker.alpha = 0.5;
            newMarker.size = CGSizeMake(MMMySceneMarkerSize, MMMySceneMarkerSize);
            newMarker.position =  CGPointMake((cell.column)*MMMySceneCellSize + MMMySceneMarginHorizontal + MMMySceneCellSize/2 , -((cell.row)*MMMySceneCellSize + MMMySceneMarginVertical + MMMySceneCellSize/2));
            [self addChild:newMarker];
            [_markers addObject:newMarker];
            [_markersShowing addObject:@NO];
            
            [self hideMarkerAtRow:i andColumn:j];
            
            if([cell isEqual:[_maze getEndPointCell]])
            {
                SKSpriteNode *end = [SKSpriteNode spriteNodeWithImageNamed:@"finish_flag"];
                end.size = CGSizeMake(MMMySceneMarkerSize + 4, MMMySceneMarkerSize+4);
                end.anchorPoint = CGPointMake(.5,.5);
                end.position  = CGPointMake((cell.column)*MMMySceneCellSize + MMMySceneMarginHorizontal + MMMySceneCellSize/2 , -((cell.row)*MMMySceneCellSize + MMMySceneMarginVertical + MMMySceneCellSize/2));
                [self addChild:end];
                _endCell = cell;
            }
            
            if(i == 0 && j == 0){
                [self showMarkerAtRow:i andColumn:j];
                _startCell = cell;
                _endCell = cell;
                _currentCell = cell;
                
                [self updateCurrentCellAtRow:0 andColumn:0];
                
            }
            
            // Draw right border
            if([cell hasRightWall]){
                SKSpriteNode *rightBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(1, MMMySceneCellSize)];
                rightBorder.anchorPoint = CGPointMake(0, 1);
                rightBorder.position  = CGPointMake((j+1)*MMMySceneCellSize + MMMySceneMarginHorizontal, -((i)*MMMySceneCellSize + MMMySceneMarginVertical));
                [self addChild:rightBorder];
            }
            
            // Draw a left border
            if([cell hasLeftWall]){
                SKSpriteNode *leftBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(1, MMMySceneCellSize)];
                leftBorder.anchorPoint = CGPointMake(0, 1);
                leftBorder.position  = CGPointMake((j)*MMMySceneCellSize + MMMySceneMarginHorizontal, -(i*MMMySceneCellSize + MMMySceneMarginVertical));
                [self addChild:leftBorder];
            }
            
            // Draw a top border
            if([cell hasTopWall]){
                SKSpriteNode *topBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(MMMySceneCellSize,1)];
                topBorder.anchorPoint = CGPointMake(0, 0);
                topBorder.position  = CGPointMake(j*MMMySceneCellSize + MMMySceneMarginHorizontal, -((i)*MMMySceneCellSize + MMMySceneMarginVertical));
                [self addChild:topBorder];
            }
            
            // Draw a bottom border
            if([cell hasBottomWall]){
                SKSpriteNode *bottomBorder = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(MMMySceneCellSize,1)];
                bottomBorder.anchorPoint = CGPointMake(0, 0);
                bottomBorder.position  = CGPointMake(j*MMMySceneCellSize + MMMySceneMarginHorizontal, -( (i+1)*MMMySceneCellSize + MMMySceneMarginVertical));
                [self addChild:bottomBorder];
            }
        }
    }
}

@end
