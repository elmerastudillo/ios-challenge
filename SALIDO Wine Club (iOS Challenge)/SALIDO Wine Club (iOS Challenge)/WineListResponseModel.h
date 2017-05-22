//
//  WineListResponseModel.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import "WineModel.h"

@interface WineListResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *wines;
//@property (nonatomic, copy) NSArray *wines;
@property NSNumber *status;

@end
