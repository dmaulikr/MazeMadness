//
//  MMCoreMaze.h
//  MazeMadness
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMCoreMazeCell;

@interface MMCoreMaze : NSObject

// Initializes with a specific dimensions
-(id)initWithRows:(NSInteger)rows andColumns:(NSInteger)columns;

-(NSArray*)getNeighborsForCell:(MMCoreMazeCell*)node;

-(MMCoreMazeCell*) getCellForRow:(NSInteger)row andColumn:(NSInteger)column;

@property (readonly) NSInteger rows;
@property (readonly) NSInteger columns;

-(NSArray*)getAllCells;

-(MMCoreMazeCell*)getEndPointCell;

@end


@interface MMCoreMazeCell: NSObject

-(id)initAtRow:(NSInteger)row andColumn:(NSInteger)column;

@property BOOL hasLeftWall;
@property BOOL hasRightWall;
@property BOOL hasTopWall;
@property BOOL hasBottomWall;;

@property (readonly) NSInteger row;
@property (readonly) NSInteger column;

-(BOOL)allWallsStillUp;

@end