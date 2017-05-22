//
//  WineListRequestModel.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WineListRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic,copy) NSString *filter;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSNumber *size;



@end
