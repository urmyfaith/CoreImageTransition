

// see blog at: http://blog.caffeine.lu/creating-a-tilt-shift-effect-with-coreimage.html

// gist:  https://gist.github.com/4327330

#import <CoreImage/CoreImage.h>

@interface JPTiltShift : CIFilter

@property (retain, nonatomic) CIImage *inputImage;
@property (assign, nonatomic) CGFloat inputRadius;
@property (assign, nonatomic) CGFloat inputTop;
@property (assign, nonatomic) CGFloat inputCenter;
@property (assign, nonatomic) CGFloat inputBottom;

@end
