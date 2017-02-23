//
//  UIView+Convenience.h
//  BOW
//
//  Created by A101 on 7/17/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BOWViewBorder) {
	BOWViewBorderAll    = 1 << 1,
	BOWViewBorderTop    = 1 << 2,
	BOWViewBorderLeft   = 1 << 3,
	BOWViewBorderBottom = 1 << 4,
	BOWViewBorderRight  = 1 << 5
};

typedef NS_ENUM(NSUInteger, BOWViewCornerRadiusType) {
	BOWViewCornerRadiusTypeNone,
	BOWViewCornerRadiusTypeTop,
	BOWViewCornerRadiusTypeBottom,
	BOWViewCornerRadiusTypeAll
};

@interface UIView (Convenience)

/**
 *  Set or get the view's layer corner radius.
 */
@property (assign, nonatomic) CGFloat cornerRadius;

/**
 *  Set borders around the view.
 *
 *  @param border    The border type/positions.
 *  @param thickness The thickness of the border.
 *  @param color     The color of the border.
 */
- (void)setBorder:(BOWViewBorder)border thickness:(CGFloat)thickness color:(UIColor *)color;

- (void)cornerRadius:(CGFloat)cornerRadius type:(BOWViewCornerRadiusType)cornerRadiusType;

/**
 *  Remove all borders around the view created using setBorder:thickness:color: method.
 */
- (void)removeAllBorders;

/**
 *  Add glow effect around the view.
 *
 *  @param radius The radius of the glow.
 *  @param color  The color of the glow.
 */
- (void)addGlowWithRadius:(CGFloat)radius color:(UIColor *)color;

/**
 *  Remove glow effect around the view.
 */
- (void)removeGlow;

/**
 *  Set the background color of the view with gradient effect.
 *
 *  @param colors The array of colors.
 */
- (void)setBackgroundGradientColors:(NSArray <UIColor *> *)colors;

/**
 *  Convert view to image.
 *
 *  @return The image representation of the view.
 */
- (UIImage *)imageRepresentation;

/**
 *  Make the view circle. To make a perfect circle, view's width and height must be equal.
 */
- (void)makeFrameCircle;

@end
