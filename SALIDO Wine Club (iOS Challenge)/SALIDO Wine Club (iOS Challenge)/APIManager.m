//
//  APIManager.m
//  SALIDO Wine Club (iOS Challenge)
//
//  Created by Elmer Astudillo on 5/9/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

#import "APIManager.h"

static NSString *const kWineListPath = @"http://services.wine.com/api/beta2/service.svc/JSON/catalog?apikey=701a29d866da6b9cf2d0163625707fbf";


@implementation APIManager


// Method which returns JSON Data in Model format
- (NSURLSessionDataTask *)getWinesWithRequestModel:(WineListRequestModel *)requestModel
                                              success:(void (^)(WineListResponseModel *responseModel))success
                                              failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSMutableDictionary *parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    return [self GET:kWineListPath parameters:parametersWithKey progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *error;
        WineListResponseModel *list = [MTLJSONAdapter modelOfClass:WineListResponseModel.class
                                                   fromJSONDictionary:responseDictionary error:&error];
        //NSLog(@"%@", list);
        
        success(list);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
                 
        
    
}


@end
