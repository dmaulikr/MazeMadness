//
//  MMCoreMaze.m
//  MazeMadness
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMCoreMaze.h"

@interface MMCoreMaze ()
@property NSMutableArray *cells;
@property NSMutableArray *visited;
@property NSMutableArray *adjacenyList;
@end

@implementation MMCoreMaze{
    NSInteger __maxStackSizeOnInit;
    MMCoreMazeCell * __farthestCell;
}
    

-(id) initWithRows:(NSInteger)rows andColumns:(NSInteger)columns
{
    self = [super init];
    if(!self) return nil;
    _rows = rows;
    _columns = columns;
    __maxStackSizeOnInit = 0;
    
    NSInteger numElements = _rows*_columns;
    
    // Initialize cells
    self.cells = [NSMutableArray arrayWithCapacity:numElements];
    for(int i = 0; i < _rows; ++i){
        for(int j = 0; j < _columns; ++j){
            [self.cells addObject:[[MMCoreMazeCell alloc]initAtRow:i andColumn:j]];
        }
    }
    
    // Initialize visited
    //self.visited = [NSMutableArray arrayWithCapacity:numElements];
    //for(int i = 0; i < _rows; ++i){
    //    for(int j = 0; j < _columns; ++j){
    //        [self.visited addObject:@NO];
    //    }
    // }
    
    // Initialize adjaceny list
    self.adjacenyList = [NSMutableArray arrayWithCapacity:numElements];
    for(int i = 0; i < _rows; ++i){
        for(int j = 0; j < _columns; ++j){
            MMCoreMazeCell* currentCell = [self getCellForRow:i andColumn:j];
            [self.adjacenyList addObject:[self setupNeighborsForCell:currentCell]];
        }
    }
    
    // Initialize the maze
    [self initializeCoreMaze];
    
    
    
    return self;
}
-(NSArray*)getNeighborsForCell:(MMCoreMazeCell*)node
{
    if(node){
        return self.adjacenyList[node.row * self.columns + node.column];
    }else{
        return nil;
    }
}

-(NSArray*)getAllCells
{
    return self.cells;
}

-(MMCoreMazeCell*)getEndPointCell
{
    return __farthestCell;
}

-(MMCoreMazeCell*) getCellForRow:(NSInteger)row andColumn:(NSInteger)column
{
    if(row >= 0 && row < self.rows && column >= 0 && column < self.columns){
        return self.cells[row * self.columns + column];
    }else{
        return nil;
    }
}

#pragma mark - Private
-(void)knockDownWall:(MMCoreMazeCell*)cell andNeighbor:(MMCoreMazeCell*)cell2
{
    
    // If cell is left of cell 2
    if(cell.column == cell2.column - 1){
        cell.hasRightWall = NO;
        cell2.hasLeftWall = NO;
    }
    
    // If cell is right of cell 2
    else if(cell.column == cell2.column + 1){
        cell.hasLeftWall = NO;
        cell2.hasRightWall = NO;
    }
    
    // If cell is top of cell 2
    else if(cell.row == cell2.row - 1){
        cell.hasBottomWall = NO;
        cell2.hasTopWall = NO;
    }
    
    // If cell is bottom of cell 2
    else if(cell.row == cell2.row + 1){
        cell.hasTopWall = NO;
        cell2.hasBottomWall = NO;
    }
    
}

-(void)initializeCoreMaze
{
    
    NSMutableArray * stack = [NSMutableArray array];
    NSInteger totalCells = self.rows * self.columns;
    MMCoreMazeCell* currentCell = [self getCellForRow:0 andColumn:0];
    NSInteger visitedCells = 1;
    
    while(visitedCells < totalCells){
        NSMutableArray * neighborsIntact = [NSMutableArray array];
        for(MMCoreMazeCell * neighbor in [self getNeighborsForCell:currentCell]){
            if([neighbor allWallsStillUp]){
                [neighborsIntact addObject:neighbor];
            }
        }
        
        if(neighborsIntact.count >= 1){
            NSInteger randomNumber = arc4random() % (neighborsIntact.count);
            MMCoreMazeCell * neighbor = neighborsIntact[randomNumber];
            [self knockDownWall:currentCell andNeighbor:neighbor];
            [stack addObject:currentCell];
            
            if(stack.count > __maxStackSizeOnInit){
                __maxStackSizeOnInit = stack.count;
                __farthestCell = currentCell;
            }
            
            currentCell = neighbor;
            visitedCells++;
        }else{
            
            MMCoreMazeCell* popCell = [stack lastObject];
            [stack removeLastObject];
            currentCell = popCell;
        }
    }
    
}

-(NSArray*)setupNeighborsForCell:(MMCoreMazeCell *)node{
    
    NSInteger row = node.row;
    NSInteger column = node.column;
    
    NSMutableArray *neighbors = [NSMutableArray array];
    
    if(column - 1 >= 0){
        // [neighbors addObject:[self getCellForRow:row*self.rows + column -1]];
        [neighbors addObject:[self getCellForRow:row andColumn:column - 1]];
    }
    
    if(column + 1 < self.columns){
        //[neighbors addObject:self.cells[row*self.rows + column+1]];
        [neighbors addObject:[self getCellForRow:row andColumn:column + 1]];
    }
    
    if(row - 1 >= 0){
        //[neighbors addObject:self.cells[(row-1)*self.rows + column]];
        [neighbors addObject:[self getCellForRow:row - 1 andColumn:column]];
    }
    
    if(row + 1 < self.rows){
        //[neighbors addObject:self.cells[(row+1)*self.rows + column]];
        [neighbors addObject:[self getCellForRow:row + 1 andColumn:column]];
    }
    return neighbors;
}

@end


@implementation MMCoreMazeCell

-(NSString*)description{
    return [NSString stringWithFormat:@"Cell at [%ld,%ld] with LW:%d RW:%d TW:%d BW:%d",
           self.row, self.column, self.hasLeftWall, self.hasRightWall, self.hasTopWall, self.hasBottomWall];
}


-(id)initAtRow:(NSInteger)row andColumn:(NSInteger)column
{
    self = [super init];
    if(!self) return nil;
    _row = row;
    _column = column;
    _hasBottomWall = YES;
    _hasTopWall = YES;
    _hasLeftWall = YES;
    _hasRightWall = YES;
    return self;
}

-(BOOL)isEqual:(id)object{
    if(object == self){
        return YES;
    }
    
    if(![object isKindOfClass:[self class]]){
        return NO;
    }
    
    MMCoreMazeCell* compare = (MMCoreMazeCell*)object;
    return self.row == compare.row && self.column == compare.column;
}

-(BOOL)allWallsStillUp
{
    return self.hasBottomWall && self.hasTopWall && self.hasLeftWall && self.hasRightWall;
}
@end