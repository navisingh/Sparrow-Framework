#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPDisplayObject.h"

@interface SPDisplayObject (Screenshot)

- (UIImage *)screenshot;

@end

//This is how you take a screenshot
//UIImageWriteToSavedPhotosAlbum([object screenshot], nil, nil, nil);

