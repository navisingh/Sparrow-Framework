
//
//  SHInputField.h
//  Sparrow
//
//  Created by Shilo White on 2/8/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPTextField.h"

@interface SHInputField : SPTextField <UITextFieldDelegate> {
	UITextField *mGhostInputField;
	NSString *mCursor;
	BOOL mCursorShowing;
	float mCursorTotalTime;
	BOOL mFocus;
}

@property (nonatomic, assign) BOOL focus;

+ (SHInputField *)inputField;
+ (SHInputField *)inputFieldWithText:(NSString *)text;
+ (SHInputField *)inputFieldWithWidth:(float)width height:(float)height text:(NSString*)text;
+ (SHInputField *)inputFieldWithWidth:(float)width height:(float)height text:(NSString*)text fontName:(NSString*)name fontSize:(float)size color:(uint)color;
- (void)addCursor;
- (void)removeCursor;
- (void)showCursor;
- (void)hideCursor;
@end