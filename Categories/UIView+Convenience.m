//
//  UIView+Convenience.m
//  BOW
//
//  Created by A101 on 7/17/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "UIView+Convenience.h"

static NSString *const BOWBorderLayerName   = @"BOWBorderLayer";
static NSString *const BOWGradientLayerName = @"BOWGradientLayerName";

@implementation UIView (Convenience)

- (void)setBorder:(BOWViewBorder)border thickness:(CGFloat)thickness color:(UIColor *)color {
	if (border & BOWViewBorderAll) {
		self.layer.borderWidth = thickness;
		self.layer.borderColor = color.CGColor;
		return;
	}
	
	if (border & BOWViewBorderTop) {
		CALayer *borderLayer = [CALayer layer];
		borderLayer.name = BOWBorderLayerName;
		borderLayer.backgroundColor = color.CGColor;
		borderLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, thickness);
		[self.layer addSublayer:borderLayer];
	}
	
	if (border & BOWViewBorderBottom) {
		CALayer *borderLayer = [CALayer layer];
		borderLayer.name = BOWBorderLayerName;
		borderLayer.backgroundColor = color.CGColor;
		borderLayer.frame = CGRectMake(0.0, self.frame.size.height - thickness, self.frame.size.width, thickness);
		[self.layer addSublayer:borderLayer];
	}
	
	if (border & BOWViewBorderLeft) {
		CALayer *borderLayer = [CALayer layer];
		borderLayer.name = BOWBorderLayerName;
		borderLayer.backgroundColor = color.CGColor;
		borderLayer.frame = CGRectMake(0.0, 0.0, thickness, self.frame.size.height);
		[self.layer addSublayer:borderLayer];
	}
	
	if (border & BOWViewBorderRight) {
		CALayer *borderLayer = [CALayer layer];
		borderLayer.name = BOWBorderLayerName;
		borderLayer.backgroundColor = color.CGColor;
		borderLayer.frame = CGRectMake(self.frame.size.width - thickness, 0.0, thickness, self.frame.size.height);
		[self.layer addSublayer:borderLayer];
	}
}

- (void)removeAllBorders {
	self.layer.borderWidth = 0;
	self.layer.borderColor = nil;
	
	for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
		CALayer *subLayer = self.layer.sublayers[i];
		if ([subLayer.name isEqualToString:BOWBorderLayerName]) {
			[subLayer removeFromSuperlayer];
		}
	}
}

- (void)cornerRadius:(CGFloat)cornerRadius type:(BOWViewCornerRadiusType)cornerRadiusType {
	if (cornerRadiusType == BOWViewCornerRadiusTypeNone) {
		self.layer.mask = nil;
		return;
	}
	
	UIRectCorner corners = (UIRectCornerTopLeft | UIRectCornerTopRight);
	if (cornerRadiusType == BOWViewCornerRadiusTypeBottom) {
		corners = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
	} else if (cornerRadiusType == BOWViewCornerRadiusTypeAll) {
		corners = (UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight);
	}
	CGSize cornerRadiusSize = CGSizeMake(cornerRadius, cornerRadius);
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
												   byRoundingCorners:corners
														 cornerRadii:cornerRadiusSize];
	
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = self.bounds;
	maskLayer.path = maskPath.CGPath;
	self.layer.mask = maskLayer;
}

- (void)addGlowWithRadius:(CGFloat)radius color:(UIColor *)color {
	self.layer.shadowOffset    = CGSizeZero;
	self.layer.shadowColor     = [color CGColor];
	self.layer.shadowRadius    = radius;
	self.layer.shadowOpacity   = 1;
}

- (void)removeGlow {
	self.layer.shadowColor   = nil;
	self.layer.shadowRadius  = 0;
	self.layer.shadowOpacity = 0;
}

- (void)setBackgroundGradientColors:(NSArray <UIColor *> *)colors {
	for (CALayer *layer in self.layer.sublayers) {
		if ([layer.name isEqualToString:BOWGradientLayerName]) {
			return;
		}
	}
	
	NSMutableArray *cgColors = [[NSMutableArray alloc] initWithCapacity:colors.count];
	for (UIColor *color in colors) {
		[cgColors addObject:(id)color.CGColor];
	}
	
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.name = BOWGradientLayerName;
	gradientLayer.frame = self.bounds;
	gradientLayer.colors = cgColors;
	[self.layer insertSublayer:gradientLayer atIndex:0];
}

- (UIImage *)imageRepresentation {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
	
	[self.layer renderInContext: UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

- (void)makeFrameCircle {
	CGFloat frameHeight = CGRectGetHeight(self.frame);
	self.layer.cornerRadius = frameHeight * 0.5;
	self.clipsToBounds = YES;
	self.layer.masksToBounds = YES;
}


#pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = cornerRadius;
	self.layer.masksToBounds = YES;
}

#pragma mark - Getters

- (CGFloat)cornerRadius {
	return self.layer.cornerRadius;
}

@end
