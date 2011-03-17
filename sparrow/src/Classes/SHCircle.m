//
//  SHCircle.m
//  Sparrow
//
//  Created by Shilo White on 1/27/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SHCircle.h"
#import "SPMacros.h"
#import "SPRenderSupport.h"

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation SHCircle

@synthesize fill = mFill;
@synthesize innerColor = mInnerColor;
@synthesize outerColor = mOuterColor;
@synthesize border = mBorder;
@synthesize borderColor = mBorderColor;
@synthesize borderWidth = mBorderWidth;

- (id)init {
	return [self initWithWidth:32 height:32];
}

- (id)initWithWidth:(float)width height:(float)height {
	if (self = [super init]) {
		mWidth = width;
		mHeight = height;
		
		mFill = YES;
		self.color = SP_WHITE;
		mBorder = NO;
		mBorderColor = SP_WHITE;
		mBorderWidth = 1.0f;
		mDegrees = 360;
		mCenterRotation = 0;
		
		[self drawVertices];
    }
    return self;
}

+ (SHCircle *)circle {
	return [[[SHCircle alloc] initWithWidth:32 height:32] autorelease];
}

+ (SHCircle *)circleWithWidth:(float)width height:(float)height {
	return [[[SHCircle alloc] initWithWidth:width height:height] autorelease];
}

- (void)drawVertices {
	float widthRadius = mWidth/2;
	float heightRadius = mHeight/2;
	
	mVertexCoords[0] = widthRadius;
	mVertexCoords[1] = heightRadius;
	for (int i=0; i<mDegrees*2+1; i+=2) {
		mVertexCoords[i+2] = mBorderVertexCoords[i+2] = cos(SP_D2R(i/2+mCenterRotation)) * widthRadius + widthRadius;
		mVertexCoords[i+3] = mBorderVertexCoords[i+3] = sin(SP_D2R(i/2+mCenterRotation)) * heightRadius + heightRadius;
	}
	if (mDegrees < 360) {
		mBorderVertexCoords[0] = widthRadius;
		mBorderVertexCoords[1] = heightRadius;
	} else {
		mBorderVertexCoords[0] = mBorderVertexCoords[2];
		mBorderVertexCoords[1] = mBorderVertexCoords[3];
	}
}

- (void)render:(SPRenderSupport *)support {
	float alpha = self.alpha;
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	[support bindTexture:nil];
	
	[self renderFill:support alpha:alpha];
    [self renderBorder:support alpha:alpha];
	
    glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
}

- (void)renderFill:(SPRenderSupport *)support alpha:(float)alpha {
	if (!mFill || !mDegrees) return;
	uint colors[mDegrees+2];
	
	for (int i=0; i<mDegrees+2; i++) {
		if (i==0) colors[i] = [support convertColor:mInnerColor alpha:alpha];
		else colors[i] = [support convertColor:mOuterColor alpha:alpha];
	}
	
	glVertexPointer(2, GL_FLOAT, 0, mVertexCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glDrawArrays(GL_TRIANGLE_FAN, 0, mDegrees+2);
}

- (void)renderBorder:(SPRenderSupport *)support alpha:(float)alpha {
	if (!mBorder || !mDegrees) return;
	uint colors[mDegrees+2];
	
	for (int i=0; i<mDegrees+2; i++) colors[i] = [support convertColor:mBorderColor alpha:alpha];
	
	glVertexPointer(2, GL_FLOAT, 0, mBorderVertexCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glLineWidth(mBorderWidth);
	glDrawArrays(GL_LINE_LOOP, 0, mDegrees+2);
}

- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetCoordinateSpace {
	if (targetCoordinateSpace == self)
        return [SPRectangle rectangleWithX:0 y:0 width:mWidth height:mHeight];
    
    SPMatrix *transformationMatrix = [self transformationMatrixToSpace:targetCoordinateSpace];
    SPPoint *point = [[SPPoint alloc] init];
    
	float tempVertexCoords[8];
	tempVertexCoords[2] = mWidth;
	tempVertexCoords[5] = mHeight;
	tempVertexCoords[6] = mWidth;
	tempVertexCoords[7] = mHeight;
	
    float minX = FLT_MAX, maxX = -FLT_MAX, minY = FLT_MAX, maxY = -FLT_MAX;
    for (int i=0; i<4; ++i) {
        point.x = tempVertexCoords[2*i];
        point.y = tempVertexCoords[2*i+1];
        SPPoint *transformedPoint = [transformationMatrix transformPoint:point];
        float tfX = transformedPoint.x; 
        float tfY = transformedPoint.y;
        minX = MIN(minX, tfX);
        maxX = MAX(maxX, tfX);
        minY = MIN(minY, tfY);
        maxY = MAX(maxY, tfY);
    }
    [point release];
    return [SPRectangle rectangleWithX:minX y:minY width:maxX-minX height:maxY-minY];    
}

- (void)setCenterX:(float)centerX {
	self.x = centerX - (mWidth/2);
}

- (float)centerX {
	return self.x + (mWidth/2);
}

- (void)setCenterY:(float)centerY {
	self.y = centerY - (mHeight/2);
}

- (float)centerY {
	return self.y + (mHeight/2);
}

- (void)setRadiusX:(float)radiusX {
	self.width = radiusX*2;
}

- (float)radiusX {
	return mWidth/2;
}

- (void)setRadiusY:(float)radiusY {
	self.height = radiusY*2;
}

- (float)radiusY {
	return mHeight/2;
}

- (void)setWidth:(float)width {
	mWidth = width;
	[self drawVertices];
	[super setWidth:mWidth];
}

- (void)setHeight:(float)height {
	mHeight = height;
	[self drawVertices];
	[super setHeight:mHeight];
}

- (void)setColor:(uint)color {
	mInnerColor = mOuterColor = color;
}

- (uint)color {
	return mInnerColor;
}

- (void)setDegrees:(int)degrees {
	if (degrees < 0 || degrees > 360)
		[NSException raise:NSInvalidArgumentException format:@"Degrees must have an integer value between 0 and 360.", NSStringFromSelector(_cmd)];
	
	if (degrees != mDegrees) {
		mDegrees = degrees;
		[self drawVertices];
	}
}

- (int)degrees {
	return mDegrees;
}

- (void)setCenterRotation:(float)centerRotation {
	if (centerRotation != mCenterRotation) {
		mCenterRotation = centerRotation;
		[self drawVertices];
	}
}

- (float)centerRotation {
	return mCenterRotation;
}
@end