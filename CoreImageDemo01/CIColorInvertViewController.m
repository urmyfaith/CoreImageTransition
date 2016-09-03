//
//  CIColorInvertViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "CIColorInvertViewController.h"


@interface CIZXColorInvert : CIFilter
{
    CIImage *inputImage;
}
@property(nonatomic, retain) CIImage *inputImage;
@end

@implementation CIZXColorInvert
@synthesize inputImage;
- (CIImage *) outputImage
{
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"
                            withInputParameters: @{
                                                   kCIInputImageKey: inputImage,
                                                   @"inputRVector": [CIVector vectorWithX:-1 Y:0 Z:0],
                                                   @"inputGVector": [CIVector vectorWithX:0 Y:-1 Z:0],
                                                   @"inputBVector": [CIVector vectorWithX:0 Y:0 Z:-1],
                                                   @"inputBiasVector": [CIVector vectorWithX:1 Y:1 Z:1],
                                                   }];
    return filter.outputImage;
}

@end

@interface CIColorInvertViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;

@end

@implementation CIColorInvertViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, 256, 192)];
    self.resultIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 256, 192)];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.resultIamgeView];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"jpg"];

    if (filePath.length > 0 ) {
        NSURL *fillURL = [NSURL fileURLWithPath:filePath];
        self.inputImage = [CIImage imageWithContentsOfURL:fillURL];
        self.centerImageView.image = [UIImage imageWithCIImage:self.inputImage];
    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        CIContext *context = [CIContext contextWithOptions:nil];
        CIFilter *filter = [[CIZXColorInvert alloc]init];
        [filter setValue:self.inputImage forKey:kCIInputImageKey];

        CIImage *result = [filter valueForKey: kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:self.inputImage.extent];
        self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
    });
}
@end
