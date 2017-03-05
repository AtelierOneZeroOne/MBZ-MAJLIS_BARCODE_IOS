//
//  MBZCache.h
//  MBZBarcode
//
//  Created by Michael Ugale on 2/23/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const ZONE_LIST;
FOUNDATION_EXPORT NSString *const SCANNED_LIST;
FOUNDATION_EXPORT NSString *const TOTAL_SCANNED;

@interface MBZCache : NSObject

+ (instancetype)shared;

- (id)getCachedObjectForKey:(NSString *)key;
- (void)setCachedObject:(id)object forKey:(NSString *)key;
- (void)removeCachedObjectWithKey:(NSString *)key;
- (void)clearAllCache;

@end
