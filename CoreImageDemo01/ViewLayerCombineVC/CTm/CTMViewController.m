//
//  CTMViewController.m
//  CoreImageDemo01
//
//  Created by zx on 10/8/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "CTMViewController.h"

@interface CTMViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *outputImageView;
@end

@implementation CTMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.centerImageView];
    self.centerImageView.image = [UIImage imageNamed:@"overlay_bg.jpg"];
    self.centerImageView.frame = CGRectMake(0,64, 256, 192);

    [self.view addSubview:self.outputImageView];
    self.outputImageView.frame = CGRectMake(0, 64+192+5, 256, 192);

    UIGraphicsBeginImageContextWithOptions(self.outputImageView.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGImageRef maskImage = (__bridge CGImageRef) self.centerImageView.layer.contents;
    CGContextDrawImage(contextRef,self.outputImageView.frame, maskImage);
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.outputImageView.image = result;
}
-(UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView =[[UIImageView alloc]init];
    }
    return _centerImageView;
}
-(UIImageView *)outputImageView
{
    if (!_outputImageView) {
        _outputImageView =[[UIImageView alloc]init];
    }
    return _outputImageView;
}
@end
