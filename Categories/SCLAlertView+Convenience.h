//
//  SCLAlertView+Convenience.h
//  BOW
//
//  Created by A101 on 7/24/16.
//  Copyright © 2016 A101. All rights reserved.
//

#import "SCLAlertView.h"

typedef void(^SCLAlertViewTapBlock)(NSUInteger buttonIndex);
typedef void(^SCLAlertViewTextFieldTapBlock)(NSUInteger buttonIndex, NSString *text);

@interface SCLAlertView (Convenience)

+ (instancetype)showErrorWithTitle:(NSString *)title
						   message:(NSString *)message;

+ (instancetype)showErrorWithTitle:(NSString *)title
						   message:(NSString *)message
						  tapBlock:(SCLAlertViewTapBlock)tapBlock;

+ (instancetype)showInfoWithTitle:(NSString *)title
						  message:(NSString *)message;

+ (instancetype)showInfoWithTitle:(NSString *)title
						  message:(NSString *)message
						 tapBlock:(SCLAlertViewTapBlock)tapBlock;

+ (instancetype)showInfoWithTitle:(NSString *)title
						  message:(NSString *)message
					 buttonTitles:(NSArray <NSString *> *)buttonTitles
						 tapBlock:(SCLAlertViewTapBlock)tapBlock;

+ (instancetype)showSuccessWithTitle:(NSString *)title
							 message:(NSString *)message
							tapBlock:(SCLAlertViewTapBlock)tapBlock;

+ (instancetype)showQuestionWithTitle:(NSString *)title
							  message:(NSString *)message
						 buttonTitles:(NSArray <NSString *> *)buttonTitles
							 tapBlock:(SCLAlertViewTapBlock)tapBlock;

+ (void)showAlertOnViewController:(UIViewController *)viewController
							title:(NSString *)title
						  message:(NSString *)message
					textFieldText:(NSString *)textFieldText
				  textPlaceholder:(NSString *)textPlaceholder
					 keyboardType:(UIKeyboardType)keyboardType
					 buttonTitles:(NSArray <NSString *> *)buttonTitles
						 tapBlock:(SCLAlertViewTextFieldTapBlock)tapBlock;
@end
