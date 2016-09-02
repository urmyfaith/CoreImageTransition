//
//  CIFaceFeature+Extension.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "CIFaceFeature+Extension.h"

@import UIKit;

@implementation CIFaceFeature (Extension)
/*
 @property (readonly, assign) CGRect bounds;
 @property (readonly, assign) BOOL hasLeftEyePosition;
 @property (readonly, assign) CGPoint leftEyePosition;
 @property (readonly, assign) BOOL hasRightEyePosition;
 @property (readonly, assign) CGPoint rightEyePosition;
 @property (readonly, assign) BOOL hasMouthPosition;
 @property (readonly, assign) CGPoint cc;

 @property (readonly, assign) BOOL hasTrackingID;
 @property (readonly, assign) int trackingID;
 @property (readonly, assign) BOOL hasTrackingFrameCount;
 @property (readonly, assign) int trackingFrameCount;

 @property (readonly, assign) BOOL hasFaceAngle;
 @property (readonly, assign) float faceAngle;

 @property (readonly, assign) BOOL hasSmile;
 @property (readonly, assign) BOOL leftEyeClosed;
 @property (readonly, assign) BOOL rightEyeClosed;

 */
-(NSString *)description
{
    NSMutableString *str =[NSMutableString string];

    [str appendString: [NSString stringWithFormat:@"\nbounds\t\t%@\n", NSStringFromCGRect(self.bounds)]];

    if (self.hasLeftEyePosition) {
        [str appendString:[NSString stringWithFormat:@"leftEyePosition\t\t%@\n",NSStringFromCGPoint(self.leftEyePosition)]];
    }

    if (self.hasRightEyePosition) {
        [str appendString:[NSString stringWithFormat:@"rightEyePosition\t\t%@\n",NSStringFromCGPoint(self.rightEyePosition)]];
    }

    if (self.hasMouthPosition) {
        [str appendString:[NSString stringWithFormat:@"mouthPosition\t\t%@\n",NSStringFromCGPoint(self.mouthPosition)]];
    }

    if (self.hasTrackingID) {
        [str appendString:[NSString stringWithFormat:@"trackingID\t\t%zd\n",self.trackingID]];
    }

    if (self.hasTrackingFrameCount) {
        [str appendString:[NSString stringWithFormat:@"trackingFrameCount\t\t%zd\n",self.trackingFrameCount]];
    }

    if (self.hasFaceAngle) {
        [str appendString:[NSString stringWithFormat:@"faceAngle\t\t%.2f\n",self.faceAngle]];
    }

    [str appendString:[NSString stringWithFormat:@"hasSmile\t\t%@\n",self.hasSmile ? @"YES": @"NO"]];

    [str appendString:[NSString stringWithFormat:@"leftEyeClosed\t\t%@\n",self.leftEyeClosed ? @"YES": @"NO"]];

    [str appendString:[NSString stringWithFormat:@"rightEyeClosed\t\t%@\n\n",self.rightEyeClosed ? @"YES": @"NO"]];
    return str.copy;
}
@end
