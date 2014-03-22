//
//  MazeMadnessTests.m
//  MazeMadnessTests
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMCoreMaze.h"

@interface MazeMadnessTests : XCTestCase

@end

@implementation MazeMadnessTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [NSThread sleepForTimeInterval:1];
}

- (void)testMazeSanity
{
    MMCoreMaze * maze = [[MMCoreMaze alloc]initWithRows:2 andColumns:3];
    XCTAssert(maze != nil);
    
    NSArray * n1 = [maze getNeighborsForCell:[maze getCellForRow:0 andColumn:0]];
    XCTAssert(n1.count == 2);
    XCTAssertEqualObjects(n1[0], [[MMCoreMazeCell alloc]initAtRow:0 andColumn:1]);
    XCTAssertEqualObjects(n1[1], [[MMCoreMazeCell alloc]initAtRow:1 andColumn:0]);
    
    NSLog(@" n1  %@", n1);
    
    
    NSLog(@"all cells %@", [maze getAllCells]);
    
    NSArray *accessible = [maze getNeighborAccessibleForCell:[maze getCellForRow:0 andColumn:0]];
    
    NSLog(@"accsssible %@", accessible);
    
}

@end
