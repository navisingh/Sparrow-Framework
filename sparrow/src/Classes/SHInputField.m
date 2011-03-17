//
//  SHInputField.m
//  Sparrow
//
//  Created by Shilo White on 2/8/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//

#import "SHInputField.h"
#import "SPStage.h"
#import "SPTouchEvent.h"
#import "SPRectangle.h"
#import "SPEnterFrameEvent.h"

@implementation SHInputField

@synthesize focus = mFocus;

- (id)initWithWidth:(float)width height:(float)height text:(NSString*)text fontName:(NSString*)name fontSize:(float)size color:(uint)color  {
    if ((self = [super initWithWidth:width height:height text:text fontName:name fontSize:size color:color])) {
		mGhostInputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		mGhostInputField.autocorrectionType = UITextAutocorrectionTypeNo;
		mGhostInputField.text = text;
		mGhostInputField.delegate = self;
		mCursor = @"|";
		[self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
    }
    return self;
}

+ (SHInputField *)inputField {
	return [[[SHInputField alloc] init] autorelease];
}

+ (SHInputField *)inputFieldWithText:(NSString *)text {
	return [[[SHInputField alloc] initWithText:text] autorelease];
}

+ (SHInputField *)inputFieldWithWidth:(float)width height:(float)height text:(NSString*)text {
	return [[[SHInputField alloc] initWithWidth:width height:height text:text] autorelease];
}

+ (SHInputField *)inputFieldWithWidth:(float)width height:(float)height text:(NSString*)text fontName:(NSString*)name fontSize:(float)size color:(uint)color {
	return [[[SHInputField alloc] initWithWidth:width height:height text:text fontName:name fontSize:size color:color] autorelease];
}

- (void)onAddedToStage:(SPEvent *)event {
	[self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
	[self.stage.nativeView addSubview:mGhostInputField];
	[mGhostInputField release];
	[mGhostInputField addTarget:self action:@selector(onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[self.stage addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)onTouch:(SPTouchEvent *)event {
	SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		self.focus = YES;
		return;
	}
	
	SPTouch *stageTouch = [[event touchesWithTarget:self.stage andPhase:SPTouchPhaseBegan] anyObject];
	if (stageTouch) {
		self.focus = NO;
	}
}

- (void)onTextFieldDidChange:(UITextField *)textField {
	self.text = [textField.text stringByAppendingString:mCursor];
	mCursorShowing = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	self.focus = NO;
	return YES;
}

- (void)setFocus:(BOOL)focus {
	if (focus != mFocus) {
		mFocus = focus;
		if (mFocus) {
			[mGhostInputField becomeFirstResponder];
			[self addCursor];
			mCursorTotalTime = 0;
			[self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
		} else {
			[self removeEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
			[mGhostInputField resignFirstResponder];
			[self removeCursor];
		}
	}
}

- (void)addCursor {
	self.text = [self.text stringByAppendingString:mCursor];
}

- (void)removeCursor {
	self.text = [self.text substringToIndex:self.text.length-1];
}

- (void)showCursor {
	if (mCursorShowing) return;
	mCursorShowing = YES;
	[self removeCursor];
	[self addCursor];
}

- (void)hideCursor {
	if (!mCursorShowing) return;
	mCursorShowing = NO;
	[self removeCursor];
	self.text = [self.text stringByAppendingFormat:@"."];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
	mCursorTotalTime += event.passedTime;
	if ((int)mCursorTotalTime % 2) {
		[self hideCursor];
	} else {
		[self showCursor];
	}
}

- (void)dealloc {
	[self removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
	[mGhostInputField removeTarget:self action:@selector(onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	if (mFocus) self.focus = NO;
	mGhostInputField.delegate = nil;
	[mGhostInputField removeFromSuperview];
	mCursor = nil;
	[super dealloc];
}
@end