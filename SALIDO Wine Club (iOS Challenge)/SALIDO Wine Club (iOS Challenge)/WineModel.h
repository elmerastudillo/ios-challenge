//
//  WineModel.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WineModel : MTLModel <MTLJSONSerializing>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray *Labels;
@property (nonatomic,copy) NSString *wineDescription;
//@property (nonatomic,copy) NSString *image;

@end
