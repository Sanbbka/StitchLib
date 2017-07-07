//
//  RolokysTests.m
//  RolokysTests
//
//  Created by Alexander Drovnyashin on 08.12.16.
//  Copyright © 2016 Alexandr Drovnyashin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CVWrapper.h"

@interface RolokysTests : XCTestCase

@property NSArray *stitchImgs;

@end

@implementation RolokysTests

- (void)setUp {
    [super setUp];
    
    self.stitchImgs = @[[UIImage imageNamed:@"pano_1"],
                        [UIImage imageNamed:@"pano_2"],
                        [UIImage imageNamed:@"pano_3"],
                        [UIImage imageNamed:@"pano_4"]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testWrapEmptyArr {
    
    UIImage *image = [CVWrapper processWithArray:@[]];
    
    XCTAssert(image == nil);
}

- (void)testWrapNotImages {
    
    UIImage *image = [CVWrapper processWithArray:@[@"", @2, [UIColor redColor]]];
    
    XCTAssert(image == nil);
}

- (void)testStitchImages {
    
    UIImage *image = [CVWrapper processWithArray:self.stitchImgs];
    
    XCTAssert(image != nil && [image isKindOfClass:[UIImage class]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self testStitchImages];
    }];
}

@end
