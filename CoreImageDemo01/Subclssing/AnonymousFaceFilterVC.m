//
//  AnonymousFaceFilterVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "AnonymousFaceFilterVC.h"


/*

 CIPixellate:


 (lldb) po pixellateFilter.attributes
 {
 "CIAttributeFilterAvailable_Mac" = "10.4";
 "CIAttributeFilterAvailable_iOS" = 6;
 CIAttributeFilterCategories =     (
 CICategoryStylize,
 CICategoryVideo,
 CICategoryStillImage,
 CICategoryBuiltIn
 );
 CIAttributeFilterDisplayName = Pixelate;
 CIAttributeFilterName = CIPixellate;
 CIAttributeReferenceDocumentation = "http://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIPixellate";
 inputCenter =     {
 CIAttributeClass = CIVector;
 CIAttributeDefault = "[150 150]";
 CIAttributeDescription = "The x and y position to use as the center of the effect";
 CIAttributeDisplayName = Center;
 CIAttributeType = CIAttributeTypePosition;
 };
 inputImage =     {
 CIAttributeClass = CIImage;
 CIAttributeDescription = "The image to use as an input image. For filters that also use a background image, this is the foreground image.";
 CIAttributeDisplayName = Image;
 CIAttributeType = CIAttributeTypeImage;
 };
 inputScale =     {
 CIAttributeClass = NSNumber;
 CIAttributeDefault = 8;
 CIAttributeDescription = "The scale determines the size of the squares. Larger values result in larger squares.";
 CIAttributeDisplayName = Scale;
 CIAttributeMin = 1;
 CIAttributeSliderMax = 100;
 CIAttributeSliderMin = 1;
 CIAttributeType = CIAttributeTypeDistance;
 };
 }
 */

@import CoreImage;

@interface AnonymousFaceFilterVC ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@end

@implementation AnonymousFaceFilterVC
-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, 256, 192)];
    self.resultIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 256, 192)];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.resultIamgeView];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IMG_20140503_131215" ofType:@"jpg"];

    if (filePath.length > 0 ) {
        NSURL *fillURL = [NSURL fileURLWithPath:filePath];
        self.inputImage = [CIImage imageWithContentsOfURL:fillURL];
        self.centerImageView.image = [UIImage imageWithCIImage:self.inputImage];
    }

    [self testAnonymousFaceFilter];
}

// mask + 像素化图 + 原图
-(void)testAnonymousFaceFilter
{
    CGFloat imageW = self.centerImageView.image.size.width;
    CGFloat imageH = self.centerImageView.image.size.height;

    //1. 像素化原图
    CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setValue:self.inputImage forKey:kCIInputImageKey];
    [pixellateFilter setValue:@(MAX(imageH, imageW)/60) forKey:kCIInputScaleKey];

    //2. 人脸检测,生成蒙版
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:@{
                                                        CIDetectorAccuracy: CIDetectorAccuracyHigh,
                                                        }];
    NSArray *features = [detector featuresInImage:self.inputImage
                                          options:@{
                                                    CIDetectorImageOrientation: @1,
                                                    }];
    CIImage *maskImage = nil;
    for (CIFeature *f in features) {
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
        CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5;
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" withInputParameters:@{
                                                                                                      @"inputRadius0": @(radius),
                                                                                                      @"inputRadius1": @(radius + 1.0f),
                                                                                                      @"inputColor0": [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                                                                                      @"inputColor1": [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                                                                                      kCIInputCenterKey: [CIVector vectorWithX:centerX Y:centerY],
                                                                                                      }];
        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
        if (nil == maskImage)
            maskImage = circleImage;
        else
            maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" withInputParameters:@{
                                                                                                   kCIInputImageKey: circleImage,
                                                                                                   kCIInputBackgroundImageKey: maskImage,
                                                                                                   }] valueForKey:kCIOutputImageKey];
    }

    //3.合成
    CIFilter *maskFilter = [CIFilter filterWithName:@"CIBlendWithMask" withInputParameters:@{
                                                                                             kCIInputImageKey: pixellateFilter.outputImage,
                                                                                             kCIInputBackgroundImageKey: self.inputImage,
                                                                                             kCIInputMaskImageKey: maskImage
                                                                                         }];
    //4. 绘制后输出
    CIImage *result = maskFilter.outputImage;
    CGImageRef cgImage = [context createCGImage:result fromRect:self.inputImage.extent];
    self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}
@end
