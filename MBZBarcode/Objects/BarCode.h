//
//  BarCode.h
//  MBZBarcode
//
//  Created by Michael Ugale on 3/5/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarCode : NSObject

@property (strong, nonatomic) NSString *scannedBarcode;
 @property (strong, nonatomic) NSString *selectedKeyZone;
 @property (strong, nonatomic) NSString *selectedAction;

@end
