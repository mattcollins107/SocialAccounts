//
//  SOInstagramUser.m
//  FollowerTracker
//
//  Created by Adar Porat on 2/3/13.
//  Copyright (c) 2013 Kosher Penguin LLC. All rights reserved.
//

#import "SOGithubUser.h"

@implementation SOGithubUser

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _userId = [dictionary objectForKey:@"login"]; // [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        _username = [dictionary objectForKey:@"login"];
        _fullname = [dictionary objectForKey:@"login"];
        _profilePicture = [dictionary objectForKey:@"avatar_url"];
    }
    
    return self;
}

@end
