//
//  BOWAPIClientManager.h
//  BOW
//
//  Created by A101 on 7/16/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <CoreLocation/CLLocation.h>

typedef void(^APIClientManagerSuccessBlock)(NSDictionary *responseObject);
typedef void(^APIClientManagerFailureBlock)(NSError *error);

@interface APIClientManager : AFHTTPSessionManager

+ (APIClientManager *)sharedManager;

#pragma mark - POST Method

- (void)sendScanned:(NSString *)value
               zone:(NSString *)zone
             action:(NSString *)action
                key:(NSString *)key
            success:(APIClientManagerSuccessBlock)success
            failure:(APIClientManagerFailureBlock)failure;

#pragma mark - GET Method

- (void)getZone:(APIClientManagerSuccessBlock)success
        failure:(APIClientManagerFailureBlock)failure;

- (void)cancelAllOperations;

@end

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
