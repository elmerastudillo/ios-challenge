//
//  APIManager.h
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "SessionManager.h"
#import "WineListRequestModel.h"
#import "WineListResponseModel.h"
#import "WineModel.h"

@interface APIManager : SessionManager

- (NSURLSessionDataTask *)getWinesWithRequestModel:(WineListRequestModel *)requestModel success:(void (^)(WineListResponseModel *responseModel))success failure:(void (^)(NSError *error))failure;

@end
