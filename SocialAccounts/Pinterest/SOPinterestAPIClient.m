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

#import "SOPinterestAPIClient.h"

#import "AFJSONRequestOperation.h"

static NSString * const kAFPinterestAPIBaseURLString = @"http://pinterest.com/";

@implementation SOPinterestAPIClient

+ (SOPinterestAPIClient *)sharedClient {
    static SOPinterestAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SOPinterestAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFPinterestAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self setDefaultHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml"];
    
    return self;
}

- (void)getPath:(NSString *)path
      sessionId:(NSString *)sessionId
      csrfToken:(NSString *)csrfToken
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    NSMutableURLRequest* urlRequest = [request mutableCopy];

    NSHTTPCookie *sessionCookie = [NSHTTPCookie cookieWithProperties:@{
                                                    NSHTTPCookieDomain: @".pinterest.com",
                                                      NSHTTPCookiePath: @"",
                                                      NSHTTPCookieName: @"_pinterest_sess",
                                                     NSHTTPCookieValue: sessionId}];
    
    NSHTTPCookie *csrfTokenCookie = [NSHTTPCookie cookieWithProperties:@{
                                           NSHTTPCookieDomain: @".pinterest.com",
                                             NSHTTPCookiePath: @"",
                                             NSHTTPCookieName: @"csrftoken",
                                            NSHTTPCookieValue: csrfToken}];
    NSArray* cookies = [NSArray arrayWithObjects: sessionCookie, csrfTokenCookie, nil];
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [urlRequest setAllHTTPHeaderFields:headers];
     
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
      sessionId:(NSString *)sessionId
      csrfToken:(NSString *)csrfToken
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    NSMutableURLRequest* urlRequest = [request mutableCopy];
    
    NSHTTPCookie *sessionCookie = [NSHTTPCookie cookieWithProperties:@{
                                                  NSHTTPCookieDomain: @".pinterest.com",
                                                    NSHTTPCookiePath: @"",
                                                    NSHTTPCookieName: @"_pinterest_sess",
                                                   NSHTTPCookieValue: sessionId}];
    
    NSHTTPCookie *csrfTokenCookie = [NSHTTPCookie cookieWithProperties:@{
                                                    NSHTTPCookieDomain: @".pinterest.com",
                                                      NSHTTPCookiePath: @"",
                                                      NSHTTPCookieName: @"csrftoken",
                                                     NSHTTPCookieValue: csrfToken}];
    NSArray* cookies = [NSArray arrayWithObjects: sessionCookie, csrfTokenCookie, nil];
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [urlRequest setAllHTTPHeaderFields:headers];
    
    [urlRequest setValue:csrfToken forHTTPHeaderField:@"X-CSRFToken"];
    [urlRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSMutableURLRequest* request = [urlRequest mutableCopy];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:20.0) Gecko/20100101 Firefox/20.0" forHTTPHeaderField:@"User-Agent"];
    
    AFHTTPRequestOperation* operation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    return operation;
}

@end
