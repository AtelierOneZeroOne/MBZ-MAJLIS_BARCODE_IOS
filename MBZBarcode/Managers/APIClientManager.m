//
//  BOWAPIClientManager.m
//  BOW
//
//  Created by A101 on 7/16/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "APIClientManager.h"

//vendor
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

//Resouces
#import "MBZConstants.h"

//Categories
#import "NSObject+Cast.h"
#import "NSString+Additions.h"
#import "NSError+Localization.h"
#import "UIViewController+Additions.h"
#import "UIAlertController+Convenience.h"
#import "UIViewController+Additions.h"
#import "UIColor+More.h"

typedef void (^AFRequestOperationSuccesBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^AFRequestOperationFailureBlock)(NSURLSessionDataTask *task, NSError *error);

static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";
static NSString * const BOWParameterDateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@interface APIClientManager ()

@property (strong, nonatomic) UIAlertController *sessionExpiredAlertController;
@property (readonly, strong, nonatomic) NSString    *apiKey;
@property (strong, nonatomic) UIView      *floatingWarning;

@end

@implementation APIClientManager

+ (APIClientManager *)sharedManager {
	static APIClientManager * _instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:MBZ_API_BASE_URL]];
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	});
	return _instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		self.responseSerializer = [JSONResponseSerializerWithData serializer];
		self.requestSerializer = [AFHTTPRequestSerializer serializer];
	}
	return self;
}

#pragma mark - Private Methods

- (AFRequestOperationSuccesBlock)successCallback:(APIClientManagerSuccessBlock)success {
	return ^(NSURLSessionDataTask *task, id responseObject) {
		SPLOG_INFO(@"Success Response: %@ %@", task.currentRequest.URL.absoluteString, responseObject);
		if (success) {
			success(responseObject);
		}
	};
}

- (AFRequestOperationFailureBlock)failureCallback:(APIClientManagerFailureBlock)failure {
	return ^(NSURLSessionDataTask *task, NSError *error) {
		SPLOG_INFO(@"Request Error: %@ %@", task.originalRequest.URL.absoluteString, error.description);
		
		NSString *errorMessage = nil;
		if (error.userInfo[JSONResponseSerializerWithDataKey][@"message"]) {
			errorMessage = error.userInfo[JSONResponseSerializerWithDataKey][@"message"];
		} else if (error.localizedCodeDescription) {
			errorMessage = error.localizedCodeDescription;
		} else {
			errorMessage = @"Something went wrong. Please try again later.";
		}
		
		NSString *errorCode = [error.userInfo[JSONResponseSerializerWithDataKey][@"code"] safeStringValue];
		if ([errorCode isEqualToString:@"401"]) {
			if (!self.sessionExpiredAlertController) {
                
                [UIAlertController showAlertInViewController:[UIViewController topViewController]
                                                   withTitle:@"Session Expired"
                                                     message:@"Your session has expired. Please log in again."
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil
                                                    tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                        self.sessionExpiredAlertController = nil;
                                                    }];
			}
			if (failure) failure(nil);
		} else {
			NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
			userInfo[NSLocalizedDescriptionKey] = errorMessage;
			NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            
            
            if ([errorMessage isEqualToString:@"No internet connection."]) {
                
                
                self.floatingWarning = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                64,
                                                                                [UIViewController topViewController].view.bounds.size.width,
                                                                                30)];
                self.floatingWarning.backgroundColor    = [UIColor clearColor];
                self.floatingWarning.alpha              = 1.0f;
                
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIViewController topViewController].view.bounds.size.width, 30)];
                label.text = errorMessage;
                label.font = FONT_UI_Text_Light(FONT_SIZE_XTRA2_SMALL);
                label.backgroundColor = [UIColor colorWithHex:THEME_COLOR_GRAY];
                label.textColor = [UIColor whiteColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                [self.floatingWarning addSubview:label];
                
                
                [[UIViewController topViewController].view addSubview:self.floatingWarning];
                
                // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
                [UIView animateWithDuration:0.5 delay:5.0 options:0 animations:^{
                    // Animate the alpha value of your imageView from 1.0 to 0.0 here
                    self.floatingWarning.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
                    [self.floatingWarning removeFromSuperview];
                }];
                
            }
            
			if (failure) failure(newError);
		}
	};
}

#pragma mark - POST Method

- (void)logInWithEmail:(NSString *)email
			  password:(NSString *)password
			   success:(APIClientManagerSuccessBlock)success
			   failure:(APIClientManagerFailureBlock)failure {
    
    NSString *endpoint                  = [NSString stringWithFormat:MBZ_API_SCANNING_ZONES];
    NSString *url                       = [NSString stringWithFormat:@"%@%@",MBZ_API_BASE_URL,endpoint];
	NSMutableDictionary *parameters     = [[NSMutableDictionary alloc] initWithCapacity:2];
	parameters[@"username"]             = [email trim];
	parameters[@"password"]             = password;
	
	[self POST:url
	parameters:parameters
	  progress:nil
	   success:[self successCallback:success]
	   failure:[self failureCallback:failure]];
}

#pragma mark - GET Method

- (void)getZone:(APIClientManagerSuccessBlock)success
        failure:(APIClientManagerFailureBlock)failure
{
    
    NSString *endpoint                  = [NSString stringWithFormat:MBZ_API_SCANNING_ZONES];
    NSString *url                       = [NSString stringWithFormat:@"%@%@",MBZ_API_BASE_URL,endpoint];
    
    [self GET:url parameters:nil
     progress:nil
      success:[self successCallback:success]
      failure:[self failureCallback:failure]];
}

#pragma mark - Others

- (void)cancelAllOperations {
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask *dataTask in dataTasks) {
            [dataTask cancel];
        }
        for (NSURLSessionDataTask *uploadTask in uploadTasks) {
            [uploadTask cancel];
        }
        for (NSURLSessionDataTask *downloadTask in downloadTasks) {
            [downloadTask cancel];
        }
    }];
}
@end

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
						   data:(NSData *)data
						  error:(NSError *__autoreleasing *)error
{
	// Source: http://blog.gregfiumara.com/archives/239
	id JSONObject = [super responseObjectForResponse:response data:data error:error];
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
		if (data != nil) {
			NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
			if (responseData) {
				userInfo[JSONResponseSerializerWithDataKey] = responseData;
			}
		}
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
	return (JSONObject);
}

@end
