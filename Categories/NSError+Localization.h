//
//  NSError+Localization.h
//  BOW
//
//  Created by A101 on 7/21/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Localization)

/**
 *  Returns the localized description of the error based on code.
 */
@property (readonly, strong, nonatomic) NSString *localizedCodeDescription;

@end
