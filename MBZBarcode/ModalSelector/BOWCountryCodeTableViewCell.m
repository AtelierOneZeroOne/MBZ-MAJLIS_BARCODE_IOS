//
//  BOWCountryCodeTableViewCell.m
//  BOW
//
//  Created by Michael Ugale on 1/26/17.
//  Copyright © 2017 A101. All rights reserved.
//

#import "BOWCountryCodeTableViewCell.h"

@implementation BOWCountryCodeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.cellText setTextAlignment:NSTextAlignmentCenter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
