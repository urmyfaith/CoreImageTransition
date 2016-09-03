//
//  WhiteVignetteFaceViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "WhiteVignetteFaceViewController.h"

@import CoreImage;

@interface WhiteVignetteFaceViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@end

@implementation WhiteVignetteFaceViewController
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

    [self testWhiteVignetteFaceFilter];
}

-(void)testWhiteVignetteFaceFilter
{
    //1.找到人脸

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
    NSLog(@"found faces: %zd",features.count);
    for (CIFeature *f in features) {
        NSLog(@"Found a face");

        //2.生成遮罩图
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;

        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;

        CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) /1.5;

        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
                                    @"inputRadius0", @(radius - 50.0f) ,
                                    @"inputRadius1", @(radius + 1000.0f),
                                    @"inputColor0",  [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                    @"inputColor1", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                    kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
                                    nil];

        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];


        //3.两个图叠加起来
        CIImage * maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
                                kCIInputImageKey, circleImage,
                                kCIInputBackgroundImageKey, self.inputImage,
                                nil] valueForKey:kCIOutputImageKey];

        //4.输出图片
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:maskImage fromRect:self.inputImage.extent];
        self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);

        break;
    }

}

@end
