//
//  TiltShiftFilterVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "TiltShiftFilterVC.h"


/*
 js version see http://www.noeltock.com/tilt-shift-css3-jquery-plugin/
 
 oc version see http://blog.caffeine.lu/creating-a-tilt-shift-effect-with-coreimage.html

 */


@import CoreImage;

@interface TiltShiftFilterVC ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@end

/*
 To create a tilt-shift filter :

 Create a blurred version of the image.
 Create two linear gradients.
 Create a mask by compositing the linear gradients.
 Composite the blurred image, the mask, and the original image.
 The sections that follow show how to perform each step.
 */

/*
 
 CILinearGradient:
 
 "CIAttributeFilterAvailable_Mac" = "10.4";
 "CIAttributeFilterAvailable_iOS" = 5;
 CIAttributeFilterCategories =     (
 CICategoryGradient,
 CICategoryVideo,
 CICategoryStillImage,
 CICategoryBuiltIn
 );
 CIAttributeFilterDisplayName = "Linear Gradient";
 CIAttributeFilterName = CILinearGradient;
 CIAttributeReferenceDocumentation = "http://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CILinearGradient";
 inputColor0 =     {
 CIAttributeClass = CIColor;
 CIAttributeDefault = "(1 1 1 1)";
 CIAttributeDescription = "The first color to use in the gradient.";
 CIAttributeDisplayName = "Color 1";
 CIAttributeType = CIAttributeTypeColor;
 };
 inputColor1 =     {
 CIAttributeClass = CIColor;
 CIAttributeDefault = "(0 0 0 1)";
 CIAttributeDescription = "The second color to use in the gradient.";
 CIAttributeDisplayName = "Color 2";
 CIAttributeType = CIAttributeTypeColor;
 };
 inputPoint0 =     {
 CIAttributeClass = CIVector;
 CIAttributeDefault = "[0 0]";
 CIAttributeDescription = "The starting position of the gradient -- where the first color begins.";
 CIAttributeDisplayName = "Point 1";
 CIAttributeType = CIAttributeTypePosition;
 };
 inputPoint1 =     {
 CIAttributeClass = CIVector;
 CIAttributeDefault = "[200 200]";
 CIAttributeDescription = "The ending position of the gradient -- where the second color begins.";
 CIAttributeDisplayName = "Point 2";
 CIAttributeType = CIAttributeTypePosition;
 };
 */

@implementation TiltShiftFilterVC
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

    [self testTiltShiftFilter];
}

-(void)testTiltShiftFilter
{

    CGFloat imageH = self.centerImageView.image.size.height;
    //1. 创建一张模糊图片

    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:self.inputImage forKey:kCIInputImageKey];
    CIFilter *bluredImage = [blurFilter valueForKey:kCIOutputImageKey];

    //2. 创建两个线性的渐变
    CIFilter *upLinearGradient = [CIFilter filterWithName:@"CILinearGradient"];
    [upLinearGradient setValue:[CIColor colorWithRed:0 green:1 blue:0 alpha:1] forKey:@"inputColor0"];//渐变开始颜色
    [upLinearGradient setValue:[CIColor colorWithRed:0 green:1 blue:0 alpha:0] forKey:@"inputColor1"];//渐变结束颜色
    [upLinearGradient setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.75*imageH)] forKey:@"inputPoint0"]; //渐变开始位置
    [upLinearGradient setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.5*imageH)] forKey:@"inputPoint1"];  //渐变结束位置

    CIFilter *downLinearGradient = [CIFilter filterWithName:@"CILinearGradient"];
    [downLinearGradient setValue:[CIColor colorWithRed:0 green:1 blue:0 alpha:1] forKey:@"inputColor0"];
    [downLinearGradient setValue:[CIColor colorWithRed:0 green:1 blue:0 alpha:0] forKey:@"inputColor1"];
    [downLinearGradient setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.25*imageH)] forKey:@"inputPoint0"];
    [downLinearGradient setValue:[CIVector vectorWithCGPoint:CGPointMake(0, 0.5*imageH)] forKey:@"inputPoint1"];


    //3. 将两个线性的合成一个图
    CIFilter *addfilter = [CIFilter filterWithName:@"CIAdditionCompositing"];
    [addfilter setValue:upLinearGradient.outputImage forKey:kCIInputImageKey];
    [addfilter setValue:downLinearGradient.outputImage forKey:kCIInputBackgroundImageKey];


    //4. 最后合成: mask + 渐变(前景图) + 原图(背景图)   (相当于有三个图层)
    CIFilter * maskFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [maskFilter setValue:bluredImage forKey:kCIInputImageKey];
    [maskFilter setValue:self.inputImage forKey:kCIInputBackgroundImageKey];
    [maskFilter setValue:addfilter.outputImage forKey:kCIInputMaskImageKey];

    //5.渲染图片输出
    CIImage *result = maskFilter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:self.inputImage.extent];
    self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}
@end
