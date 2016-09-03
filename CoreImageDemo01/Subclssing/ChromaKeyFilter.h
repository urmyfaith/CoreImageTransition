//
//  ChromaKeyFilter.h
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface ChromaKeyFilter : CIFilter
@property (nonatomic, strong) CIImage * inputImage;
@end
