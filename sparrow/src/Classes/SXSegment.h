//
//  SXSegment.h
//  Sparrow
//
//  Created by Navi Singh on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPoint.h"

@interface SegmentIntersectionResult : NSObject {
    
    int resultValue;
    SPPoint* i1;
    SPPoint* i2;
}

@property (nonatomic, retain) SPPoint* i1;
@property (nonatomic, retain) SPPoint* i2;
@property int resultValue;

@end

@interface Segment : NSObject {
    
    SPPoint* p1;
    SPPoint* p2;
}

@property (nonatomic, retain) SPPoint* p1;
@property (nonatomic, retain) SPPoint* p2;

+ (id) segmentWithP1: (SPPoint*) p1 p2: (SPPoint*) p2;

+ (SegmentIntersectionResult*) intersectSegmentsWithSegment: (Segment*) s1 s2: (Segment*) s2;
+ (BOOL) inSegmentWithPoint: (SPPoint*) p s: (Segment*) s;

@end

