//
//  SHLine.h
//  Sparrow
//
//  Created by Shilo White on 1/11/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SHLine.h"
#import "SPMacros.h"

@implementation SHLine

@synthesize thickness = mThickness;
@dynamic angle;
@dynamic slope;

-(float) slope
{
    float deltaY = mVertexCoords[3] - mVertexCoords[1];
    float deltaX = mVertexCoords[2] - mVertexCoords[0];
    if (deltaX) 
        return deltaY / deltaX;
    
    return MAXFLOAT;
}

-(float) angle
{
    float deltaY = mVertexCoords[3] - mVertexCoords[1];
    float deltaX = mVertexCoords[2] - mVertexCoords[0];
    float radians = atan2f(deltaY, deltaX);
    
    return SP_R2D(radians);
}

- (SHLine *)init {
	return [self initWithCoords:0:0:50.0f:0 andThickness:1.0f];
}

- (SHLine *)initWithLength:(float)length {
	return [self initWithCoords:0:0:length:0 andThickness:1.0f];
}

- (SHLine *)initWithLength:(float)length Angle:(float)degrees{
	return [self initWithVertex:0:0 Length:length Angle:degrees andThickness:1.0f];
}

- (SHLine *)initWithLength:(float)length Angle:(float)degrees andThickness:(float)thickness{
	return [self initWithVertex:0:0 Length:length Angle:degrees andThickness:1.0f];
}

- (SHLine *)initWithVertex:(float)x1 :(float)y1 Length:(float)length Angle:(float)degrees{
	return [self initWithVertex:x1:y1 Length:length Angle:degrees andThickness:1.0f];
}

- (SHLine *)initWithVertex:(float)x1 :(float)y1 Length:(float)length andThickness:(float)thickness {
	return [self initWithVertex:x1:y1 Length:length Angle:0 andThickness:thickness];
}

- (SHLine *)initWithVertex:(float)x1 :(float)y1 Length:(float)length Angle:(float)degrees andThickness:(float)thickness {
    float radians = SP_D2R(degrees);
    float x2 = length * cosf(radians) + x1;
    float y2 = -length * sinf(radians) + y1;
    
	return [self initWithCoords:x1:y1:x2:y2 andThickness:thickness];
}

- (SHLine *)initWithCoords:(float)x1 :(float)y1 :(float)x2 :(float)y2 {
	return [self initWithCoords:x1:y1:x2:y2 andThickness:1.0f];
}

- (SHLine *)initWithCoords:(float)x1 :(float)y1 :(float)x2 :(float)y2 andThickness:(float)thickness {
	if ((self = [super init])) {
		self.x = x1;
		self.y = y1;
		self.color = 0xffffff;
        mVertexCoords[0] = 0;
        mVertexCoords[1] = 0;
		mVertexCoords[2] = x2-x1; //changed: used to be x2.
		mVertexCoords[3] = y2-y1; //changed: used to be y2.
		mVertexAlpha[0] = 1.0f;
		mVertexAlpha[1] = 1.0f;
		mThickness = thickness;
	}
	return self;
}

+ (SHLine *)lineWithLength:(float)length Angle:(float)degrees{
	return [[[SHLine alloc] initWithLength:length Angle:degrees andThickness:1.0f] autorelease];
}

+ (SHLine *)lineWithLength:(float)length Angle:(float)degrees andThickness:(float)thickness {
	return [[[SHLine alloc] initWithLength:length Angle:degrees andThickness:thickness] autorelease];
}

+ (SHLine *)lineWithVertex:(float)x1 :(float)y1 Length:(float)length{
	return [[[SHLine alloc] initWithVertex: x1:y1 Length:length Angle:0 andThickness:1.0f] autorelease];
}

+ (SHLine *)lineWithVertex:(float)x1 :(float)y1 Length:(float)length Angle:(float)degrees{
	return [[[SHLine alloc] initWithVertex: x1:y1 Length:length Angle:degrees andThickness:1.0f] autorelease];
}

+ (SHLine *)lineWithVertex:(float)x1 :(float)y1 Length:(float)length andThickness:(float)thickness {
	return [[[SHLine alloc] initWithVertex: x1:y1 Length:length Angle:0 andThickness:thickness] autorelease];
}

+ (SHLine *)lineWithVertex:(float)x1 :(float)y1 Length:(float)length Angle:(float)degrees andThickness:(float)thickness {
	return [[[SHLine alloc] initWithVertex: x1:y1 Length:length Angle:degrees andThickness:thickness] autorelease];
}

+ (SHLine *)lineWithVertices:(float)x1 :(float)y1 :(float)x2 :(float)y2 {
	return [[[SHLine alloc] initWithCoords:x1:y1:x2:y2] autorelease];
}

+ (SHLine *)lineWithVertices:(float)x1 :(float)y1 :(float)x2 :(float)y2 andThickness:(float)thickness {
	return [[[SHLine alloc] initWithCoords:x1:y1:x2:y2 andThickness:thickness] autorelease];
}

+ (SHLine *)lineWithCoords:(float)x1 :(float)y1 :(float)x2 :(float)y2 {
	return [[[SHLine alloc] initWithCoords:x1:y1:x2:y2] autorelease];
}

+ (SHLine *)lineWithCoords:(float)x1 :(float)y1 :(float)x2 :(float)y2 andThickness:(float)thickness {
	return [[[SHLine alloc] initWithCoords:x1:y1:x2:y2 andThickness:thickness] autorelease];
}

- (void)render:(SPRenderSupport *)support {
    uint colors[2];
    float alpha = self.alpha;
    
    [support bindTexture:nil];
    
	for (int i=0; i<2; i++) 
        colors[i] = [support convertColor:mVertexColors[i] alpha:mVertexAlpha[i]*alpha];
	
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);    
    
	glVertexPointer(2, GL_FLOAT, 0, mVertexCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glLineWidth(mThickness);
	glDrawArrays(GL_LINES, 0, 2);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
}

- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetCoordinateSpace
{
    if (targetCoordinateSpace == self)
        return [SPRectangle rectangleWithX:0 y:0 width:mVertexCoords[2] height:mVertexCoords[3]];
    
    SPMatrix *transformationMatrix = [self transformationMatrixToSpace:targetCoordinateSpace];
    SPPoint *point = [[SPPoint alloc] init];
    
    float minX = FLT_MAX, maxX = -FLT_MAX, minY = FLT_MAX, maxY = -FLT_MAX;
    for (int i=0; i<2; i++) {
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

- (void)setX2:(float)x2 {
	mVertexCoords[2] = x2;
}

- (void)setY2:(float)y2 {
	mVertexCoords[3] = y2;
}

- (void)setColor:(uint)color {
    for (int i=0; i<2; i++) {
		mVertexColors[i] = color;
	}
}

- (void)setStartColor:(uint)color {
	mVertexColors[0] = color;
}

- (void)setEndColor:(uint)color {
	mVertexColors[1] = color;
}

- (void)setStartAlpha:(float)alpha {
	if (alpha < 0) alpha = 0;
	if (alpha > 1.0f) alpha = 1.0f;
	
	mVertexAlpha[0] = alpha;
}

- (void)setEndAlpha:(float)alpha {
	if (alpha < 0) alpha = 0;
	if (alpha > 1.0f) alpha = 1.0f;
	
	mVertexAlpha[1] = alpha;
}

- (float)x2 {
	return mVertexCoords[2];
}

- (float)y2 {
	return mVertexCoords[3];
}

- (uint)color {
	return mVertexColors[0];
}

- (uint)startColor {
	return mVertexColors[0];
}

- (uint)endColor {
	return mVertexColors[1];
}

- (float)startAlpha {
	return mVertexAlpha[0];
}

- (float)endAlpha {
	return mVertexAlpha[1];
}
@end
