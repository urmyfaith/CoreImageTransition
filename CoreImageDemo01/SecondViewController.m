//
//  SecondViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/1/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

// https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html

/*
 Transition filters require the following tasks:

  - Create Core Image images (CIImage objects) to use for the transition.
  - Set up and schedule a timer.
  - Create a CIContext object.
  - Create a CIFilter object for the filter to apply to the image.
  - On OS X, set the default values for the filter.
  - Set the filter parameters.
  - Set the source and the target images to process.
  - Calculate the time.
  - Apply the filter.
  - Draw the result.
  - Repeat steps 8–10 until the transition is complete.
 */

#import "SecondViewController.h"

@interface SecondViewController ()

{
    CGFloat _thumbnailWidth;
    CGFloat _thumbnailHeight;
}

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property(nonatomic, strong) CIImage *srcImage;
@property(nonatomic, strong) CIImage *dstImage;

@property(nonatomic, assign) NSTimeInterval base;

@property(nonatomic, strong) CIContext  *context;

@property(nonatomic, strong) CIFilter *transitionFilter;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myImageView.image = [UIImage imageNamed:@"boots.jpg"];

    _thumbnailWidth  = 300.0;
    _thumbnailHeight = 300.0;

    [self basicSteps];
    [self setupTimer];
}
-(void)basicSteps
{
    NSURL  *url = [NSURL fileURLWithPath: [[NSBundle mainBundle]  pathForResource: @"boots" ofType: @"jpg"]];
    self.srcImage  = [CIImage imageWithContentsOfURL: url];

    url  = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"skier" ofType: @"jpg"]];
    self.dstImage=  [CIImage imageWithContentsOfURL: url];


    self.context = [CIContext contextWithOptions:nil];

    [self configTransitionFilter];

}

- (void)configTransitionFilter
{
    CGFloat w = _thumbnailWidth;
    CGFloat h = _thumbnailHeight;

    CIVector *extent = [CIVector vectorWithX: 0  Y: 0  Z: w  W: h];

    self.transitionFilter  = [CIFilter filterWithName: @"CICopyMachineTransition"];
    [self.transitionFilter setValue: extent forKey: kCIInputExtentKey];
}

-(void)setupTimer
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
    CGFloat t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - self.base);
    NSLog(@"t=%.4f, base_t=%.4f",t,self.base);

    //进行滤镜处理
    CIImage *result = [self imageForTransition: t + 0.1];

    //绘制图片
    CGRect extent = [result extent];
    CGImageRef cgImage = [self.context createCGImage:result fromRect:extent];
    self.myImageView.image = [UIImage imageWithCGImage:cgImage];
}


- (CIImage *)imageForTransition: (float)t
{

    if (fmodf(t, 2.0) < 1.0f) {
        [self.transitionFilter setValue: self.srcImage  forKey: kCIInputImageKey];
        [self.transitionFilter setValue: self.dstImage  forKey: kCIInputTargetImageKey];
    } else {
        [self.transitionFilter setValue: self.dstImage  forKey: kCIInputImageKey];
        [self.transitionFilter setValue: self.srcImage  forKey: kCIInputTargetImageKey];
    }

    [self.transitionFilter setValue: @50
                             forKey: kCIInputWidthKey];
    [self.transitionFilter setValue: @( 0.5 * (1 - cos(fmodf(t, 1.0f) * M_PI)) )
                             forKey: kCIInputTimeKey];

    CIFilter  *crop = [CIFilter filterWithName: @"CICrop"];
    [crop setValue:[self.transitionFilter valueForKey: kCIOutputImageKey] forKey:kCIInputImageKey];
    [crop setValue:[CIVector vectorWithX: 0
                                       Y: 0
                                       Z: _thumbnailWidth
                                       W: _thumbnailHeight]
            forKey:@"inputRectangle"];
    return [crop valueForKey: kCIOutputImageKey];
}


@end
