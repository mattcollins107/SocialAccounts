//
//  SOInstagramUser.m
//  FollowerTracker
//
//  Created by Adar Porat on 2/3/13.
//  Copyright (c) 2013 Kosher Penguin LLC. All rights reserved.
//

#import "SOInstagramUser.h"

@implementation SOInstagramUser

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _userId = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        _username = [dictionary objectForKey:@"username"];
        _fullname = [dictionary objectForKey:@"full_name"];
        _profilePicture = [dictionary objectForKey:@"profile_picture"];
    }
    
    return self;
}

@end
