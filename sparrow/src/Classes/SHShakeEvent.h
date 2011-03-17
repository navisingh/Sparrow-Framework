//
//  SHShakeEvent.h
//  Sparrow
//
//  Created by Shilo White on 3/8/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#define SH_EVENT_TYPE_SHAKE @"shake"

#import <Foundation/Foundation.h>
#import "SPEvent.h"

typedef enum 
{    
	SHShakePhaseBegan,
	SHShakePhaseEnded,
	SHShakePhaseCancelled
} SHShakePhase;

@interface SHShakeEvent : SPEvent {
	SHShakePhase mPhase;
}

@property (nonatomic, readonly) SHShakePhase phase;

- (id)initWithType:(NSString *)type phase:(SHShakePhase)phase;
- (id)initWithType:(NSString *)type phase:(SHShakePhase)phase bubbles:(BOOL)bubbles;
+ (SHShakeEvent *)eventWithType:(NSString *)type phase:(SHShakePhase)phase;
+ (SHShakeEvent *)eventWithType:(NSString *)type phase:(SHShakePhase)phase bubbles:(BOOL)bubbles;
@end