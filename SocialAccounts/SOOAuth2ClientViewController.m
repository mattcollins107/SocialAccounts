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

#import "SOOAuth2ClientViewController.h"

@implementation SOOAuth2ClientViewController


/*
 GET /dialog/oauth?type=user_agent&display=touch&redirect_uri=fb438956542806900%3A%2F%2Fauthorize&sdk=ios&scope=user_birthday%2Cemail%2Cuser_location&client_id=438956542806900 HTTP/1.1
 Host: m.facebook.com
 Accept-Language: en-us
 Accept-Encoding: gzip, deflate
 Cookie: c_user=100000726012878; csm=2; fr=0nI3p1NxVdT4A2zl6.AWVZ3g4ySvwriT8TAOLPxKF8ixU.BReKdV.2n.AWVcPxUI; s=Aa41SQq3VthOzxtN.BReKdV; xs=125%3Aa7T30yszpBrAYg%3A2%3A1366861653; datr=O6d4UW6K9kdWA7a38bgtbOnR; lu=RgKwtzpcgd9cNk09xq8Li1bg; m_user=0%3A0%3A0%3A0%3Av_1%2Cajax_1%2Cwidth_320%2Cpxr_2%2Cgps_1%3A1366861653%3A2
 Connection: keep-alive
 Proxy-Connection: keep-alive
 
 POST /api/oauth/authorize HTTP/1.1
 Host: votoapp.com
 User-Agent: Voto/75 CFNetwork/548.1.4 Darwin/11.0.0
 Content-Length: 412
 Accept-Language: en-us
 Accept-Encoding: gzip, deflate
 Content-Type: application/x-www-form-urlencoded
 Connection: keep-alive
 Proxy-Connection: keep-alive
 
 client_id=qfbpd3rk1cffw626k6nwgxxg6yx8b7q&client_secret=48bx4xu8jtxd70asvs1181113xjmsy2&assertion_type=https://graph.facebook.com/me&assertion=BAAGPOojOS3QBAHPwvOFjG9mC11TVtBOKGooe5uYWgRbwoCV84aZCsG4ICrPdAWySIOEQkgsEjrmp9VH1S4vpdynKE6Yu0VI7tnvb0IEBPg6CX8KN83PA26ces7cCKGZC0nEWWs8d0WB7IKaug4A1V1PGOF2L3PDTPuKCdZByQDasUOoQ0lyDM7lZCFYtSkvUWIEbbYN3sEEqOZAnu7XcVypX07r8FNxbZBrJfA0OvkHfZAIjtQBc2VM&grant_type=assertion
 
 */

+ (id)controllerWithAuthUri:(NSString*)authUri redirectURI:(NSString*)uri completionHandler:(void (^)(NSDictionary* info, NSError *error))handler {
    return [[self alloc] initWithAuthUri:(NSString*)authUri redirectURI:uri completionHandler:handler];
}

- (id)initWithAuthUri:(NSString*)authUri redirectURI:(NSString*)uri completionHandler:(void (^)(NSDictionary* info, NSError *error))handler {
    
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.authUri = authUri;
        self.redirectURI = [NSURL URLWithString:uri];
        completionBlock_ = [handler copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:self.authUri, self.redirectURI ]]];
    [self.webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (request.URL!=nil) {

        NSUInteger length = [self.redirectURI.absoluteString length];
        
        NSString* url = nil;
        if ([request.URL.absoluteString length]>length) {
            url = [request.URL.absoluteString substringToIndex:length];
        }
        
        NSLog(@"%@ - %@", url, self.redirectURI.absoluteString);

        
        
        if ([url isEqualToString:self.redirectURI.absoluteString]) {
            
            
            NSMutableDictionary* result = [NSMutableDictionary dictionary];
            
            //NSArray *components = [request.URL.fragment componentsSeparatedByString:@"="];
//            [result setObject:[components objectAtIndex:1] forKey:@"access_token"];
  
            result = [self URLQueryParametersWithURL:request.URL];
            
            completionBlock_(result, nil);
            
            [self dismissModalViewControllerAnimated:YES];
            
            return NO;
        }
    }
    return YES;
}


- (NSDictionary *)URLQueryParametersWithURL:(NSURL*)url
{
    NSString *queryString = @"";
    
    NSRange fragmentStart = [url.absoluteString rangeOfString:@"#"];
    if (fragmentStart.location != NSNotFound)
    {
        queryString = [url.absoluteString substringFromIndex:fragmentStart.location + 1];
    }
    
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters)
    {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [parts objectAtIndex:0];
        if ([parts count] > 1)
        {
            id value = [parts objectAtIndex:1];
            BOOL arrayValue = [key hasSuffix:@"[]"];
            if (arrayValue)
            {
                key = [key substringToIndex:[key length] - 2];
            }
            id existingValue = [result objectForKey:key];
            if ([existingValue isKindOfClass:[NSArray class]])
            {
                value = [existingValue arrayByAddingObject:value];
            }
            else if (existingValue)
            {
                value = existingValue;
            }
            
            [result setObject:value forKey:key];
        }
    }
    return result;
}

@end

