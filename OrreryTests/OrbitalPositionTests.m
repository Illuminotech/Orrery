//
//  OrbitalPositionTests.m
//  OrreryTests
//
//  Created by Michael Golden on 1/8/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OrbitalPositions.h"

@interface OrbitalPositionTests : XCTestCase

@end

@implementation OrbitalPositionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOrbitalPosition {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *testDate = [dateFormatter dateFromString: @"1990-04-20 00:00:00 GMT"];
    
    OrbitalPositions *op = [OrbitalPositions new];
    SCNVector3 vect = [op cartisianPositionForPlanet:CBMercury atDate:testDate];
    
    XCTAssert(vect.x == -0.3678210314710112);
    XCTAssert(vect.y == 0.061084117493213248);
    XCTAssert(vect.z == 0.038699069206331406);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
