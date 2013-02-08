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

#import "SOTumblrBlog.h"

@implementation SOTumblrBlog

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        _blogId = [[[dictionary objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        _name = [dictionary objectForKey:@"name"];
        _title = [dictionary objectForKey:@"title"];
        _url = [dictionary objectForKey:@"url"];
        _followers = [dictionary objectForKey:@"followers"];
        _primary = [[dictionary objectForKey:@"primary"] boolValue];
    }
    
    return self;
}

@end
