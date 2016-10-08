//
//  ViewLayerCombineVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/30/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ViewLayerCombineVC.h"

@import ImageIO;
@import CoreImage;
@import MobileCoreServices;

@interface ViewLayerCombineVC ()
@property (strong, nonatomic)  UIImageView *imageViewTop;
@property (strong, nonatomic)  UIImageView *imageViewBotton;
@property (strong, nonatomic)  UIImageView *resutImageView;
@end

@implementation ViewLayerCombineVC

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];

    self.imageViewTop = [[UIImageView alloc]init];
    self.imageViewTop.frame = CGRectMake(100, 100, 150, 100);
    [self.view addSubview:self.imageViewTop];

    self.imageViewBotton = [[UIImageView alloc]init];
    self.imageViewBotton.frame = CGRectMake(100, 205, 150, 100);
    [self.view addSubview:self.imageViewBotton];

    self.resutImageView = [[UIImageView alloc]init];
    self.resutImageView.frame = CGRectMake(100, 305, 150, 100);
    [self.view addSubview:self.resutImageView];

    NSURL *URL1 = [[NSBundle mainBundle] URLForResource:@"Faces" withExtension:@"jpg"];
    CIImage *bgIamge = [[CIImage alloc] initWithContentsOfURL:URL1];
    self.imageViewBotton.image = [UIImage imageWithCIImage:bgIamge];

    NSURL *URL2 = [[NSBundle mainBundle] URLForResource:@"stickers_2" withExtension:@"png"];
    CIImage *fgImage = [[CIImage alloc] initWithContentsOfURL:URL2];
    self.imageViewTop.image = [UIImage imageWithCIImage:fgImage];


    [self testViewLayerCombine];
}

-(UIImage *)getRanderdIamge
{
    UIImage *image  = self.imageViewBotton.image;

    CGSize maxsize = CGSizeMake(8192,8192);

    UIGraphicsBeginImageContextWithOptions(maxsize, NO, image.scale);
    CGFloat scale = maxsize.width / self.imageViewTop.frame.size.width;
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
//    CGFloat scale = image.size.width / self.imageViewTop.frame.size.width;

    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [self.imageViewTop.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tmp;
}
-(void)testViewLayerCombine
{
    CIContext *context = [CIContext contextWithOptions:nil];

    CIImage *inputImage = self.imageViewBotton.image.CIImage;

    CIImage *maskImage = [CIImage imageWithCGImage:[self getRanderdIamge].CGImage];

    CIFilter *overlayFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];

    [overlayFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    [overlayFilter setValue:maskImage forKey:kCIInputImageKey];


    CGImageRef cgImage = [context createCGImage:overlayFilter.outputImage fromRect:inputImage.extent];
    self.resutImageView.image = [[UIImage alloc]initWithCGImage:cgImage];
    CGImageRelease(cgImage);

    [ViewLayerCombineVC CGImageWriteToFile:[context createCGImage:inputImage fromRect:inputImage.extent]
                                  withPath:[ViewLayerCombineVC saveImageWithFileName:@"inputImage"]];
    [ViewLayerCombineVC CGImageWriteToFile:maskImage.CGImage withPath:[ViewLayerCombineVC saveImageWithFileName:@"maskImage"]];
    [ViewLayerCombineVC CGImageWriteToFile:cgImage withPath:[ViewLayerCombineVC saveImageWithFileName:@"outputImage"]];

}


+(BOOL)CGImageWriteToFile:(CGImageRef)image  withPath:(NSString*)path {

    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }
    CGImageDestinationAddImage(destination, image, nil);

    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }
    CFRelease(destination);
    return YES;
}

+(NSString*)saveImageWithFileName:(NSString *)filename
{
    return [[self getSystemCachePath] stringByAppendingPathComponent:filename];
}

+ (NSString *)getSystemCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *systemCacheDirectory = [paths objectAtIndex:0];
    return systemCacheDirectory;
}
@end
