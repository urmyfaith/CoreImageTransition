//
//  CICategoryColorAdjustmentBaseVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "CICategoryColorAdjustmentBaseVC.h"
#import "ZXFilterSlider.h"

@interface CICategoryColorAdjustmentBaseVC ()

@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIImageView *resultIamgeView;
@property(nonatomic, strong) CIImage *inputImage;
@property(nonatomic, strong) CIFilter *filter;
@property(nonatomic, strong) ZXFilterSlider *filterSlider;
@property(nonatomic, strong) CIContext *context;
@end

@implementation CICategoryColorAdjustmentBaseVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.filterName;
    
    self.view.backgroundColor = [UIColor grayColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 256, 192)];
    self.resultIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 256, 192)];
    CGPoint center = self.view.center;
    self.centerImageView.center = CGPointMake(center.x, center.y-self.centerImageView.frame.size.height/2.0 - 10);
    self.resultIamgeView.center = CGPointMake(center.x, center.y+self.resultIamgeView.frame.size.height/2.0 + 10);
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.resultIamgeView];

    self.resultIamgeView.layer.borderColor = [UIColor redColor].CGColor;
    self.resultIamgeView.layer.borderWidth = 3;


    UIImage *image = [UIImage imageNamed:@"Faces.jpg"];
    self.inputImage = [CIImage imageWithCGImage:image.CGImage];
    self.centerImageView.image = image;
    self.resultIamgeView.image = image;

    self.filter = [CIFilter filterWithName:self.filterName];
    [self checkFilterIsNotNull];
    [self.filter setValue:self.inputImage forKey:@"inputImage"];
    self.context = [CIContext contextWithOptions:nil];

    self.filterSlider = [[ZXFilterSlider alloc]initWithFilter:self.filter
                                                  changeBlock:^(CIFilter *filter) {
                                                      [self reDrawImageWithFilter:filter];
                                                  }];


    self.filterSlider.frame = CGRectMake(0, 0, self.filterSlider.intrinsicContentSize.width, self.filterSlider.intrinsicContentSize.height);
    self.filterSlider.center = self.view.center;
    [self.view addSubview:self.filterSlider];
}

-(void)checkFilterIsNotNull
{
    if (self.filter == nil) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:self.filterName message:@"filter name error" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.filterSlider.hidden = !self.filterSlider.isHidden;
}
-(void)reDrawImageWithFilter:(CIFilter *)filter
{
    CGImageRef cgImage = [self.context createCGImage:filter.outputImage fromRect:self.inputImage.extent];
    self.resultIamgeView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
}
@end
