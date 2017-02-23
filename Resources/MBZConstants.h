//
//  MBZConstants.h
//  MBZ
//
//  Created by Michael Ugale on 1/29/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#ifndef MBZConstants_h
#define MBZConstants_h

//******************************
// App Logs
//******************************
#define ENABLE_LOGS

#ifdef ENABLE_LOGS
#define LOG_LEVEL 3
#else
#define LOG_LEVEL 0
#endif

#if (LOG_LEVEL >= 1)
#define SPLOG_ERROR(format, ...)    NSLog(@"%s:%d\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif
#if (LOG_LEVEL >= 2)
#define SPLOG_INFO(format, ...)     NSLog(@"%s:%d\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif
#if (LOG_LEVEL >= 3)
#define SPLOG_DEBUG(format, ...)    NSLog(@"%s:%d\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

//******************************
// App Version
//******************************

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// iOS Version macro
#define IS_IOS7_OR_LATTER               (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8_OR_NEWER                (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)

//******************************
// iPhone Screen Size
//******************************

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//******************************
// Client's API Endpoints
//******************************

#if DEBUG
#define MBZ_API_BASE_URL                @"http://ec2-35-157-109-61.eu-central-1.compute.amazonaws.com"
#else
#define MBZ_API_BASE_URL                @"https://registration.mbzfuturegen.com"
#endif

#define MBZ_GOOGLE_MAPS_CONTENT_URL     @"?f=d&daddr=%@&sll=%f,%f&sspn=0.2,0.1&nav=1&x-source=SourceApp&x-success=sourceapp://?resume=true"
#define MBZ_GOOGLE_MAPS                 @"comgooglemaps-x-callback://%@"
#define MBZ_GOOGLE_MAPS_URL             @"http://maps.google.com/maps?%@"
#define MBZ_GOOGLE_MAPS_ANNOTATION      @"Abu+Dhabi+National+Exhibition+Centre"

#define MBZ_API_SOCIAL_FEED             @"/social-feed?lang=%@"
#define MBZ_API_LIVE_POLLS              @"/livepoll?lang=%@"
#define MBZ_API_RESET_PASSWORD          @"/%@/resetting/request"

#define MBZ_API_LOGIN                   @"/api/login"
#define MBZ_API_WORKSHOPS               @"/api/workshops?lang=%@&user_token=%@"
#define MBZ_API_UPDATE_WORKSHOPS        @"/api/user-profile/%@/update-workshops"
#define MBZ_API_PARTNERS                @"/api/partners?lang=%@&user_token=%@"
#define MBZ_API_ABOUT                   @"/api/about?lang=%@"
#define MBZ_API_SPEAKERS                @"/api/speakers?lang=%@"
#define MBZ_API_SAVE_DEVICE_TOKEN     	@"/api/user-profile/%@/devicetoken"
#define MBZ_API_UPLOAD_PROFILE          @"/api/user-profile/%@/update-user"
#define MBZ_API_USER_PROFILE            @"/api/user-profile/%@?lang=%@"
#define MBZ_API_FEEDBACK                @"/api/feedback?user_token=%@"
#define MBZ_API_FEEDBACK_QUESTIONS      @"/api/feedback?lang=%@"
#define MBZ_API_QUESTION_ANSWER         @"/api/submit-qa?user_token=%@"

//******************************
// App Font List
//******************************
#define FONT_SIZE_TEXTFIELD             20
#define FONT_SIZE_BUTTON_SUBMIT         24
#define FONT_SIZE_SMALL                 16
#define FONT_SIZE_XTRA_SMALL            14
#define FONT_SIZE_XTRA2_SMALL           12
#define FONT_SIZE_XTRA3_SMALL           10
#define FONT_SIZE_MENU                  16

#define FONT_UI_Text_Regular(s)          [UIFont fontWithName:@"Seravek-Medium" size:s]
#define FONT_UI_Text_Bold(s)             [UIFont fontWithName:@"Seravek-Bold" size:s]
#define FONT_UI_Text_Light(s)            [UIFont fontWithName:@"Seravek-Light" size:s]

#define FONT_UI_Text_Regular_ARB(s)      [UIFont fontWithName:@"GE_Dinar_Two_Medium" size:s]
#define FONT_UI_Text_Light_ARB(s)        [UIFont fontWithName:@"GE_Dinar_Two_Light" size:s]


//******************************
// App Values
//******************************

#define LANGUAGE_ARABIC                 @"Arabic"
#define LANGUAGE_ENGLISH                @"English"

//******************************
// App Theme Colors
//******************************

#define THEME_COLOR_ORANGE                  @"#ff6600"
#define THEME_COLOR_BLACK                   @"#333333"
#define THEME_COLOR_GRAY                    @"#58575c"
#define THEME_COLOR_LIGHT_GRAY              @"#999999"


//******************************
// Google Maps Credentials
//******************************

#define GOOGLE_MAP_API_KEY @"AIzaSyDrK1elyrDupxk_pvZvSMgi6SKKokrDWKQ"

#endif /* MBZConstants_h */
