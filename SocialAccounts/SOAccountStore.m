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

#import "SOAccountStore.h"
#import <Security/Security.h>

@interface SOAccountStore ()

@property(nonatomic, copy) SOAccountStoreSaveCompletionHandler saveAccountHandler;

@end

@implementation SOAccountStore

- (SOAccount *)accountWithIdentifier:(NSString *)identifier {
    NSDictionary* info = [self getDictionaryForKey:identifier];
    
    SOAccountType* type = [self accountTypeWithAccountTypeIdentifier:[info objectForKey:@"type"]];
    SOAccount* account = [[SOAccount alloc] initWithAccountType:type];
    account.username = [info objectForKey:@"username"];
    
    SOAccountCredential* credential;
    
    SOAccountCredentialType credentialType = [[info objectForKey:@"credential.type"] integerValue];
    
    if (credentialType==SOAccountCredentialTypeOAuth2) {
        credential = [[SOAccountCredential alloc] initWithOAuth2Token:[info objectForKey:@"credential.oauthToken"] refreshToken:nil expiryDate:nil];
        credential.scope = [info objectForKey:@"credential.scope"];
    } else if (credentialType==SOAccountCredentialTypeOAuth1) {
        credential = [[SOAccountCredential alloc] initWithOAuthToken:[info objectForKey:@"credential.oauthToken"] tokenSecret:[info objectForKey:@"credential.oauthTokenSecret"]];
    }
    
    account.credential = credential;
    
    return account;
}

- (void)saveAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler {
    self.saveAccountHandler = completionHandler;
    
    NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
    [info setObject:account.accountType.identifier forKey:@"type"];
    [info setObject:account.username forKey:@"username"];
    
    if (account.credential.credentialType==SOAccountCredentialTypeOAuth2) {
        [info setObject:[NSNumber numberWithInteger:SOAccountCredentialTypeOAuth2] forKey:@"credential.type"];
        [info setObject:account.credential.oauthToken forKey:@"credential.oauthToken"];
        [info setObject:account.credential.scope forKey:@"credential.scope"];
    } else if (account.credential.credentialType==SOAccountCredentialTypeOAuth1) {
        [info setObject:[NSNumber numberWithInteger:SOAccountCredentialTypeOAuth1] forKey:@"credential.type"];
        [info setObject:account.credential.oauth1Token forKey:@"credential.oauthToken"];
        [info setObject:account.credential.oauth1Secret forKey:@"credential.oauthTokenSecret"];
    } else if (account.credential.credentialType==SOAccountCredentialTypeSession) {
        [info setObject:[NSNumber numberWithInteger:SOAccountCredentialTypeSession] forKey:@"credential.type"];
        [info setObject:account.credential.sessionKey forKey:@"credential.sessionKey"];
        [info setObject:account.credential.csrfToken forKey:@"credential.csrfToken"];
    }
    
    [self setDictionary:info forKey:account.identifier];
    
    
    NSMutableArray* accounts = [[self getArrayForKey:@"Accounts"] mutableCopy];
    if (accounts==nil) {
        accounts = [[NSMutableArray alloc] init];
    }
    
    // find if the account already in the database. if so, we'll remove the old copy
    for (SOAccount* localAccount in self.accounts) {
        if ([localAccount.identifier isEqualToString:account.identifier]) {
            [accounts removeObject:localAccount];
        }
    }
    
    [accounts addObject:account.identifier];
    
    [self setArray:accounts forKey:@"Accounts"];
    
    if (self.saveAccountHandler) {
        self.saveAccountHandler(YES, nil);
        self.saveAccountHandler = nil;
    }
}

- (void)removeAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler {
    self.saveAccountHandler = completionHandler;

    NSMutableArray* accounts = [[self getArrayForKey:@"Accounts"] mutableCopy];
    if (accounts==nil) {
        accounts = [[NSMutableArray alloc] init];
    }
    
    [accounts removeObject:account];
    [self setArray:accounts forKey:@"Accounts"];

    if (self.saveAccountHandler) {
        self.saveAccountHandler(YES, nil);
        self.saveAccountHandler = nil;
    }
}

- (NSArray*)accounts {
    
    NSArray* accountsKeys = [self getArrayForKey:@"Accounts"];
    
    NSMutableArray* accounts = [[NSMutableArray alloc] init];
    for (NSString* identifier in accountsKeys) {
        [accounts addObject:[self accountWithIdentifier:identifier]];
    }
    
    return accounts;
}


- (NSArray*)accountTypes {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    SOAccountType* accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierInstagram;
    accountType.accountTypeDescription = @"Instagram";
    [array addObject:accountType];
    
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierFacebook;
    accountType.accountTypeDescription = @"Facebook";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierTwitter;
    accountType.accountTypeDescription = @"Twitter";
    [array addObject:accountType];
    
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierTumblr;
    accountType.accountTypeDescription = @"Tumblr";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierFoursquare;
    accountType.accountTypeDescription = @"Foursquare";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifier500px;
    accountType.accountTypeDescription = @"500px";
    [array addObject:accountType];
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierDribbble;
    accountType.accountTypeDescription = @"Dribbble";
    [array addObject:accountType];
    
    
    accountType = [[SOAccountType alloc] init];
    accountType.identifier = SOAccountTypeIdentifierPinterest;
    accountType.accountTypeDescription = @"Pinterest";
    [array addObject:accountType];
    
    return array;
}

- (SOAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier {
    NSArray* types = [self accountTypes];
    for (SOAccountType* service in types) {
        if ([typeIdentifier isEqualToString:service.identifier]) {
            return service;
        }
    }
    
    return nil;
}

- (void)clearStore {
    [self setArray:[NSArray array] forKey:@"Accounts"];
}

- (BOOL)setDictionary:(NSDictionary*)dictionary forKey:(NSString*)key
{
	if (dictionary == nil || key == nil) {
		return NO;
	}
	
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	// First check if it already exists, by creating a search dictionary and requesting that
	// nothing be returned, and performing the search anyway.
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	
    NSString* error = nil;
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	[existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	
	// Add the keys to the search dict
	[existsQueryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
	[existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];
    
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef) existsQueryDictionary, NULL);
    
	if (res == errSecItemNotFound) {
		if (dictionary != nil) {
			NSMutableDictionary *addDict = existsQueryDictionary;
			[addDict setObject:data forKey:(__bridge id)kSecValueData];
            
			res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
			NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", res);
		}
	} else if (res == errSecSuccess) {
		// Modify an existing one
		// Actually pull it now of the keychain at this point.
		NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData];
		res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
		NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", res);
	} else {
		NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", res);
	}
	return YES;
}

- (NSDictionary*)getDictionaryForKey:(NSString*)key
{
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];

	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	[existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	
	// Add the keys to the search dict
	[existsQueryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
	[existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];
	
	// We want the data back!
	CFTypeRef data = nil;
	
	[existsQueryDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
	OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &data);
    
	if (res == errSecSuccess) {
        NSString* error = nil;

        NSDictionary *dictionary = [NSPropertyListSerialization propertyListFromData:(__bridge NSData*)data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error];

		return dictionary;
	} else {
		NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", res);
	}
	
	return nil;
}


- (BOOL)setArray:(NSArray*)array forKey:(NSString*)key
{
	if (array == nil || key == nil) {
		return NO;
	}
	
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	// First check if it already exists, by creating a search dictionary and requesting that
	// nothing be returned, and performing the search anyway.
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	
    NSString* error = nil;
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:array format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	[existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	
	// Add the keys to the search dict
	[existsQueryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
	[existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];
    
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef) existsQueryDictionary, NULL);
    
	if (res == errSecItemNotFound) {
		if (array != nil) {
			NSMutableDictionary *addDict = existsQueryDictionary;
			[addDict setObject:data forKey:(__bridge id)kSecValueData];
            
			res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
			NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", res);
		}
	} else if (res == errSecSuccess) {
		// Modify an existing one
		// Actually pull it now of the keychain at this point.
		NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData];
		res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
		NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", res);
	} else {
		NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", res);
	}
	return YES;
}

- (NSArray*)getArrayForKey:(NSString*)key
{
	key = [NSString stringWithFormat:@"%@ - %@", @"SocialAccounts", key];
    
	NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
	[existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	
	// Add the keys to the search dict
	[existsQueryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
	[existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];
	
	// We want the data back!
	CFTypeRef data = nil;
	
	[existsQueryDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
	OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &data);
    
	if (res == errSecSuccess) {
        NSString* error = nil;
        
        NSArray *array = [NSPropertyListSerialization propertyListFromData:(__bridge NSData*)data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:&error];
        
		return array;
	} else {
		NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", res);
	}
	
	return nil;
}



@end
