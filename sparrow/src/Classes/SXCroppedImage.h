#import <Foundation/Foundation.h>
#import "SPImage.h"
#import "CoreGraphics/CGGeometry.h"
@class SPTexture;

@interface SXCroppedImage : SPImage {
@protected
    int mCropX; // these coordinates are in points (320 x 480 for iPhone)
    int mCropY;
    int mCropW;
    int mCropH;
    
    int mCropXPixels;        // However, GL_SCISSOR_TEST needs absolute pixels
    int mCropYPixelsFlipped; // We also flip the y axis so that our offsets are from the top-left corner of the iPhone
    int mCropWPixels;
    int mCropHPixels;
    
    float mScreenHeightPixels;
}

@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) int cropX;
@property (nonatomic, assign) int cropY;
@property (nonatomic, assign) int cropWidth;
@property (nonatomic, assign) int cropHeight;

- (id)initWithTexture:(SPTexture *)texture;
- (id)initWithContentsOfFile:(NSString *)path;
+ (SXCroppedImage *)imageWithTexture:(SPTexture *)texture;
+ (SXCroppedImage *)imageWithContentsOfFile:(NSString *)path;

@end

