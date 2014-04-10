//
//  DataManager.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "DataManager.h"

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
    
}

@end
