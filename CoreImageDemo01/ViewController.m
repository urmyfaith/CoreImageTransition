//
//  ViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/1/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *srcImage;
@property (weak, nonatomic) IBOutlet UIImageView *dstImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"no_filter_2x.png"];

    self.srcImage.image = image;

    [self testAddHueFilter];

    [self testChainFilter];
}


-(void)testAddHueFilter
{
    CIContext *context = [CIContext contextWithOptions:nil];                    //1

    CIImage *originImage = [[CIImage alloc]initWithImage:self.srcImage.image];  //2

    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];             //3
    [hueAdjust setValue: originImage forKey: kCIInputImageKey];
    [hueAdjust setValue: @2.094f forKey: kCIInputAngleKey];

    /*
       //获取滤镜的属性星系
     NSDictionary *attributes = hueAdjust.attributes;
     NSURL *docURL = [attributes objectForKey:kCIAttributeReferenceDocumentation];
     */


    CIImage *result = [hueAdjust valueForKey: kCIOutputImageKey];               //4

    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];        //5

    self.dstImage.image = [[UIImage alloc]initWithCGImage:cgImage];
}

-(void)testChainFilter
{
    //1.画布
    CIContext *context = [CIContext contextWithOptions:nil];

    //2.输入,输出
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:self.srcImage.image];
    CIImage *outputResult = nil;


    //3. 滤镜获取,配置,得到滤镜输出
    CIFilter *gloom = [CIFilter filterWithName:@"CIGloom"];

    [gloom setValue: inputCIImage forKey: kCIInputImageKey];
    [gloom setValue: @25.0f forKey: kCIInputRadiusKey];
    [gloom setValue: @0.75f forKey: kCIInputIntensityKey];

    outputResult = [gloom valueForKey: kCIOutputImageKey];


    CIFilter *bumpDistortion = [CIFilter filterWithName:@"CIBumpDistortion"];
    [bumpDistortion setValue: outputResult forKey: kCIInputImageKey];
    [bumpDistortion setValue: [CIVector vectorWithX:200 Y:150]
                      forKey: kCIInputCenterKey];
    [bumpDistortion setValue: @100.0f forKey: kCIInputRadiusKey];
    [bumpDistortion setValue: @3.0f forKey: kCIInputScaleKey];

    outputResult = [bumpDistortion valueForKey: kCIOutputImageKey];


    //4.渲染输出,显示.
    CGRect extent = [outputResult extent];
    CGImageRef cgImage = [context createCGImage:outputResult fromRect:extent];

    self.dstImage.image = [[UIImage alloc]initWithCGImage:cgImage];
}

@end
