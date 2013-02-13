//
//  SODribbbleUser.m
//  UniversalFollowers
//
//  Created by Adar Porat on 2/9/13.
//  Copyright (c) 2013 Kosher Penguin LLC. All rights reserved.
//

#import "SODribbbleUser.h"

@implementation SODribbbleUser

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _userId = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        _username = [dictionary objectForKey:@"username"];
        _fullname = [dictionary objectForKey:@"name"];
        _profilePicture = [dictionary objectForKey:@"avatar_url"];
    }
    
    return self;
}

@end
