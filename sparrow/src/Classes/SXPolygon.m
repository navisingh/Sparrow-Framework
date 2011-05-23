//
//  ExPolygon.m
//  Sparrow
//
//  Created by Navi Singh on 3/22/11.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

/*
 Primitive Flag 	Description
 GL_POINTS 	        A point is placed at each vertex.
 GL_LINES 	        A line is drawn for every pair of vertices that are given.
 GL_LINE_STRIP 	    A continuous set of lines are drawn. After the first vertex, a line is drawn between every 
                    successive vertex     and the vertex before it.
 GL_LINE_LOOP    	This is the same as GL_LINE_STRIP except that the start and end vertices are connected as well.
 GL_TRIANGLES 	    For every triplet of vertices, a triangle is drawn with corners specified by the coordinates of
                    the vertices.
 GL_TRIANGLE_STRIP 	After the first 2 vertices, every successive vertex uses the previous 2 vertices to draw a triangle.
 GL_TRIANGLE_FAN 	After the first 2 vertices, every successive vertex uses the previous vertex and the first vertex to
                    draw a triangle. This is used to draw cone-like shapes.
 
 */

#import "SXPolygon.h"
#import "SPMacros.h"
#import "SPRenderSupport.h"

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation SXPolygon

@synthesize fill = mFill;
@synthesize innerColor = mInnerColor;
@synthesize outerColor = mOuterColor;
@synthesize border = mBorder;
@synthesize borderColor = mBorderColor;
@synthesize borderWidth = mBorderWidth;
@synthesize vertices;

- (float *)vertices{
    return mVertexCoords;
}

- (id)init {
	return [self initWithWidth:32 height:32];
}

- (id)initWithWidth:(float)width height:(float)height {
	if ((self = [super init])) {
		mWidth = width;
		mHeight = height;
        
 		mSides = 3;
        int size = mSides * sizeof(CGPoint);
        free(mVertexCoords);
        mVertexCoords = malloc(size);
        free(mBorderVertexCoords);
        mBorderVertexCoords = malloc(size);

        mVertexCoords[0] = mBorderVertexCoords[0] = 0;
        mVertexCoords[1] = mBorderVertexCoords[1] = 0;
        
        mVertexCoords[2] = mBorderVertexCoords[2] = mWidth;
        mVertexCoords[3] = mBorderVertexCoords[3] = 0;

        mVertexCoords[4] = mBorderVertexCoords[4] = 0;
        mVertexCoords[5] = mBorderVertexCoords[5] = mHeight;
        
		mFill = YES;
		self.color = SP_WHITE;
		mBorder = NO;
		mBorderColor = SP_WHITE;
		mBorderWidth = 1.0f;

    }
    return self;
}
- (void)dealloc
{
    free(mVertexCoords);
    free(mBorderVertexCoords);
    [super dealloc];
}

+ (SXPolygon *)polygon {
	return [[[SXPolygon alloc] initWithWidth:32 height:32] autorelease];
}

+ (SXPolygon *)polygonWithWidth:(float)width height:(float)height {
	return [[[SXPolygon alloc] initWithWidth:width height:height] autorelease];
}

- (void)setVertices:(CGPoint [])v count:(int)count fillMode:(int)fillMode
{
    switch (fillMode) {
        case GL_TRIANGLES:
        case GL_TRIANGLE_STRIP:
        case GL_TRIANGLE_FAN:
            mFillMode = fillMode;
            break;
            
        default:
            mFillMode = GL_TRIANGLE_FAN;
            break;
    }
    
    int size = count * sizeof(CGPoint);
    free(mVertexCoords);
    mVertexCoords = malloc(size);
    free(mBorderVertexCoords);
    mBorderVertexCoords = malloc(size);
    
    for(int n=0; n < count; ++n)
    {
        mVertexCoords[n*2] = mBorderVertexCoords[n*2] = v[n].x;
        mVertexCoords[n*2+1] = mBorderVertexCoords[n*2+1] = v[n].y;
    }
    mSides = count;
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
	if (!mFill) return;
	uint colors[mSides+2];
	
	for (int i=0; i<mSides+2; i++) {
		if (i==0) colors[i] = [support convertColor:mInnerColor alpha:alpha];
		else colors[i] = [support convertColor:mOuterColor alpha:alpha];
	}
	
	glVertexPointer(2, GL_FLOAT, 0, mVertexCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glDrawArrays(mFillMode, 0, mSides+2);
}

- (void)renderBorder:(SPRenderSupport *)support alpha:(float)alpha {
	if (!mBorder) return;
	uint colors[mSides+2];
	
	for (int i=0; i<mSides+2; i++) colors[i] = [support convertColor:mBorderColor alpha:alpha];
	
	glVertexPointer(2, GL_FLOAT, 0, mBorderVertexCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glLineWidth(mBorderWidth);
	glDrawArrays(GL_LINE_LOOP, 0, mSides+2);
}

- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetCoordinateSpace {
	if (targetCoordinateSpace == self)
        return [SPRectangle rectangleWithX:0 y:0 width:mWidth height:mHeight];
    
    SPMatrix *transformationMatrix = [self transformationMatrixToSpace:targetCoordinateSpace];
    SPPoint *point = [[SPPoint alloc] init];
    
	float tempVertexCoords[8]={0};
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

- (void)setWidth:(float)width {
	mWidth = width;
	[super setWidth:mWidth];
}

- (void)setHeight:(float)height {
	mHeight = height;
	[super setHeight:mHeight];
}

- (void)setColor:(uint)color {
	mInnerColor = mOuterColor = color;
}

- (uint)color {
	return mInnerColor;
}

@end
