//
//  WineCartList.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/18/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <Realm/Realm.h>
#import "WineRealm.h"

//RLM_ARRAY_TYPE(WineRealm)
@interface WineCartList : RLMObject


@property RLMArray<WineRealm> *wineCartList;

@end
