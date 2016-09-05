//
//  ZXSlider.m
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ZXSlider.h"

@interface ZXSlider ()
{
    ZXSliderValueChangedBlock _sliderValueChanged;
}
@end

@implementation ZXSlider

-(instancetype)initWithTilte:(NSString *)title
                    minValue:(CGFloat)min
                    maxValue:(CGFloat )max
                defaultVaule:(CGFloat)defaultValue
            valueChangeBlock:(ZXSliderValueChangedBlock) changeBlock
{
    if (self = [super initWithFrame:CGRectZero]) {

        [self addSubview:self.minValueLabel];
        [self addSubview:self.maxValueLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.currentValueLabel];
        [self addSubview:self.slider];

        self.minValueLabel.frame = CGRectMake(0, 0,[self minOrMaxLabelWidth], [self halfHeight]);

        self.maxValueLabel.frame = CGRectMake(0,[self halfHeight],[self minOrMaxLabelWidth],[self halfHeight]);

        self.titleLabel.frame = CGRectMake(
                                           CGRectGetMaxX(self.minValueLabel.frame),
                                           0,
                                           [self titleLabelWidth],
                                           [self height]
                                           );
        self.currentValueLabel.frame = CGRectMake(
                                              CGRectGetMaxX(self.titleLabel.frame),
                                              0,
                                              [self minOrMaxLabelWidth],
                                              [self height]
                                              );

        self.slider.frame = CGRectMake(
                                       CGRectGetMaxX(self.currentValueLabel.frame),
                                       0,
                                       [self sliderWidth],
                                        [self height]
                                       );
        self.slider.value = defaultValue;
        self.slider.maximumValue = max;
        self.slider.minimumValue = min;
        [self.slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
        _sliderValueChanged = changeBlock;


        self.titleLabel.text = title;
        self.minValueLabel.text = [NSString stringWithFormat:@"%.1f",min];
        self.maxValueLabel.text = [NSString stringWithFormat:@"%.1f",max];
        self.currentValueLabel.text = [NSString stringWithFormat:@"%.1f",self.slider.value];
    }
    return self;
}

-(void)sliderChanged
{
    if (_sliderValueChanged) {
        self.currentValueLabel.text = [NSString stringWithFormat:@"%.1f",self.slider.value];
        _sliderValueChanged(self.slider.value);
    }
}

-(CGFloat)minOrMaxLabelWidth
{
    return [self intrinsicContentSize].width * 1.5/12.0;
}

-(CGFloat)titleLabelWidth
{
    return [self intrinsicContentSize].width * 3.0/12.0;
}

-(CGFloat)sliderWidth
{
    return [self intrinsicContentSize].width * 5.6/12.0;
}

-(CGFloat)halfHeight
{
    return [self intrinsicContentSize].height * 1.0 / 2.0;
}

-(CGSize)intrinsicContentSize{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
}

-(CGFloat)height
{
    return [self intrinsicContentSize].height;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)minValueLabel
{
    if (!_minValueLabel) {
        _minValueLabel = [[UILabel alloc]init];
        _minValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minValueLabel;
}

-(UILabel *)maxValueLabel
{
    if (!_maxValueLabel) {
        _maxValueLabel = [[UILabel alloc]init];
        _maxValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _maxValueLabel;
}

-(UILabel *)currentValueLabel
{
    if (!_currentValueLabel) {
        _currentValueLabel = [[UILabel alloc]init];
        _currentValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentValueLabel;
}
-(UISlider *)slider
{
    if (!_slider) {
        _slider  = [[UISlider alloc]init];
    }
    return _slider;
}

@end
