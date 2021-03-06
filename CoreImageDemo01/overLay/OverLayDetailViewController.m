//
//  OverLayDetailViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/26/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "OverLayDetailViewController.h"

@interface OverLayDetailViewController ()
{
    CGFloat _translationX;
    CGFloat _translationY;
    CGSize _bgImageSize;
    CGSize _fgImageSize;
}
@property(nonatomic, strong) CIImage *orignal_fgImage;
@property(nonatomic, strong) CIImage *bgImage;
@property(nonatomic, strong) CIImage *fgImage;

@property(nonatomic, strong) CIFilter *filter;
@property(nonatomic, strong) CIContext *context;

@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) UIView *rectView;
@end

@implementation OverLayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 256, 192)];
    CGPoint center = self.view.center;
    self.centerImageView.center = CGPointMake(center.x, center.y-self.centerImageView.frame.size.height/2.0 - 10);
    [self.view addSubview:self.centerImageView];

    [self initImageSize];

    [self configRectView];

    self.filter = [CIFilter filterWithName:self.filterName];
    self.context = [CIContext contextWithOptions:nil];
    [self addFilter];
}

-(void)configRectView
{
    self.rectView = [[UIView alloc]initWithFrame:self.centerImageView.frame];
    self.rectView.userInteractionEnabled = YES;
    self.rectView.center = CGPointMake(CGRectGetMidX(self.centerImageView.frame),
                                       CGRectGetMidY(self.centerImageView.frame) + CGRectGetHeight(self.centerImageView.frame));
    self.rectView.backgroundColor = [UIColor clearColor];
    self.rectView.layer.borderColor = [UIColor redColor].CGColor;
    self.rectView.layer.borderWidth = 2.0;
    [self.view addSubview:self.rectView];
}

-(void)initImageSize
{
    NSURL *URL2 = [[NSBundle mainBundle] URLForResource:@"overlay_bg" withExtension:@"jpg"];
    CIImage *bgImage = [[CIImage alloc] initWithContentsOfURL:URL2];
    _bgImageSize = bgImage.extent.size;
    self.bgImage =bgImage;

    NSURL *URL1 = [[NSBundle mainBundle] URLForResource:@"overlay_fg" withExtension:@"png"];
    CIImage * inputImage = [[CIImage alloc] initWithContentsOfURL:URL1];
    self.orignal_fgImage = inputImage;
    self.fgImage = inputImage;
    _fgImageSize = inputImage.extent.size;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];

    if (CGRectContainsPoint(self.rectView.frame, point)) {
        CGPoint targatPoint = [touch locationInView:self.rectView];
//        NSLog(@"触摸点%@",NSStringFromCGPoint(targatPoint));

//        targatPoint.x                                   z
//        ------------                    ==          ----------
//        self.rectView.frame.size.width                  图片宽度

        CGFloat scaleX =  _bgImageSize.width / self.rectView.frame.size.width;
        CGFloat scaleY =   _bgImageSize.height / self.rectView.frame.size.height;

        _translationX = scaleX * targatPoint.x ;
        _translationY = scaleY * (self.rectView.frame.size.height - targatPoint.y);

//        NSLog(@"转换后点%@",NSStringFromCGPoint(CGPointMake(_translationX, _translationY)));
        [self movePointCenter];

        [self addFilter];
    }
}

-(void)movePointCenter
{
    _translationX = _translationX - _fgImageSize.width/2.0;
    _translationY = _translationY - _fgImageSize.height/2.0;
//    NSLog(@"平移后点%@",NSStringFromCGPoint(CGPointMake(_translationX, _translationY)));
}


/**
 fixBug: self.fgImage 每次的平移都会累加,滑动一下就累加很多,然后就看不到了....
 使用 self.orignal_fgImage 来记录原始的图片.
 */
-(void)addFilter{
    static BOOL inProgress = NO;

    if(inProgress){ return; }

    inProgress = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        self.fgImage = [self.orignal_fgImage imageByApplyingTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, _translationX, _translationY)];
        [self.filter setValue:self.fgImage forKey:kCIInputImageKey];
        [self.filter setValue:self.bgImage forKey:kCIInputBackgroundImageKey];

        CGImageRef resultImage = [self.context createCGImage:self.filter.outputImage fromRect:self.bgImage.extent];
        CIImage *outputImage = [CIImage imageWithCGImage:resultImage];
        UIImage *image = [UIImage imageWithCIImage:outputImage];
        CGImageRelease(resultImage);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerImageView.image = image;
//            NSLog(@"\ninputImageSize:%@\nbgImageSize:%@\nresultSize:%@\n\n",
//                  NSStringFromCGRect(self.fgImage.extent),
//                  NSStringFromCGRect(self.bgImage.extent),
//                  NSStringFromCGRect(outputImage.extent)
//                  );
//            NSLog(@"add filter:%@(%@) done.",self.filterName,[CIFilter localizedNameForFilterName:self.filterName]);
            inProgress = NO;
        });
    });
}
@end
