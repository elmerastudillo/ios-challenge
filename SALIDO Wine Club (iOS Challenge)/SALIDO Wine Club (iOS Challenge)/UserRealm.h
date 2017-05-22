//
//  UserRealm.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/14/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserRealm : RLMObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *email;
@property NSNumber<RLMInt> *pinNumber;
@property NSNumber<RLMInt> *amountOfItemsInCart;
@property NSString *registrationDate;

@end
