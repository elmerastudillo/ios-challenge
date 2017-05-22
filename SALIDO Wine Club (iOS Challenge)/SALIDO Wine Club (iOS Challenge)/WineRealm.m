//
//  WineRealm.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/10/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "WineRealm.h"

@implementation WineRealm

- (id)initWithMantleModel:(WineModel *)wineModel
{
    self = [super init];
    if (!self) return nil;
    
    NSDictionary *wineLabels = wineModel.Labels[0];
    NSString *imageURL = [wineLabels objectForKey:@"Url"];
    
    self.name = wineModel.name;
    self.wineDescription = wineModel.wineDescription;
    self.imageURL = imageURL;
    self.quantity = 0;
    
    return self;
}

+ (NSString *)primaryKey
{
    return @"wineID";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"wineID": [[NSUUID UUID] UUIDString]};
}





@end
