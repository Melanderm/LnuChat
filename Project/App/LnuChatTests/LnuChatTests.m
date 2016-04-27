//
//  LnuChatTests.m
//  LnuChatTests
//
//  Created by Mikael Melander on 2016-03-30.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColorExpanded.h"
#import "ExtraFucntions.h"

@interface LnuChatTests : XCTestCase

@end

@implementation LnuChatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)hexToRgb {
    NSString *hex = @"#00B16A";
    UIColor *result = [UIColorExpanded colorWithHexString:hex];
    UIColor *expectedResult = [UIColor colorWithRed:0/255.0 green:177/255.0 blue:106/255.0 alpha:1];
    
    XCTAssertEqualObjects(result, expectedResult);
}

-(void)firstLettersText{
    //Expecting to get first letter of each word back.
    NSString *expectedResult = @"MM";
    NSString *result = [ExtraFucntions FirstLetters:@"Mikael Melander"];
    
    XCTAssertEqualObjects(result, expectedResult);
}



/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
} */


@end
