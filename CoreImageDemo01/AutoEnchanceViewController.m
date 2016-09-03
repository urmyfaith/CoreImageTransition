//
//  AutoEnchanceViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "AutoEnchanceViewController.h"
#import "UIImage+Extension.h"

@import ImageIO; //kCGImagePropertyOrientation属性在里面
@import CoreImage;

@interface AutoEnchanceViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@end

@implementation AutoEnchanceViewController

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

        NSDictionary *options = nil;
//两种方法获取旋转方向.
#if 0
        if([[self.inputImage properties] valueForKey:(__bridge NSString *)kCGImagePropertyOrientation] == nil)
        {
            options = @{CIDetectorImageOrientation : [NSNumber numberWithInt:1]};
        }
        else
        {
            options = @{CIDetectorImageOrientation : [[self.inputImage properties] valueForKey:(__bridge NSString *)kCGImagePropertyOrientation]};
        }
#else
        options =@{CIDetectorImageOrientation : @([self.centerImageView.image getCGImagePropertyOrientation])};
#endif
        NSArray *adjustments = [self.inputImage autoAdjustmentFiltersWithOptions:options];
        for (CIFilter *filter in adjustments) {
            [filter setValue:self.inputImage forKey:kCIInputImageKey];
            self.inputImage = filter.outputImage;
        }

        CGImageRef cgImage = [context createCGImage:self.inputImage fromRect:self.inputImage.extent];
        self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
    });
}


@end
