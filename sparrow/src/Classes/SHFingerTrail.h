//
// SHFingerTrail.h
// FingerTrailSample
//
// Created by Shilo White on 3/28/11.
// Copyright 2011 Shilocity Productions. All rights reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the Simplified BSD License.
//

typedef enum {
    SHFingerTrailStyleSpiky,
    SHFingerTrailStyleBubbly,
    SHFingerTrailStyleSlinky,
} SHFingerTrailStyle;

#import <Foundation/Foundation.h>
#import "SPSprite.h"
@class SPJuggler;

@interface SHFingerTrail : SPSprite {
    SPJuggler *mJuggler;
    SHFingerTrailStyle mStyle;
    float mTime;
    float mSize;
    int mMaxNumberOfFingers;
    BOOL mAlwaysOnTop;
    BOOL mShowOnTouchBegin;
    BOOL mFade;
    uint mInnerColor;
    uint mOuterColor;
    float mGradient[12];
}

@property (nonatomic, assign) SHFingerTrailStyle style;
@property (nonatomic, assign) float time;
@property (nonatomic, assign) float size;
@property (nonatomic, assign) BOOL alwaysOnTop;
@property (nonatomic, assign) BOOL showOnTouchBegin;
@property (nonatomic, assign) BOOL fade;
@property (nonatomic, assign) uint color;
@property (nonatomic, assign) uint innerColor;
@property (nonatomic, assign) uint outerColor;


- (id)initWithTime:(float)time;
- (id)initWithTime:(float)time size:(float)size;
+ (SHFingerTrail *)fingerTrail;
+ (SHFingerTrail *)fingerTrailWithTime:(float)time;
+ (SHFingerTrail *)fingerTrailWithTime:(float)time size:(float)size;
@end

