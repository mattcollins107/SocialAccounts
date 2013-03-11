//
// Copyright 2011-2012 Adar Porat (https://github.com/aporat)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SOFoursquareAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFFoursquareAPIBaseURLString = @"https://api.foursquare.com/v2/";

@implementation SOFoursquareAPIClient

+ (SOFoursquareAPIClient *)sharedClient {
    static SOFoursquareAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SOFoursquareAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFFoursquareAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    return self;
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    
    NSMutableDictionary* params = [parameters mutableCopy];
    [params setObject:@"20130310" forKey:@"v"];
    
    NSMutableURLRequest* request = [super requestWithMethod:method path:path parameters:params];
 
    
    
    return request;
}


@end
