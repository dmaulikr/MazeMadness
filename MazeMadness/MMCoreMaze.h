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

// Get all neighbors for this cell, can go through walls
-(NSArray*)getNeighborsForCell:(MMCoreMazeCell*)node;

// Get neighbors for this cell which don't have a wall in between
-(NSArray*)getNeighborAccessibleForCell:(MMCoreMazeCell*)node;

// Is cell2 accessible from cell
-(BOOL)isAccessible:(MMCoreMazeCell*)cell andNeighbor:(MMCoreMazeCell*)cell2;

// Cell for particular row
-(MMCoreMazeCell*) getCellForRow:(NSInteger)row andColumn:(NSInteger)column;

// All cells
-(NSArray*)getAllCells;

// Get furthest point from the start of the maze (0,0)
-(MMCoreMazeCell*)getEndPointCell;

@property (readonly) NSInteger rows;
@property (readonly) NSInteger columns;

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