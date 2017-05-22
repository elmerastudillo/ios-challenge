//
//  WineListResponseModel.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "WineListResponseModel.h"

@class WineModel;

@implementation WineListResponseModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"wines" : @"Products.List",
             @"status" : @"Status.ReturnCode"
             };
}

+ (NSValueTransformer *)winesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:WineModel.class];
}

@end
