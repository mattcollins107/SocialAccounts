//
//  SOInstagramUser.h
//  FollowerTracker
//
//  Created by Adar Porat on 2/3/13.
//  Copyright (c) 2013 Kosher Penguin LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOUser.h"

@interface SOInstagramUser : NSObject <SOUser>

@property (nonatomic, readonly, strong) NSString *userId;
@property (nonatomic, readonly, strong) NSString *username;
@property (nonatomic, readonly, strong) NSString *fullname;
@property (nonatomic, readonly, strong) NSString *firstName;
@property (nonatomic, readonly, strong) NSString *lastName;
@property (nonatomic, readonly, strong) NSString *profilePicture;

@end
