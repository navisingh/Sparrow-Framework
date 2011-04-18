//
//  SXCheckbox.h
//  Sparrow
//
//  Created by Navi Singh on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h"
#define SX_CHECKBOX_CHANGED @"SXCheckBox.changed"

@interface SXCheckBox : SPSprite {
    SPImage *uncheckedImage_;
    SPImage *checkedImage_;
    BOOL checked_;
    short offset_;
}
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) short offset;

- (id) initWithTexturesUnchecked:(SPTexture *)unchecked Checked:(SPTexture *)checked;
/// Factory method.
+ (SXCheckBox *)checkboxWithTexturesUnchecked:(SPTexture *)unchecked Checked:(SPTexture *)checked;

@end
