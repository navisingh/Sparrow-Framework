#import "SPDisplayObject+Screenshot.h"
#import "SPStage.h"
#import <OpenGLES/ES1/gl.h>

@implementation SPDisplayObject (Screenshot)

- (UIImage *)screenshot {
	int bufferLength = (self.width*(self.height+30)*4);
	
	int myWidth = self.width;
	int myHeight = self.height;
	int myY = self.stage.height-self.y-self.height;
	int myX = self.x;
	
	unsigned char buffer[bufferLength];
	glReadPixels(myX, myY, myWidth, myHeight, GL_RGBA, GL_UNSIGNED_BYTE, &buffer);
	
	CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, &buffer, bufferLength, NULL);
	CGImageRef iref = CGImageCreate(myWidth,myHeight,8,32,myWidth*4,CGColorSpaceCreateDeviceRGB(),
									kCGBitmapByteOrderDefault,ref,NULL, true, kCGRenderingIntentDefault);
	uint32_t* pixels = (uint32_t *)malloc(bufferLength);
	CGContextRef context = CGBitmapContextCreate(pixels, myWidth, myHeight, 8, myWidth*4, CGImageGetColorSpace(iref),
												 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
	CGContextTranslateCTM(context, 0.0, myHeight);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, myWidth, myHeight), iref);
	CGImageRef outputRef = CGBitmapContextCreateImage(context);
	UIImage *image = [UIImage imageWithCGImage:outputRef];
	free(pixels);
	return image;
}

@end