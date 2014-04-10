//
//  Employee.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "Employee.h"

@implementation Employee

#define kImageKey @"Image"
#define kNameKey @"Name"
#define kRoleKey @"Role"
#define kBioKey @"Bio"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_empProfileImage forKey:kImageKey];
    [encoder encodeObject:_empName forKey:kNameKey];
    [encoder encodeObject:_empRole forKey:kRoleKey];
    [encoder encodeObject:_empBio forKey:kBioKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _empProfileImage = [decoder decodeObjectForKey:kImageKey];
    _empName = [decoder decodeObjectForKey:kNameKey];
    _empRole = [decoder decodeObjectForKey:kRoleKey];
    _empBio = [decoder decodeObjectForKey:kBioKey];
    
    return self;
}

@end
