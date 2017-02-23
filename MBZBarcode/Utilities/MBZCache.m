//
//  MBZCache.m
//  MBZBarcode
//
//  Created by Michael Ugale on 2/23/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "MBZCache.h"

@implementation MBZCache


NSString *const ZONE_LIST                                    = @"com.mbz.zone.list.www";

static MBZCache *shared = nil;

+ (instancetype)shared
{
    @synchronized(self) {
        if (!shared) {
            shared = (MBZCache *)[[self alloc] init];
        }
    }
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setCachedObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSData *data                = [NSKeyedArchiver archivedDataWithRootObject:object];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

- (id)getCachedObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSData *data                = [defaults objectForKey:key];
    
    if (data == nil) {
        return nil;
    }
    
    @try {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return obj;
    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:@"NSInvalidUnarchiveOperationException"] ||
            [exception.name isEqualToString:@"NSInvalidArchiveOperationException"]) {
            [self removeCachedObjectWithKey:key];
        }
        return nil;
    }
    @finally {
        
    }
}

- (void)removeCachedObjectWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

- (void)clearAllCache
{
    [[MBZCache shared] removeCachedObjectWithKey:ZONE_LIST];
    
}

@end
