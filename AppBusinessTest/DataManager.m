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

- (void)fetch {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithURL:[NSURL URLWithString:kDataSourceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if (!error) {
            
            if ([data length] > 0) {
                
                self.theEmployees = [NSMutableArray array];
                
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
                    
                    [self.theEmployees addObject:anEmployee];
                }
                
                NSLog(@"theEmployess %@",self.theEmployees);
            }
        } else {
            // handle error
        }
    }];
    
    [getDataTask resume];
}

@end
