//
// SHClippedSprite.m
// Sparrow
//
// Created by Shilo White on 5/30/11.
// Copyright 2011 Shilocity Productions. All rights reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the Simplified BSD License.
//

#import "SHClippedSprite.h"
#import "SPEvent.h"
#import "SPQuad.h"
#import "SPStage.h"
#import <OpenGLES/ES1/gl.h>

@interface SHClippedSprite ()
- (void)onAddedToStage:(SPEvent *)event;
@end

@implementation SHClippedSprite

@synthesize clip = mClip;
@synthesize clipping = mClipping;

+ (SHClippedSprite *)clippedSprite {
    return [[[SHClippedSprite alloc] init] autorelease];
}

- (SHClippedSprite *)init {
    if ((self = [super init])) {
        mClip = [[SPQuad alloc] init];
        mClip.visible = NO;
        mClip.width = 0;
        mClip.height = 0;
        [self addChild:mClip];
        mClipping = NO;
        [self addEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
    }
    return self;
}

- (void)onAddedToStage:(SPEvent *)event {
    [self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
    mStage = (SPStage *)self.stage;
}

- (void)render:(SPRenderSupport *)support {
    if (mClipping) {
        glEnable(GL_SCISSOR_TEST);
        SPRectangle *clip = [mClip boundsInSpace:mStage];
        glScissor((clip.x*[SPStage contentScaleFactor]), (mStage.height*[SPStage contentScaleFactor])-(clip.y*[SPStage contentScaleFactor])-(clip.height*[SPStage contentScaleFactor]), (clip.width*[SPStage contentScaleFactor]), (clip.height*[SPStage contentScaleFactor]));
        [super render:support];
        glDisable(GL_SCISSOR_TEST);
    } else {
        [super render:support];
    }
}

- (void)dealloc {
    [self removeEventListener:@selector(onAddedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
    [mClip release];
    [super dealloc];
}
@end

