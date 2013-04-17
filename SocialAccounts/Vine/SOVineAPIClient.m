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

#import "SOVineAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFVineAPIBaseURLString = @"https://api.vineapp.com/";

@implementation SOVineAPIClient

+ (SOVineAPIClient *)sharedClient {
    static SOVineAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SOVineAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFVineAPIBaseURLString]];
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

- (void)getPath:(NSString *)path
     sessionId:(NSString *)sessionId
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    NSMutableURLRequest* urlRequest = [request mutableCopy];
    [urlRequest setValue:sessionId forHTTPHeaderField:@"vine-session-id"];

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
       sessionId:(NSString *)sessionId
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    NSMutableURLRequest* urlRequest = [request mutableCopy];
    [urlRequest setValue:sessionId forHTTPHeaderField:@"vine-session-id"];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)deletePath:(NSString *)path
         sessionId:(NSString *)sessionId
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    NSMutableURLRequest* urlRequest = [request mutableCopy];
    [urlRequest setValue:sessionId forHTTPHeaderField:@"vine-session-id"];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    NSMutableURLRequest* request = [urlRequest mutableCopy];
    [request setValue:@"com.vine.iphone/1.0.7 (unknown, iPhone OS 5.1.1, iPhone, Scale/2.000000)" forHTTPHeaderField:@"User-Agent"];
    
    AFHTTPRequestOperation* operation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    return operation;
}


@end
