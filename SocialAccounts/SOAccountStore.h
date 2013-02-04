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

#import <Foundation/Foundation.h>
#import "SOAccountType.h"
#import "SOAccount.h"

typedef void(^SOAccountStoreSaveCompletionHandler)(BOOL success, NSError *error);

@interface SOAccountStore : NSObject

@property (readonly, strong) NSArray* accountTypes;

// An array of all the accounts in an account database
@property (readonly, weak, nonatomic) NSArray *accounts;

// Returns the account matching the given account identifier
- (SOAccount *)accountWithIdentifier:(NSString *)identifier;

// Returns the account type object matching the account type identifier. See
// SOAccountType.h for well known account type identifiers
- (SOAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier;

// Saves the account to the account database. If the account is unauthenticated and the associated account
// type supports authentication, the system will attempt to authenticate with the credentials provided.
// Assuming a successful authentication, the account will be saved to the account store. The completion handler
// for this method is called on an arbitrary queue.
- (void)saveAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler;

// Removes the account from the account database
- (void)removeAccount:(SOAccount *)account withCompletionHandler:(SOAccountStoreSaveCompletionHandler)completionHandler;


// Clears the account database, including any saved accounts
- (void)clearStore;

@end
