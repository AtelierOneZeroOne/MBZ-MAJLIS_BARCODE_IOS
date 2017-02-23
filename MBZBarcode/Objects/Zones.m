//
//  Zones.m
//  MBZBarcode
//
//  Created by Michael Ugale on 2/23/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "Zones.h"

@implementation Zones

#pragma mark - Encoder

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_key                   forKey:@"key"];
    [coder encodeObject:_value                     forKey:@"value"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _key               = [coder decodeObjectForKey:@"key"];
        _value                 = [coder decodeObjectForKey:@"value"];
    }
    return self;
}

@end
