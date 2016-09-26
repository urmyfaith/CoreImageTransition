//
//  ZXFilterSlider.m
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ZXFilterSlider.h"
#import "ZXSlider.h"
@interface ZXFilterSlider()
{
  __block  CGFloat _width;
  __block  CGFloat _height;
}
@end


@implementation ZXFilterSlider

-(instancetype)initWithFilter:(CIFilter *)filter changeBlock:(ZXFilterSliderChangedBlock)changeBlock;
{
    if (self = [super initWithFrame:CGRectZero]) {
        NSDictionary *dic = [self deriveEditableAttributesForFilter:filter].copy;

        __block CIFilter *filterInBlock = filter;

        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSDictionary*  _Nonnull value, BOOL * _Nonnull stop) {
            NSString *title = [key stringByReplacingOccurrencesOfString:@"input" withString:@""];
            NSNumber *max = [value valueForKey:@"CIAttributeSliderMax"];
            NSNumber *min = [value valueForKey:@"CIAttributeMin"];
            NSNumber *defaultValue = [value valueForKey:@"CIAttributeIdentity"];
            ZXSlider *slider = [[ZXSlider alloc]initWithTilte:title
                                                     minValue:min.floatValue
                                                     maxValue:max.floatValue
                                                 defaultVaule:defaultValue.floatValue
                                             valueChangeBlock:^(CGFloat value) {
                                                 [filterInBlock setValue:@(value) forKey:key];
                                                 if (changeBlock) {
                                                     changeBlock(filterInBlock);
                                                 }
                                             }];
            [self addSubview:slider];
        }];

        NSArray *subViews = self.subviews;

        [subViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ZXSlider class]]) {
                ZXSlider *slider = (ZXSlider *)obj;
                slider.frame = CGRectMake(0, idx * [slider intrinsicContentSize].height, [slider intrinsicContentSize].width ,  [slider intrinsicContentSize].height);
                _width = slider.frame.size.width;
                _height += [slider intrinsicContentSize].height;
            }
        }];

        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return self;
}

-(CGSize)intrinsicContentSize
{
    return CGSizeMake(_width, _height);
}

- (NSDictionary*)deriveEditableAttributesForFilter:(CIFilter*)filter
{
    NSMutableDictionary *editableAttributes = [NSMutableDictionary dictionary];
    NSDictionary *filterAttributes = [filter attributes];

    for (NSString *key in filterAttributes) {

        if ([key hasPrefix:@"input"]) {
            id value = [filterAttributes valueForKey:key];
            NSLog(@"key=%@,value=%@",key,value);
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSString *attributeClassString = [value valueForKey:@"CIAttributeClass"];
                NSLog(@"calss=%@",attributeClassString);
                if ([attributeClassString isEqualToString:@"NSNumber"]) {
                    [editableAttributes setObject:value forKey:key];
                }else{
                 NSLog(@"calss=%@",attributeClassString);
                }
            }
        }
    }
    return editableAttributes;
}
@end
