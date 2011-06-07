//
// SHFingerTrail.m
// FingerTrailSample
//
// Created by Shilo White on 3/28/11.
// Copyright 2011 Shilocity Productions. All rights reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the Simplified BSD License.
//

#define SP_COLOR_PART_RED(color) (((color) >> 16) & 0xff)
#define SP_COLOR_PART_GREEN(color) (((color) >> 8) & 0xff)
#define SP_COLOR_PART_BLUE(color) ( (color) & 0xff)

#import "SHFingerTrail.h"
#import "SPTouchEvent.h"
#import "SPEnterFrameEvent.h"
#import "SPPoint.h"
#import "SPTween.h"
#import "SPJuggler.h"
#import "SPStage.h"
#import "SPTexture.h"
#import "SPImage.h"
#import "SPDisplayObjectContainer.h"

@interface SHFingerTrail ()
- (void)setGradient;
- (void)drawTrailWithCurrentLocation:(SPPoint *)currentLocation previousLocation:(SPPoint *)previousLocation;
- (void)startTweenWithTrail:(SPSprite *)target distance:(float)distance;
@end


@implementation SHFingerTrail

@synthesize style = mStyle;
@synthesize time = mTime;
@synthesize size = mSize;
@synthesize alwaysOnTop = mAlwaysOnTop;
@synthesize showOnTouchBegin = mShowOnTouchBegin;
@synthesize fade = mFade;
@synthesize innerColor = mInnerColor;
@synthesize outerColor = mOuterColor;

- (id)init {
    return [self initWithTime:0.2f];
}

- (id)initWithTime:(float)time {
    return [self initWithTime:time size:30.0f];
}

- (id)initWithTime:(float)time size:(float)size {
    if (self = [super init]) {
        mStyle = SHFingerTrailStyleSpiky;
        mTime = time;
        mSize = size;
        mInnerColor = 0xadd8e6;
        mOuterColor = 0x0000ff;
        [self setGradient];
        [self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
        [self addEventListener:@selector(onRemovedFromStage:) atObject:self forType:SP_EVENT_TYPE_REMOVED_FROM_STAGE];
    }
    return self;
}

+ (SHFingerTrail *)fingerTrail {
    return [[[SHFingerTrail alloc] init] autorelease];
}

+ (SHFingerTrail *)fingerTrailWithTime:(float)time {
    return [[[SHFingerTrail alloc] initWithTime:time] autorelease];
}

+ (SHFingerTrail *)fingerTrailWithTime:(float)time size:(float)size {
    return [[[SHFingerTrail alloc] initWithTime:time size:size] autorelease];
}

- (void)setInnerColor:(uint)innerColor {
    if (innerColor != mInnerColor) {
        mInnerColor = innerColor;
        [self setGradient];
    }
}

- (void)setOuterColor:(uint)outerColor {
    if (outerColor != mOuterColor) {
        mOuterColor = outerColor;
        [self setGradient];
    }
}

- (void)setColor:(uint)color {
    mInnerColor = mOuterColor = color;
    [self setGradient];
}

- (uint)color {
    return mInnerColor;
}

- (void)setAlwaysOnTop:(BOOL)alwaysOnTop {
    if (alwaysOnTop != mAlwaysOnTop) {
        mAlwaysOnTop = alwaysOnTop;
        if (mAlwaysOnTop) [self addEventListener:@selector(checkOnTop:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        else [self removeEventListener:@selector(checkOnTop:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
}

- (void)checkOnTop:(SPEnterFrameEvent *)event {
    SPDisplayObjectContainer *parent = self.parent;
    if ([parent childIndex:self] < parent.numChildren-1) [parent addChild:self];
}

- (void)onAddedToStage:(SPEvent *)event {
    [self.stage addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    SPStage *stage = (SPStage *)self.stage;
    mJuggler = stage.juggler;
}

- (void)onRemovedFromStage:(SPEvent *)event {
    [self.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    mJuggler = nil;
}

- (void)onTouch:(SPTouchEvent *)event {
    NSArray *touches = [[event touches] allObjects];
    
    for (SPTouch *touch in touches) {
        if (touch.phase == SPTouchPhaseBegan && mShowOnTouchBegin || touch.phase == SPTouchPhaseMoved) {
            [self drawTrailWithCurrentLocation:[touch locationInSpace:self] previousLocation:[touch previousLocationInSpace:self]];
        }
    }
}

- (void)setGradient {
    mGradient[0] = SP_COLOR_PART_RED(mOuterColor);
    mGradient[1] = SP_COLOR_PART_GREEN(mOuterColor);
    mGradient[2] = SP_COLOR_PART_BLUE(mOuterColor);
    mGradient[3] = 1.0f;
    mGradient[4] = SP_COLOR_PART_RED(mInnerColor);
    mGradient[5] = SP_COLOR_PART_GREEN(mInnerColor);
    mGradient[6] = SP_COLOR_PART_BLUE(mOuterColor);
    mGradient[7] = 1.0f;
    mGradient[8] = SP_COLOR_PART_RED(mOuterColor);
    mGradient[9] = SP_COLOR_PART_GREEN(mOuterColor);
    mGradient[10] = SP_COLOR_PART_BLUE(mOuterColor);
    mGradient[11] = 1.0f;
}

- (void)drawTrailWithCurrentLocation:(SPPoint *)currentLocation previousLocation:(SPPoint *)previousLocation {
    float radius = mSize/2;
    float distance = [SPPoint distanceFromPoint:previousLocation toPoint:currentLocation];
    SPTexture *trailTexture = [[SPTexture alloc] initWithWidth:mSize height:distance+mSize
                                                          draw:^(CGContextRef context) {
                                                              CGContextBeginTransparencyLayer(context, NULL);
                                                              
                                                              CGContextSetLineWidth(context, mSize);
                                                              CGContextSetLineCap(context, kCGLineCapRound);
                                                              CGContextMoveToPoint(context, radius, radius);
                                                              CGContextAddLineToPoint(context, radius, distance+radius);
                                                              CGContextStrokePath(context);
                                                              
                                                              CGContextSetBlendMode(context, kCGBlendModeSourceIn);
                                                              
                                                              CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
                                                              CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, mGradient, NULL, 3);
                                                              CGColorSpaceRelease(baseSpace);
                                                              baseSpace = NULL;
                                                              
                                                              CGContextDrawLinearGradient(context, gradient, CGPointMake(0, (distance+mSize)/2), CGPointMake(mSize, (distance+mSize)/2), 0);
                                                              CGGradientRelease(gradient);
                                                              gradient = NULL;
                                                              
                                                              CGContextEndTransparencyLayer(context);
                                                          }];
    
    SPImage *trailImage = [[SPImage alloc] initWithTexture:trailTexture];
    trailImage.x = -ceil(radius);
    trailImage.y = -ceil(radius);
    
    SPSprite *trailSprite = [[SPSprite alloc] init];
    trailSprite.x = currentLocation.x;
    trailSprite.y = currentLocation.y;
    trailSprite.rotation = atan2(currentLocation.x-previousLocation.x, previousLocation.y-currentLocation.y);
    [trailSprite addChild:trailImage];
    
    [self addChild:trailSprite];
    [self startTweenWithTrail:trailSprite distance:distance];
    
    [trailSprite release];
    [trailImage release];
    [trailTexture release];
}

- (void)startTweenWithTrail:(SPSprite *)target distance:(float)distance {
    SPTween *tween = [SPTween tweenWithTarget:target time:mTime];
    
    switch (mStyle) {
        case SHFingerTrailStyleSpiky:
            [tween animateProperty:@"scaleX" targetValue:0];
            if (distance < 5) [tween animateProperty:@"scaleY" targetValue:0];
            break;
        case SHFingerTrailStyleBubbly:
            [tween animateProperty:@"scaleX" targetValue:0];
            [tween animateProperty:@"scaleY" targetValue:0];
            break;
        case SHFingerTrailStyleSlinky:
            [tween animateProperty:@"scaleY" targetValue:0];
            break;
    }
    if (mFade) [tween animateProperty:@"alpha" targetValue:0];
    
    [tween addEventListener:@selector(onTweenCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [mJuggler addObject:tween];
}

- (void)onTweenCompleted:(SPEvent *)event {
    SPTween *tween = (SPTween *)event.target;
    [tween removeEventListener:@selector(onTweenCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [self removeChild:(SPDisplayObject *)tween.target];
}
@end

