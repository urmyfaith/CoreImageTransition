//
//  ZXFilterSlider.h
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZXFilterSliderChangedBlock)(CIFilter *filter);
@interface ZXFilterSlider : UIView
-(instancetype)initWithFilter:(CIFilter *)filter changeBlock:(ZXFilterSliderChangedBlock)changeBlock;
@end
