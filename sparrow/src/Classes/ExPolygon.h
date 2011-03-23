//
//  ExPolygon.h
//  Sparrow
//
//  Created by Navi Singh on 3/22/11.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPDisplayObject.h"
#import "CoreGraphics/CGGeometry.h"

@class SPRenderSupport;

@interface ExPolygon : SPDisplayObject {
@protected
    float *mVertexCoords;
    float *mBorderVertexCoords;
	float mWidth;
	float mHeight;
	int mSides;
	BOOL mFill;
	uint mInnerColor;
	uint mOuterColor;
	BOOL mBorder;
    uint mBorderColor;
	float mBorderWidth;
    int   mFillMode;
}

@property (nonatomic, assign) BOOL fill;
@property (nonatomic, assign) uint color;
@property (nonatomic, assign) uint innerColor;
@property (nonatomic, assign) uint outerColor;
@property (nonatomic, assign) BOOL border;
@property (nonatomic, assign) uint borderColor;
@property (nonatomic, assign) float borderWidth;

- (id)initWithWidth:(float)width height:(float)height;
+ (ExPolygon *)polygon;
+ (ExPolygon *)polygonWithWidth:(float)width height:(float)height;
//fillMode = GL_TRIANGLES | GL_TRIANGLE_STRIP | GL_TRIANGLE_FAN
- (void)setVertices:(CGPoint [])vertices count:(int)count fillMode:(int)fillMode;
- (void)renderFill:(SPRenderSupport *)support alpha:(float)alpha;
- (void)renderBorder:(SPRenderSupport *)support alpha:(float)alpha;

@end
