//
//  SXCheckbox.m
//  Sparrow
//
//  Created by Navi Singh on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SXCheckbox.h"


@implementation SXCheckBox
@synthesize checked = checked_;
@synthesize offset = offset_;

- (void)setChecked:(BOOL)checked
{
    checkedImage_.visible = checked_ = checked;
}

- (void)setOffset:(short)n
{
    offset_ = n;
    checkedImage_.x = offset_;
    checkedImage_.y = -offset_;
}

- (id) initWithTexturesUnchecked:(SPTexture *)unchecked Checked:(SPTexture *)checked
{
    if ((self = [super init]))
    {
        checked_ = NO;

        uncheckedImage_ = [SPImage imageWithTexture:unchecked];
        [self addChild:uncheckedImage_];
		[uncheckedImage_ addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        uncheckedImage_.touchable = YES;

        checkedImage_ = [SPImage imageWithTexture:checked];
        [self addChild:checkedImage_];
 
        [self setOffset:8];

        checkedImage_.touchable = NO;
        
        checkedImage_.visible = NO;
    }
    return self;
}

- (void)onTouch:(SPTouchEvent *)event {
	SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
	if (touch) {
        checked_ = !checked_;
        checkedImage_.visible = checked_;
        [self dispatchEvent:[SPEvent eventWithType:SX_CHECKBOX_CHANGED]];
    }
}

- (void)dealloc
{
    [uncheckedImage_ release];
    [checkedImage_  release];
    
    [super dealloc];
}

+ (SXCheckBox *)checkboxWithTexturesUnchecked:(SPTexture *)unchecked Checked:(SPTexture *)checked
{
    return [[[SXCheckBox alloc] initWithTexturesUnchecked:unchecked Checked:checked] autorelease];
}


@end
