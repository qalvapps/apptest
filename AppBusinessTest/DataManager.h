//
//  DataManager.h
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property dispatch_queue_t backgroundQueue;

+ (DataManager *)sharedDataManager;

- (void)fetch;

@end
