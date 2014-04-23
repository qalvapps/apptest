//
//  DataManager.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "DataManager.h"
#import "TFHpple.h"
#import "Employee.h"

// this would ordinarly be defined in a seperate constants file but as its the only constant as such, stick it here

#define kDataSourceURL @"http://www.theappbusiness.com/our-team/"
#define kPersistedDataFilename @"currentemployees.txt"
#define kArchiveObjectKey @"EmployeeData"
#define kArchiveDataKey @"emplyees"

@implementation DataManager

+ (DataManager *)sharedDataManager
{
	static DataManager *sharedDataManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedDataManager = [[DataManager alloc] init];
	});
	return sharedDataManager;
}

- (void)fetchWithCompletion:(void (^)(NSArray *employees, NSError *error))completion {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithURL:[NSURL URLWithString:kDataSourceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if (!error) {
            
            if ([data length] > 0) {
                
                NSLog(@"all good. unpack and create employee objects");
                
                self.theEmployees = [NSMutableArray arrayWithArray:[self employeesFromHtmlData:data]];
            
                //NSLog(@"theEmployess %@",self.theEmployees);
                
                if ([self deleteArchivedDataWithFilename:kPersistedDataFilename]) {
                    [self archiveModelData:self.theEmployees withFilename:kPersistedDataFilename];
                } else {
                    // handle error
                }
                
                if (completion) {
                    completion(self.theEmployees, nil);
                }
            }
        } else {
            // handle error
            NSLog(@"error. unarchiving data");
            
            self.theEmployees = [NSMutableArray arrayWithArray:[self employeesFromArchivedModelDataWithFilename:kPersistedDataFilename]];
            
            if (completion) {
                completion(self.theEmployees, nil);
            }
        }
    }];
    
    [getDataTask resume];
}

#pragma mark turn html into employee objects

- (NSArray*)employeesFromHtmlData:(NSData*)data {
    
    NSMutableArray *retArray = [NSMutableArray array];
    
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:data];
    NSString *usersXpathQueryString = @"//section [@id='users']/div[@class='wrapper']/div[@class='row']/div[@class='col col2']";
    //NSString *imagesXpathQueryString = @"//section [@id='users']/div[@class='wrapper']/div[@class='row']/div[@class='col col2']/div[@class='title']//img/@src";
    NSArray *usersNodes = [htmlParser searchWithXPathQuery:usersXpathQueryString];
    
    for (TFHppleElement * element in usersNodes) {
        
        TFHppleElement *imgElement = [[element firstChildWithClassName:@"title"] firstChildWithTagName:@"img"];
        
        NSString *src = [imgElement objectForKey:@"src"];
        NSString *name = [element firstChildWithTagName:@"h3"].text;
        NSString *role = [element firstChildWithTagName:@"p"].text;
        NSString *bio = [element firstChildWithClassName:@"user-description"].text;
        
        //NSLog(@"src: %@", src);
        //NSLog(@"name is: %@", name);
        //NSLog(@"role: %@", role);
        //NSLog(@"bio: %@", bio);
        
        Employee *anEmployee = [[Employee alloc] init];
        anEmployee.empProfileImage = src;
        anEmployee.empName = name;
        anEmployee.empRole = role;
        anEmployee.empBio = bio;
        
        [retArray addObject:anEmployee];
    }
    
    return retArray;
}

#pragma mark simple archiving

// PC note ordinarily i would probs use core data but this will suffice for the test

- (BOOL)deleteArchivedDataWithFilename:(NSString*)filename {
    
    NSString *filePath = [self docFilePath:filename];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists) {
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        
        if (error) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)archiveModelData:(NSArray*)theData withFilename:(NSString*)filename {
    
    NSString *filePath = [self docFilePath:filename];

    NSMutableDictionary *dataToSave = [NSMutableDictionary dictionary];
    
    if (theData) {
        [dataToSave setObject:theData forKey:kArchiveDataKey];
    }
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archive encodeObject:dataToSave forKey:kArchiveObjectKey];
    [archive finishEncoding];
    
    BOOL result = [data writeToFile:filePath atomically:YES];
    
    return result;    
}

- (NSArray*)employeesFromArchivedModelDataWithFilename:(NSString*)filename {
    
    NSString *filePath = [self docFilePath:filename];
    
    NSData* codedData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (codedData != NULL) {
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        
        NSDictionary* unarchivedModelData = [unarchiver decodeObjectForKey:kArchiveObjectKey];
        
        if (([unarchivedModelData objectForKey:kArchiveDataKey]) && ([unarchivedModelData objectForKey:kArchiveDataKey] != [NSNull null])) {
            NSArray *dataArray = [unarchivedModelData objectForKey:kArchiveDataKey];
            return dataArray;
        }
    }
    
    return nil;
}

- (NSString*)docFilePath:(NSString*)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,filename];
    
    return filePath;
}

@end
