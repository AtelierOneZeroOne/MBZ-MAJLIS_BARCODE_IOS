//
//  UIFont+EcamFont.m
//  BOW
//
//  Created by A101 on 7/17/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "UIFont+EcamFont.h"

@implementation UIFont (EcamFont)

+ (UIFont *)blackEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Black" size:size];
}

+ (UIFont *)extraBoldEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-ExtraBold" size:size];
}

+ (UIFont *)boldEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Bold" size:size];
}

+ (UIFont *)ecamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Regular" size:size];
}

+ (UIFont *)lightEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Light" size:size];
}

+ (UIFont *)extraLightEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-ExtraLight" size:size];
}

+ (UIFont *)thinEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Thin" size:size];
}

+ (UIFont *)hairlineEcamFontOfSize:(CGFloat)size {
	return [UIFont fontWithName:@"Ecam-Black" size:size];
}

@end
