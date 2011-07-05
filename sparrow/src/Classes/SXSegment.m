//
//  SXSegment.m
//  Sparrow
//
//  Created by Navi Singh on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SXSegment.h"

#define SMALL_NUM  0.00000001
/*
@implementation SegmentIntersectionResult

@synthesize i1, i2, resultValue;

@end

@implementation Segment

@synthesize p1, p2;

+ (id) segmentWithP1: (SPPoint*) p1 p2: (SPPoint*) p2 {
    
    Segment* seg = [[[Segment alloc] init] autorelease];
    seg.p1 = p1;
    seg.p2 = p2;
    return seg;
}

+ (SegmentIntersectionResult*) intersectSegmentsWithSegment: (Segment*) s1 s2: (Segment*) s2 {
    SegmentIntersectionResult* result = [[[SegmentIntersectionResult alloc] init] autorelease];
    SPPoint*  u = [s1.p2 subtractPoint: s1.p1];
    SPPoint*  v = [s2.p2 subtractPoint: s2.p1];
    SPPoint*  w = [s1.p1 subtractPoint: s2.p1];
    float     D = [u perpPoint:v];
    float     puw = [u perpPoint:w];
    float     pvw = [v perpPoint:w];
    
    if (fabs(D) < SMALL_NUM) {          // s1 and s2 are parallel
        if (puw != 0 || pvw != 0) {
            result.resultValue = 0;  // they are NOT collinear
            return result;
        }
        // they are collinear or degenerate
        // check if they are degenerate points
        float du = [u dot:u];
        float dv = [v dot:v];
        if (du==0 && dv==0) {           // both segments are points
            if (s1.p1 != s2.p1){         // they are distinct points
                result.resultValue =  0;
                return result;
            }
            result.i1 = s1.p1;                // they are the same point
            result.resultValue =  1;
            return result;
        }
        if (du==0) {                    // S1 is a single point
            if (![Segment inSegmentWithPoint: s1.p1 s: s2]){  // but is not in S2
                result.resultValue = 0;
                return result;
            }
            result.i1 = s1.p1;
            result.resultValue = 1;
            return result;
        }
        if (dv==0) {                    // S2 a single point
            if (![Segment inSegmentWithPoint:s2.p1 s: s1]) {  // but is not in S1
                result.resultValue = 0;
                return result;
            }
            result.i1 = s2.p1;
            result.resultValue = 1;
            return result;
        }
        // they are collinear segments - get overlap (or not)
        float t0, t1;                   // endpoints of S1 in eqn for S2
        SPPoint* w2 = [s1.p2 subtractPoint: s2.p1];
        if (v.x != 0) {
            t0 = w.x / v.x;
            t1 = w2.x / v.x;
        }
        else {
            t0 = w.y / v.y;
            t1 = w2.y / v.y;
        }
        if (t0 > t1) {                  // must have t0 smaller than t1
            float t=t0; t0=t1; t1=t;    // swap if not
        }
        if (t0 > 1 || t1 < 0) {
            result.resultValue = 0;
            return result;     // NO overlap
        }
        t0 = t0<0? 0 : t0;              // clip to min 0
        t1 = t1>1? 1 : t1;              // clip to max 1
        if (t0 == t1) {                 // intersect is a point
            result.resultValue = 1;
            result.i1 = [s2.p1 addPoint:[v scaleBy:t0]];
            return result;
        }
        // they overlap in a valid subsegment
        result.resultValue = 2;
        result.i1 = [s2.p1 addPoint:[v scaleBy:t0]];
        result.i2 = [s2.p1 addPoint:[v scaleBy:t1]];
        return result;
    }
    
    // the segments are skew and may intersect in a point
    // get the intersect parameter for S1
    float sI =  [v perpPoint:w] / D;
    if (sI < 0 || sI > 1) {               // no intersect with S1
        result.resultValue = 0;
        return result;
    }
    
    // get the intersect parameter for S2
    float tI = [u perpPoint:w] / D;
    if (tI < 0 || tI > 1){               // no intersect with S2
        result.resultValue = 0;
        return result;
    }
    
    result.resultValue = 1;
    result.i1 = [s1.p1 addPoint:[u scaleBy:sI]];
    return result;
}

//    inSegment(): determine if a point is inside a segment
//    Return: YES when P is inside S
//            NO when P is not inside S
+ (BOOL) inSegmentWithPoint: (SPPoint*) p s: (Segment*) s {
    if (s.p1.x != s.p2.x) {    // S is not vertical
        if (s.p1.x <= p.x && p.x <= s.p2.x)
            return YES;
        if (s.p1.x >= p.x && p.x >= s.p2.x)
            return YES;
    }
    else {    // S is vertical, so test y coordinate
        if (s.p1.y <= p.y && p.y <= s.p2.y)
            return YES;
        if (s.p1.y >= p.y && p.y >= s.p2.y)
            return YES;
    }
    return NO;
}

@end

*/