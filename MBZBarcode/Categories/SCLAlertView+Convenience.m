//
//  SCLAlertView+Convenience.m
//  BOW
//
//  Created by A101 on 7/24/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "SCLAlertView+Convenience.h"

#import "SCLMacros.h"
#import "SCLAlertViewStyleKit.h"

//Categories
#import "UIFont+EcamFont.h"
#import "UIColor+More.h"

//Resources
#import "MBZConstants.h"

@implementation SCLAlertView (Convenience)

+ (SCLAlertView *)alertViewInNewWindow {
	SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
	
	[alertView setTitleFontFamily:[UIFont ecamFontOfSize:24].fontName withSize:24];
	[alertView setBodyTextFontFamily:[UIFont ecamFontOfSize:16].fontName withSize:16];
	[alertView setButtonsTextFontFamily:[UIFont boldEcamFontOfSize:18].fontName withSize:18];
	
	alertView.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
	alertView.hideAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
	
	return alertView;
}

+ (instancetype)showErrorWithTitle:(NSString *)title message:(NSString *)message {
	SCLAlertView *alertView = [self alertViewInNewWindow];

	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showError:title
					subTitle:message
			closeButtonTitle:@"OK"
					duration:0];
	});
	
	return alertView;
}

+ (instancetype)showErrorWithTitle:(NSString *)title
						   message:(NSString *)message
						  tapBlock:(SCLAlertViewTapBlock)tapBlock {
	SCLAlertView *alertView = [self alertViewInNewWindow];
	
	[alertView addButton:@"OK" actionBlock:^(void) {
		if (tapBlock) {
			tapBlock(0);
		}
	}];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showError:title
					subTitle:message
			closeButtonTitle:nil
					duration:0];
	});
	
	return alertView;
}

+ (instancetype)showInfoWithTitle:(NSString *)title message:(NSString *)message {
	SCLAlertView *alertView = [self alertViewInNewWindow];
	alertView.customViewColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showInfo:title
				   subTitle:message
		   closeButtonTitle:@"OK"
				   duration:0];
	});
	
	return alertView;
}

+ (instancetype)showInfoWithTitle:(NSString *)title
						  message:(NSString *)message
					 buttonTitles:(NSArray <NSString *> *)buttonTitles
						 tapBlock:(SCLAlertViewTapBlock)tapBlock {
	SCLAlertView *alertView = [self alertViewInNewWindow];
	alertView.customViewColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
	
	NSUInteger index = 0;
	for (NSString *buttonTitle in buttonTitles) {
		[alertView addButton:buttonTitle actionBlock:^(void) {
			if (tapBlock) {
				tapBlock(index);
			}
		}];
		index++;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showInfo:title
				   subTitle:message
		   closeButtonTitle:nil
				   duration:0];
	});
	
	return alertView;
}

+ (instancetype)showInfoWithTitle:(NSString *)title
						  message:(NSString *)message
						 tapBlock:(SCLAlertViewTapBlock)tapBlock {
	SCLAlertView *alertView = [self alertViewInNewWindow];
	alertView.customViewColor = [UIColor colorWithHex:THEME_COLOR_ORANGE];
	
	[alertView addButton:@"OK" actionBlock:^(void) {
		if (tapBlock) {
			tapBlock(0);
		}
	}];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showInfo:title
				   subTitle:message
		   closeButtonTitle:nil
				   duration:0];
	});
	
	return alertView;
}

+ (instancetype)showSuccessWithTitle:(NSString *)title
							 message:(NSString *)message
							tapBlock:(SCLAlertViewTapBlock)tapBlock {
	SCLAlertView *alertView = [self alertViewInNewWindow];

	[alertView addButton:@"OK" actionBlock:^(void) {
		if (tapBlock) {
			tapBlock(0);
		}
	}];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showSuccess:title
					  subTitle:message
			  closeButtonTitle:nil
					  duration:0];
	});
	
	return alertView;
}

+ (instancetype)showQuestionWithTitle:(NSString *)title
							  message:(NSString *)message
						 buttonTitles:(NSArray <NSString *> *)buttonTitles
							 tapBlock:(SCLAlertViewTapBlock)tapBlock {
	SCLAlertView *alertView = [self alertViewInNewWindow];
	alertView.customViewColor = UIColorFromHEX(0x2866BF);
	
	NSUInteger index = 0;
	for (NSString *buttonTitle in buttonTitles) {
		[alertView addButton:buttonTitle actionBlock:^(void) {
			if (tapBlock) {
				tapBlock(index);
			}
		}];
		index++;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[alertView showQuestion:title
					   subTitle:message
			   closeButtonTitle:nil
					   duration:0];
	});
	
	return alertView;
}

+ (void)showAlertOnViewController:(UIViewController *)viewController
							title:(NSString *)title
						  message:(NSString *)message
					textFieldText:(NSString *)textFieldText
				  textPlaceholder:(NSString *)textPlaceholder
					 keyboardType:(UIKeyboardType)keyboardType
					 buttonTitles:(NSArray <NSString *> *)buttonTitles
						 tapBlock:(SCLAlertViewTextFieldTapBlock)tapBlock {
	
	SCLALertViewTextFieldBuilder *textFieldBuilder = [[SCLALertViewTextFieldBuilder alloc] init];
	textFieldBuilder.title(textPlaceholder);
	
	SCLAlertViewBuilder *builder = [[SCLAlertViewBuilder alloc] init];
	builder.showAnimationType(SCLAlertViewShowAnimationFadeIn);
	builder.hideAnimationType(SCLAlertViewHideAnimationFadeOut);
	builder.shouldDismissOnTapOutside(NO);
	builder.addTextFieldWithBuilder(textFieldBuilder);
	builder.alertView.circleIconHeight *= 0.5;

	[builder.alertView setTitleFontFamily:[UIFont ecamFontOfSize:24].fontName withSize:24];
	[builder.alertView setBodyTextFontFamily:[UIFont ecamFontOfSize:16].fontName withSize:16];
	[builder.alertView setButtonsTextFontFamily:[UIFont boldEcamFontOfSize:18].fontName withSize:18];
	
	textFieldBuilder.textField.text = textFieldText;
	textFieldBuilder.textField.textAlignment = NSTextAlignmentCenter;
	textFieldBuilder.textField.keyboardType = keyboardType;
	textFieldBuilder.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textFieldBuilder.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	textFieldBuilder.textField.font = [UIFont ecamFontOfSize:16];
	
	NSUInteger index = 0;
	for (NSString *buttonTitle in buttonTitles) {
		SCLALertViewButtonBuilder *buttonBuilder = [[SCLALertViewButtonBuilder alloc] init];
		buttonBuilder.title(buttonTitle);
		buttonBuilder.actionBlock(^{
			if (tapBlock) {
				NSString *code = [textFieldBuilder.textField.text copy];
				tapBlock(index, code);
			}
		});
		builder.addButtonWithBuilder(buttonBuilder);
		index++;
	}

	SCLAlertViewShowBuilder *showBuilder = [[SCLAlertViewShowBuilder alloc] init];
	showBuilder.style(SCLAlertViewStyleCustom);
	showBuilder.image([SCLAlertViewStyleKit imageOfEdit]);
	showBuilder.color([UIColor colorWithHex:THEME_COLOR_ORANGE]);
	showBuilder.title(title);
	showBuilder.subTitle(message);
	showBuilder.duration(0.0f);
	
	[showBuilder showAlertView:builder.alertView onViewController:viewController];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[textFieldBuilder.textField becomeFirstResponder];
	});
}

@end
