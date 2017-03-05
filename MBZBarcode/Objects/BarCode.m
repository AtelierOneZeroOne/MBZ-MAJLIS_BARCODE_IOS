//
//  BarCode.m
//  MBZBarcode
//
//  Created by Michael Ugale on 3/5/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import "BarCode.h"

@implementation BarCode

#pragma mark - Encoder

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_scannedBarcode                   forKey:@"scannedBarcode"];
    [coder encodeObject:_selectedKeyZone                     forKey:@"selectedKeyZone"];
    [coder encodeObject:_selectedAction                     forKey:@"selectedAction"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _scannedBarcode               = [coder decodeObjectForKey:@"scannedBarcode"];
        _selectedKeyZone                 = [coder decodeObjectForKey:@"selectedKeyZone"];
        _selectedAction                 = [coder decodeObjectForKey:@"selectedAction"];
    }
    return self;
}


@end
