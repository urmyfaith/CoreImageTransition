//
//  FaceDetectViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "FaceDetectViewController.h"
#import "CIFaceFeature+Extension.h"

@import ImageIO;

@import CoreImage;

@interface FaceDetectViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) CIImage *inputImage;
@end

@implementation FaceDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 256, 192)];
    [self.view addSubview:self.centerImageView];
    self.centerImageView.center = self.view.center;



    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"jpg"];

    if (filePath.length > 0 ) {
        NSURL *fillURL = [NSURL fileURLWithPath:filePath];
        self.inputImage = [CIImage imageWithContentsOfURL:fillURL];
        self.centerImageView.image = [UIImage imageWithCIImage:self.inputImage];
    }

    CIContext *context = [CIContext contextWithOptions:nil];

    NSDictionary *opts = @{
                           CIDetectorAccuracy: CIDetectorAccuracyHigh
                           };

    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];
//    id o =  [[self.inputImage properties] valueForKey:(NSString *)kCGImagePropertyOrientation];
//    opts = @{
//             CIDetectorImageOrientation: @1,
//            };
    NSArray *features = [detector featuresInImage:self.inputImage options:nil];

    NSLog(@"faces count = %zd",features.count);
    
    for (CIFaceFeature *f in features) {
        NSLog(@"%@",f);
        [self addShapeLayerAtFrame:f.bounds];
    }
}

//TODO: 这里的 frame 需要做坐标转换;

-(void)addShapeLayerAtFrame:(CGRect )frame
{

    //转换竖直方向
    frame = CGRectMake(frame.origin.x,  self.centerImageView.image.size.height - frame.origin.y, frame.size.width, frame.size.height);

    CGFloat widthFactor = self.centerImageView.frame.size.width / self.centerImageView.image.size.width;
    CGFloat heightFactor = self.centerImageView.frame.size.height / self.centerImageView.image.size.height;

    frame = CGRectMake(frame.origin.x * widthFactor,
                      frame.origin.y*heightFactor,
                       frame.size.width * widthFactor,
                       frame.size.height * heightFactor);

    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = frame;
    shape.strokeColor   = [UIColor yellowColor].CGColor;
    shape.fillColor     = [UIColor clearColor].CGColor;
    shape.lineCap       = kCALineCapSquare;
    shape.path          = [UIBezierPath bezierPathWithRect:frame].CGPath;
    shape.lineWidth     = 2.0;
    [self.centerImageView.layer addSublayer:shape];
}


@end
