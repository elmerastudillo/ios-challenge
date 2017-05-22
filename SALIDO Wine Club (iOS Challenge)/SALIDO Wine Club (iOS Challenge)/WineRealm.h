//
//  WineRealm.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/10/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <Realm/Realm.h>
#import "WineModel.h"

@interface WineRealm : RLMObject

@property NSString *wineID;
@property NSString *name;
@property NSString *imageURL;
@property NSString *wineDescription;
@property NSNumber<RLMInt> *quantity;

- (id)initWithMantleModel:(WineModel *)wineModel;

@end

RLM_ARRAY_TYPE(WineRealm) // define RLMArray<WineRealm>


