#import "SXCroppedImage.h"
#import "SPRenderSupport.h"
#import "SPTexture.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation SXCroppedImage

@synthesize cropX = mCropX;
@synthesize cropY = mCropY;
@synthesize cropWidth = mCropW;
@synthesize cropHeight = mCropH;

- (id)initWithTexture:(SPTexture *)texture {
	if ((self = [super initWithTexture:texture])) {
		CGSize screenSize = [UIScreen mainScreen].bounds.size;
		mCropX = 0;
		mCropY = 0;
		mCropW = screenSize.width;
		mCropH = screenSize.height;
	}
	return self;
}

- (id)initWithContentsOfFile:(NSString *)path {
	return [self initWithTexture:[SPTexture textureWithContentsOfFile:path]];
}

+ (SXCroppedImage *)imageWithTexture:(SPTexture *)texture {
	return [[[SXCroppedImage alloc] initWithTexture:texture] autorelease];
}

+ (SXCroppedImage *)imageWithContentsOfFile:(NSString *)path {
	return [[[SXCroppedImage alloc] initWithContentsOfFile:path] autorelease];
}

- (void)render:(SPRenderSupport *)support {
	int screenHeight = [UIScreen mainScreen].bounds.size.height;
	glEnable(GL_SCISSOR_TEST);
	glScissor(mCropX, screenHeight-mCropH, mCropW, screenHeight-mCropY);
	[super render:support];
	glDisable(GL_SCISSOR_TEST);
}

- (CGRect)cropRect {
    return CGRectMake(mCropX, mCropY, mCropW, mCropH);
}

- (void)setCropRect:(CGRect)rect {
    mCropX = rect.origin.x;
    mCropY = rect.origin.y;
    mCropW = rect.size.width;
    mCropH = rect.size.height;
}

@end