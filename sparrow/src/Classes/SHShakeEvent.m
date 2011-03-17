//
//  SHShakeEvent.m
//  Sparrow
//
//  Created by Shilo White on 3/8/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SHShakeEvent.h"
#import "SPView.h"
#import "SPStage.h"

@implementation SHShakeEvent

@synthesize phase = mPhase;

- (id)initWithType:(NSString *)type phase:(SHShakePhase)phase {
	return [self initWithType:type phase:phase bubbles:YES];
}

- (id)initWithType:(NSString *)type phase:(SHShakePhase)phase bubbles:(BOOL)bubbles {
	if (self = [super initWithType:type bubbles:bubbles]) {        
		mPhase = phase;
    }
    return self;
}

+ (SHShakeEvent *)eventWithType:(NSString *)type phase:(SHShakePhase)phase {
	return [[[SHShakeEvent alloc] initWithType:type phase:phase bubbles:YES] autorelease];
}

+ (SHShakeEvent *)eventWithType:(NSString *)type phase:(SHShakePhase)phase bubbles:(BOOL)bubbles {
	return [[[SHShakeEvent alloc] initWithType:type phase:phase bubbles:bubbles] autorelease];
}
@end

@implementation SPView (shake)
- (void)didMoveToWindow {
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		SHShakeEvent *beganEvent = [[SHShakeEvent alloc] initWithType:SH_EVENT_TYPE_SHAKE phase:SHShakePhaseBegan];
		[self.stage dispatchEvent:beganEvent];
		[beganEvent release];
	}
	[super motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		SHShakeEvent *endedEvent = [[SHShakeEvent alloc] initWithType:SH_EVENT_TYPE_SHAKE phase:SHShakePhaseEnded];
		[self.stage dispatchEvent:endedEvent];
		[endedEvent release];
	}
	[super motionEnded:motion withEvent:event];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		SHShakeEvent *cancelledEvent = [[SHShakeEvent alloc] initWithType:SH_EVENT_TYPE_SHAKE phase:SHShakePhaseCancelled];
		[self.stage dispatchEvent:cancelledEvent];
		[cancelledEvent release];
	}
	[super motionCancelled:motion withEvent:event];
}
@end
