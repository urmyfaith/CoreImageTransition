//
//  PixellateTransitionFilterVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "PixellateTransitionFilterVC.h"

@interface PixellateTransitionFilterVC ()
{
    CGFloat _thumbnailWidth;
    CGFloat _thumbnailHeight;
    CGFloat _roundTime;
}

@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) CIImage *srcImage;
@property(nonatomic, strong) CIImage *dstImage;

@property(nonatomic, assign) NSTimeInterval base;

@property(nonatomic, strong) CIContext *context;
@property(nonatomic, strong) CIFilter  *dissolveTransition;
@end

@implementation PixellateTransitionFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 66, 300, 300)];
    [self.view addSubview:self.centerImageView];
    _thumbnailWidth  = 300.0;
    _thumbnailHeight = 300.0;


    NSURL  *url = [NSURL fileURLWithPath: [[NSBundle mainBundle]  pathForResource: @"boots" ofType: @"jpg"]];
    self.srcImage  = [CIImage imageWithContentsOfURL: url];

    url  = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"skier" ofType: @"jpg"]];
    self.dstImage=  [CIImage imageWithContentsOfURL: url];

    self.context = [CIContext contextWithOptions:nil];
    self.dissolveTransition   = [CIFilter filterWithName: @"CIDissolveTransition"];

    _roundTime = 10.0f;

    [self configTimer];
}


-(void)configTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/30.0
                                                      target: self
                                                    selector: @selector(timerFired:)
                                                    userInfo: nil
                                                     repeats: YES];

    self.base = [NSDate timeIntervalSinceReferenceDate];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: timer
                                 forMode: UITrackingRunLoopMode];
}

- (void)timerFired: (id)sender
{
    [self loop];
}

- (void)loop
{
    //计算时间
    CGFloat t = ([NSDate timeIntervalSinceReferenceDate] - self.base);
    t = fmodf(t, _roundTime);

    //进行滤镜处理
    CIImage *result = [self imageForTransition: t];

    //绘制图片
    CGRect extent = [result extent];
    CGImageRef cgImage = [self.context createCGImage:result fromRect:extent];
    self.centerImageView.image = [UIImage imageWithCGImage:cgImage];
    self.centerImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.centerImageView.layer.borderWidth = 2.0;
}

/**
 滤镜处理:
 
 1)添加转场滤镜
 2)添加像素化滤镜
 3)添加裁剪滤镜

 */
- (CIImage *)imageForTransition: (float)t
{

    if (fmodf(t, _roundTime) < _roundTime / 2.0) {
        [self.dissolveTransition setValue: self.srcImage  forKey: kCIInputImageKey];
        [self.dissolveTransition setValue: self.dstImage  forKey: kCIInputTargetImageKey];
    } else {
        t = _roundTime - t;
        [self.dissolveTransition setValue: self.dstImage  forKey: kCIInputImageKey];
        [self.dissolveTransition setValue: self.srcImage  forKey: kCIInputTargetImageKey];
    }
    NSLog(@"t=%.4f",t);

    [self.dissolveTransition setValue:@(t)
                             forKey: kCIInputTimeKey];

    CIFilter *pixellate = [CIFilter filterWithName:@"CIPixellate"];
    [pixellate setValue:self.dissolveTransition.outputImage forKey:kCIInputImageKey];
    CGFloat scale = 90*(1 - 2*ABS(t/_roundTime - 0.5));
    NSLog(@"scale=%.4f",scale);
    [pixellate setValue:@(scale) forKey:kCIInputScaleKey];

    CIFilter  *crop = [CIFilter filterWithName: @"CICrop"];
    [crop setValue:pixellate.outputImage forKey:kCIInputImageKey];
    [crop setValue:[CIVector vectorWithX: 0
                                       Y: 0
                                       Z: _thumbnailWidth
                                       W: _thumbnailHeight]
            forKey:@"inputRectangle"];
    return [crop valueForKey: kCIOutputImageKey];
}


@end
