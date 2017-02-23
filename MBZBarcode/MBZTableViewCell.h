//
//  MBZTableViewCell.h
//  MBZ
//
//  Created by Michael Ugale on 1/29/17.
//  Copyright © 2017 Michael Ugale. All rights reserved.
//

#import <UIKit/UIKit.h>

//Resources
#import "MBZConstants.h"

//Utilities
#import "MBZCache.h"

//Categories
#import "UIColor+More.h"

@interface MBZTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;
+ (instancetype)dequeueForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueForTableViewWithID:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellID:(NSString*)cellID;

+ (CGFloat)cellHeight;
+ (CGFloat)estimatedCellHeight;

- (UIColor *)selectedBackgroundViewColor;

@end
