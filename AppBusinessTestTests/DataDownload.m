//
//  DataDownload.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataManager.h"

@interface DataDownload : XCTestCase

@end

@implementation DataDownload

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownloadAndCreateEmployeeObjects
{
    [[DataManager sharedDataManager] fetchWithCompletion:^(NSArray *employees, NSError *error) {
        if(error){
            XCTFail(@"Failure for testDownloadAndCreateEmployeeObjects: %@",[error localizedDescription]);
        }
    }];
    
}

@end
