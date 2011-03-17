//
//  SPQuad.m
//  Sparrow
//
//  Created by Daniel Sperl on 15.03.09.
//  Copyright 2009 Incognitek. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPQuad.h"
#import "SPRectangle.h"
#import "SPMacros.h"
#import "SPPoint.h"

@implementation SPQuad
@synthesize border = mBorder;
@synthesize borderWidth = mBorderWidth;
@synthesize fill = mFill;
@synthesize scewX1 = mScewX1;
@synthesize scewX2 = mScewX2;
@synthesize scewY1 = mScewY1;
@synthesize scewY2 = mScewY2;

- (id)initWithWidth:(float)width height:(float)height color:(uint)color
{
    if ((self = [super init]))
    {
        mFill = YES;
        
        mDefaultVertexCoords[2] = width;
        mDefaultVertexCoords[5] = height;
        mDefaultVertexCoords[6] = width;
        mDefaultVertexCoords[7] = height;

        mVertexCoords[2] = mDefaultVertexCoords[2];
        mVertexCoords[5] = mDefaultVertexCoords[5];
        mVertexCoords[6] = mDefaultVertexCoords[6];
        mVertexCoords[7] = mDefaultVertexCoords[7];

		mBorder = NO;
 		mBorderWidth = 1.0f;
		mDefaultBorderVertexCoords[2] = width;
		mDefaultBorderVertexCoords[4] = width;
		mDefaultBorderVertexCoords[5] = height;
		mDefaultBorderVertexCoords[7] = height;
        
		mBorderVertexCoords[2] = mDefaultBorderVertexCoords[2];
		mBorderVertexCoords[4] = mDefaultBorderVertexCoords[4];
		mBorderVertexCoords[5] = mDefaultBorderVertexCoords[5];
		mBorderVertexCoords[7] = mDefaultBorderVertexCoords[7];
        
        self.color = color;
    }
    return self;    
}

- (id)initWithWidth:(float)width height:(float)height
{
    return [self initWithWidth:width height:height color:SP_WHITE];
}

- (id)init
{    
    return [self initWithWidth:32 height:32];
}

- (SPRectangle*)boundsInSpace:(SPDisplayObject*)targetCoordinateSpace
{
    if (targetCoordinateSpace == self) // optimization
        return [SPRectangle rectangleWithX:0 y:0 width:mVertexCoords[6] height:mVertexCoords[7]];
    
    SPMatrix *transformationMatrix = [self transformationMatrixToSpace:targetCoordinateSpace];
    SPPoint *point = [[SPPoint alloc] init];
    
    float minX = FLT_MAX, maxX = -FLT_MAX, minY = FLT_MAX, maxY = -FLT_MAX;
    for (int i=0; i<4; ++i)
    {
        point.x = mVertexCoords[2*i];
        point.y = mVertexCoords[2*i+1];
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

- (void)setColor:(uint)color ofVertex:(int)vertexID
{
    if (vertexID < 0 || vertexID > 3)
        [NSException raise:SP_EXC_INDEX_OUT_OF_BOUNDS format:@"invalid vertex id"];
    
    mVertexColors[vertexID] = color;
}

- (void)setBorderColor:(uint)borderColor ofVertex:(int)vertexID
{
    if (vertexID < 0 || vertexID > 3)
        [NSException raise:SP_EXC_INDEX_OUT_OF_BOUNDS format:@"invalid vertex id"];
    
    mBorderVertexColors[vertexID] = borderColor;
}

- (uint)colorOfVertex:(int)vertexID
{
    if (vertexID < 0 || vertexID > 3)
        [NSException raise:SP_EXC_INDEX_OUT_OF_BOUNDS format:@"invalid vertex id"];
    
    return mVertexColors[vertexID];    
}

- (uint)colorOfBorderVertex:(int)vertexID
{
    if (vertexID < 0 || vertexID > 3)
        [NSException raise:SP_EXC_INDEX_OUT_OF_BOUNDS format:@"invalid vertex id"];
    
    return mBorderVertexColors[vertexID];
}

- (void)setColor:(uint)color
{
    for (int i=0; i<4; ++i) {
		[self setColor:color ofVertex:i];
		mVertexAlpha[i] = 1.0f;
	}
}

- (void)setBorderColor:(uint)borderColor
{
    for (int i=0; i<4; ++i) {
		[self setBorderColor:borderColor ofVertex:i];
		mBorderVertexAlpha[i] = 1.0f;
	}
}

- (uint)color
{
    return [self colorOfVertex:0];
}

- (uint)borderColor
{
    return [self colorOfBorderVertex:0];
}

- (void)setScew:(float *)matrix
{
	[self setScewX1:matrix[0]];
	[self setScewY1:matrix[1]];
	[self setScewX2:matrix[2]];
	[self setScewY2:matrix[3]];
}

- (float *)scew
{
	return (float[4]){mScewX1, mScewY1, mScewX2, mScewY2};
}

- (void)setScewX1:(float)scewX1
{
	if (scewX1 != mScewX1)
	{
		mScewX1 = scewX1;
        
		mVertexCoords[0] = mDefaultVertexCoords[0] + mScewX1;
		mVertexCoords[2] = mDefaultVertexCoords[2] + mScewX1;
		mBorderVertexCoords[0] = mDefaultBorderVertexCoords[0] + mScewX1;
		mBorderVertexCoords[2] = mDefaultBorderVertexCoords[2] + mScewX1;
	}
}

- (void)setScewX2:(float)scewX2
{
	if (scewX2 != mScewX2)
	{
		mScewX2 = scewX2;
        
		mVertexCoords[4] = mDefaultVertexCoords[4] + mScewX2;
		mVertexCoords[6] = mDefaultVertexCoords[6] + mScewX2;
		mBorderVertexCoords[4] = mDefaultBorderVertexCoords[4] + mScewX2;
		mBorderVertexCoords[6] = mDefaultBorderVertexCoords[6] + mScewX2;
	}
}

- (void)setScewY1:(float)scewY1
{
	if (scewY1 != mScewY1)
	{
		mScewY1 = scewY1;
        
		mVertexCoords[1] = mDefaultVertexCoords[1] + mScewY1;
		mVertexCoords[5] = mDefaultVertexCoords[5] + mScewY1;
		mBorderVertexCoords[1] = mDefaultBorderVertexCoords[1] + mScewY1;
		mBorderVertexCoords[7] = mDefaultBorderVertexCoords[7] + mScewY1;
	}
}

- (void)setScewY2:(float)scewY2
{
	if (scewY2 != mScewY2)
	{
		mScewY2 = scewY2;
        
		mVertexCoords[3] = mDefaultVertexCoords[3] + mScewY2;
		mVertexCoords[7] = mDefaultVertexCoords[7] + mScewY2;
		mBorderVertexCoords[3] = mDefaultBorderVertexCoords[3] + mScewY2;
		mBorderVertexCoords[5] = mDefaultBorderVertexCoords[5] + mScewY2;
	}
}

- (void)setGradientStartColor:(uint)startColor endColor:(uint)endColor withStyle:(int)style
{
	[self setGradientStartColor:startColor startAlpha:1.0f endColor:endColor endAlpha:1.0f withStyle:style];
}

- (void)setGradientStartColor:(uint)startColor startAlpha:(float)startAlpha endColor:(uint)endColor withStyle:(int)style
{
	[self setGradientStartColor:startColor startAlpha:startAlpha endColor:endColor endAlpha:1.0f withStyle:style];
}

- (void)setGradientStartColor:(uint)startColor endColor:(uint)endColor endAlpha:(float)endAlpha withStyle:(int)style
{
	[self setGradientStartColor:startColor startAlpha:1.0f endColor:endColor endAlpha:endAlpha withStyle:style];
}

- (void)setGradientStartColor:(uint)startColor startAlpha:(float)startAlpha endColor:(uint)endColor endAlpha:(float)endAlpha withStyle:(int)style
{
	if (startAlpha < 0) startAlpha = 0;
	if (startAlpha > 1.0f) startAlpha = 1.0f;
	if (endAlpha < 0) endAlpha = 0;
	if (endAlpha > 1.0f) endAlpha = 1.0f;
    
	if (style == SPGradientVertical) {
		mVertexColors[0] = startColor;
		mVertexAlpha[0] = startAlpha;
		mVertexColors[1] = startColor;
		mVertexAlpha[1] = startAlpha;
		mVertexColors[2] = endColor;
		mVertexAlpha[2] = endAlpha;
		mVertexColors[3] = endColor;
		mVertexAlpha[3] = endAlpha;
	} else if (style == SPGradientHorizontal) {
		mVertexColors[0] = startColor;
		mVertexAlpha[0] = startAlpha;
		mVertexColors[1] = endColor;
		mVertexAlpha[1] = endAlpha;
		mVertexColors[2] = startColor;
		mVertexAlpha[2] = startAlpha;
		mVertexColors[3] = endColor;
		mVertexAlpha[3] = endAlpha;
	}
}

- (void)setBorderGradientStartColor:(uint)startColor endColor:(uint)endColor withStyle:(int)style
{
	[self setBorderGradientStartColor:startColor startAlpha:1.0f endColor:endColor endAlpha:1.0f withStyle:style];
}

- (void)setBorderGradientStartColor:(uint)startColor startAlpha:(float)startAlpha endColor:(uint)endColor withStyle:(int)style
{
	[self setBorderGradientStartColor:startColor startAlpha:startAlpha endColor:endColor endAlpha:1.0f withStyle:style];
}

- (void)setBorderGradientStartColor:(uint)startColor endColor:(uint)endColor endAlpha:(float)endAlpha withStyle:(int)style
{
	[self setBorderGradientStartColor:startColor startAlpha:1.0f endColor:endColor endAlpha:endAlpha withStyle:style];
}

- (void)setBorderGradientStartColor:(uint)startColor startAlpha:(float)startAlpha endColor:(uint)endColor endAlpha:(float)endAlpha withStyle:(int)style
{
	if (startAlpha < 0) startAlpha = 0;
	if (startAlpha > 1.0f) startAlpha = 1.0f;
	if (endAlpha < 0) endAlpha = 0;
	if (endAlpha > 1.0f) endAlpha = 1.0f;
    
	if (style == SPGradientVertical) {
		mBorderVertexColors[0] = startColor;
		mBorderVertexAlpha[0] = startAlpha;
		mBorderVertexColors[1] = startColor;
		mBorderVertexAlpha[1] = startAlpha;
		mBorderVertexColors[2] = endColor;
		mBorderVertexAlpha[2] = endAlpha;
		mBorderVertexColors[3] = endColor;
		mBorderVertexAlpha[3] = endAlpha;
	} else if (style == SPGradientHorizontal) {
		mBorderVertexColors[0] = startColor;
		mBorderVertexAlpha[0] = startAlpha;
		mBorderVertexColors[1] = endColor;
		mBorderVertexAlpha[1] = endAlpha;
		mBorderVertexColors[2] = endColor;
		mBorderVertexAlpha[2] = endAlpha;
		mBorderVertexColors[3] = startColor;
		mBorderVertexAlpha[3] = startAlpha;
	}
}

+ (SPQuad*)quadWithWidth:(float)width height:(float)height
{
    return [[[SPQuad alloc] initWithWidth:width height:height] autorelease];
}

+ (SPQuad*)quadWithWidth:(float)width height:(float)height color:(uint)color
{
    return [[[SPQuad alloc] initWithWidth:width height:height color:color] autorelease];
}

@end
