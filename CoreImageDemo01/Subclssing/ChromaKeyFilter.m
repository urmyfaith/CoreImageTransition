//
//  ChromaKeyFilter.m
//  CoreImageDemo01
//
//  Created by zx on 9/3/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ChromaKeyFilter.h"

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

@implementation ChromaKeyFilter
- (CIImage *)outputImage
{

    const unsigned int size = 64;
    //生成一个三维数组,线性填充 r,b,g,然后转换为 HSV.
    //通过 HSV 判断绿色范围
    //最后添加透明度.
    NSUInteger cubeDataSize = size * size * size * 4 * sizeof(float);
    float *cubeData = (float *)malloc (cubeDataSize);
    float rgb[3], hsv[3], *c = cubeData;
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1);
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1);
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1);

                RGBtoHSV(rgb[0],rgb[1],rgb[2] ,&hsv[0],&hsv[1],&hsv[2]);
                float alpha = (hsv[0] > 90 && hsv[0] < 140) ? 0.0f: 1.0f;

                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4;
            }
        }
    }

    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    [colorCube setValue:data forKey:@"inputCubeData"];

    [colorCube setValue:self.inputImage forKey:kCIInputImageKey];

    CIImage *result = [colorCube valueForKey: kCIOutputImageKey];

    return result;
}
@end
