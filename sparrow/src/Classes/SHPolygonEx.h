//
//  SHPolygon.h
//  Sparrow
//
//  Created by Shilo White on 2/6/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPDisplayObject.h"
#import "CoreGraphics/CGGeometry.h"

@class SPRenderSupport;

@interface SHPolygonEx : SPDisplayObject {
@protected
	float mVertexCoords[724];
	float mBorderVertexCoords[724];
	float mWidth;
	float mHeight;
	int mSides;
	BOOL mFill;
	uint mInnerColor;
	uint mOuterColor;
	BOOL mBorder;
    uint mBorderColor;
	float mBorderWidth;
}

@property (nonatomic, assign) BOOL fill;
@property (nonatomic, assign) uint color;
@property (nonatomic, assign) uint innerColor;
@property (nonatomic, assign) uint outerColor;
@property (nonatomic, assign) BOOL border;
@property (nonatomic, assign) uint borderColor;
@property (nonatomic, assign) float borderWidth;

- (id)initWithWidth:(float)width height:(float)height;
+ (SHPolygonEx *)polygon;
+ (SHPolygonEx *)polygonWithWidth:(float)width height:(float)height;
- (void)setVertices:(CGPoint [])vertices count:(int)count;
- (void)renderFill:(SPRenderSupport *)support alpha:(float)alpha;
- (void)renderBorder:(SPRenderSupport *)support alpha:(float)alpha;

@end
