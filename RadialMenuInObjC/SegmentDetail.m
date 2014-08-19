//
//  SegmentDetail.m
//  RadialMenuInObjC
//
//  Created by RapidValue on 08/08/14.
//  Copyright (c) 2014 RapidValue. All rights reserved.
//

#import "SegmentDetail.h"

@implementation SegmentDetail


@synthesize minValue, maxValue, midValue, value;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.value, self.minValue, self.midValue, self.maxValue];
    
}


@end
