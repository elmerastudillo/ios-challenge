//
//  WineListRequestModel.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "WineListRequestModel.h"

@implementation WineListRequestModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"filter": @"filter",
             @"size": @"size",
             @"sort": @"sort"
             };
}


@end
