//
//  ChromaKeyFilterVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ChromaKeyFilterVC.h"
#import "ChromaKeyFilter.h"

@import CoreImage;

@interface ChromaKeyFilterVC ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@end

@implementation ChromaKeyFilterVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, 256, 192)];
    self.resultIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 256, 192)];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.resultIamgeView];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"person@2x" ofType:@"png"];

    if (filePath.length > 0 ) {
        NSURL *fillURL = [NSURL fileURLWithPath:filePath];
        self.inputImage = [CIImage imageWithContentsOfURL:fillURL];
        self.centerImageView.image = [UIImage imageWithCIImage:self.inputImage];
    }
    [self testChromaKeyFilter];
}

-(void)testChromaKeyFilter
{
    ChromaKeyFilter *chromaKeyFilter = [ChromaKeyFilter new];
    [chromaKeyFilter setValue:self.inputImage forKey:kCIInputImageKey];
    CIImage *result = [chromaKeyFilter valueForKey: kCIOutputImageKey];

    //如果想只是去掉背景颜色,可以把下面的开关关闭(0),不进行叠加.
#if 1
    CIFilter *overComposeFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [overComposeFilter setValue:result forKey:kCIInputImageKey];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beach@2x" ofType:@"png"];
    CIImage *bgImage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    [overComposeFilter setValue:bgImage forKey:kCIInputBackgroundImageKey];
    result = [overComposeFilter valueForKey:kCIOutputImageKey];
#endif

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:self.inputImage.extent];
    self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

}
@end
