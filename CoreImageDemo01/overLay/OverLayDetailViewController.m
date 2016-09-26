//
//  OverLayDetailViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/26/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "OverLayDetailViewController.h"

@interface OverLayDetailViewController ()
@property(nonatomic, strong) UIImageView *centerImageView;
@end

@implementation OverLayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 256, 192)];
    CGPoint center = self.view.center;
    self.centerImageView.center = CGPointMake(center.x, center.y-self.centerImageView.frame.size.height/2.0 - 10);
    [self.view addSubview:self.centerImageView];

    [self addFilter];
}

-(void)addFilter{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *URL1 = [[NSBundle mainBundle] URLForResource:@"overlay_fg" withExtension:@"png"];
        CIImage * inputImage = [[CIImage alloc] initWithContentsOfURL:URL1];

        NSURL *URL2 = [[NSBundle mainBundle] URLForResource:@"overlay_bg" withExtension:@"jpg"];
        CIImage *bgImage = [[CIImage alloc] initWithContentsOfURL:URL2];

        CIFilter *filter = [CIFilter filterWithName:self.filterName];

        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:bgImage forKey:kCIInputBackgroundImageKey];

        CIContext *context = [CIContext contextWithOptions:nil];

        CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:bgImage.extent];
        UIImage *image = [UIImage imageWithCGImage:resultImage];
        CIImage *outputImage = [CIImage imageWithCGImage:resultImage];
        CGImageRelease(resultImage);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerImageView.image = image;
            NSLog(@"\ninputImageSize:%@\nbgImageSize:%@\nresultSize:%@\n\n",
                  NSStringFromCGRect(inputImage.extent),
                  NSStringFromCGRect(bgImage.extent),
                  NSStringFromCGRect(outputImage.extent)
                  );
            NSLog(@"add filter:%@(%@) done.",self.filterName,[CIFilter localizedNameForFilterName:self.filterName]);
        });
    });
}
@end
