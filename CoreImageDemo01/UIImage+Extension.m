//
//  UIImage+Extension.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
-(NSInteger )getCGImagePropertyOrientation
{
    NSInteger exifOrientation = 1;
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    return exifOrientation;
}
@end
