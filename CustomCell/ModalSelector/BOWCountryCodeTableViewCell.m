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
    
    if ([[[MBZCache shared] getCachedObjectForKey:USER_SETTING_LANGUAGE] isEqualToString:LANGUAGE_ARABIC]) {
        [self.cellText setFont:FONT_UI_Text_Regular_ARB(FONT_SIZE_XTRA_SMALL)];
    } else {
        [self.cellText setFont:FONT_UI_Text_Regular(FONT_SIZE_XTRA_SMALL)];
    }
    [self.cellText setTextAlignment:NSTextAlignmentCenter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
