//
//  ZXSlider.h
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ZXSliderValueChangedBlock)(CGFloat value);

@interface ZXSlider : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *minValueLabel;
@property(nonatomic, strong) UILabel *maxValueLabel;
@property(nonatomic, strong) UILabel *currentValueLabel;
@property(nonatomic, strong) UISlider *slider;

-(instancetype)initWithTilte:(NSString *)title
                    minValue:(CGFloat)min
                    maxValue:(CGFloat )max
                defaultVaule:(CGFloat)defaultValue
            valueChangeBlock:(ZXSliderValueChangedBlock) changeBlock;
@end
