//
//  WineModel.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "WineModel.h"

@implementation WineModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"Name",
             @"wineDescription" : @"Description",
             @"Labels" : @"Labels"
             
            };
}

@end
