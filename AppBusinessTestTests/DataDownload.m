//
//  DataDownload.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataManager.h"
#import "Employee.h"

#define kTestPersistedDataFilename @"testcurrentemployees.txt"
#define kTestEmpName @"Paul"
#define kTestEmpRole @"CEO"
#define kTestEmpBio @"Born Awesome"
#define kTestProfileImage @""

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

- (void)testDeleteEmployeeArchive {
    
    BOOL result = [[DataManager sharedDataManager] deleteArchivedDataWithFilename:kTestPersistedDataFilename];
    
    if (!result){
        XCTFail(@"Failure for testDeleteEmployeeArchive");
    }
}

- (void)testEmployeeArchive {
    
    Employee *testEmployee = [[Employee alloc] init];
    testEmployee.empName = kTestEmpName;
    testEmployee.empRole = kTestEmpRole;
    testEmployee.empBio = kTestEmpBio;
    testEmployee.empProfileImage = kTestProfileImage;
    
    BOOL result = [[DataManager sharedDataManager] archiveModelData:@[testEmployee] withFilename:kTestPersistedDataFilename];
    
    if (!result){
        XCTFail(@"testEmployeeArchive");
    }
}

- (void)testEmployeeUnArchive {
    
    NSArray *testEmployees = [[DataManager sharedDataManager] employeesFromArchivedModelDataWithFilename:kTestPersistedDataFilename];
    
    if (!testEmployees){
        XCTFail(@"testEmployeeArchive no employees");
    } else {
        Employee *testEmployee = testEmployees[0];
    
        if ([testEmployee.empName isEqualToString:kTestEmpName] && [testEmployee.empRole isEqualToString:kTestEmpRole] && [testEmployee.empBio isEqualToString:kTestEmpBio] ) {
            
        } else {
            XCTFail(@"testEmployeeArchive not expected employee");
        }
    }
}

@end
