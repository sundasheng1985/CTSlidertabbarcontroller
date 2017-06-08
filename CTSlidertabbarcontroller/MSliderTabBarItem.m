//
//  MSliderTabBarItem.m
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "MSliderTabBarItem.h"
//默认
#define kMSliderTabBarItemAttributesDefault @{ \
UITextAttributeFont: [UIFont boldSystemFontOfSize:12], \
UITextAttributeTextColor: [UIColor whiteColor], \
UITextAttributeTextShadowColor: [UIColor lightGrayColor], \
UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(1, 2)] \
}
//选中
#define kMSliderTabBarItemAttributesSelected @{ \
UITextAttributeFont: [UIFont boldSystemFontOfSize:14], \
UITextAttributeTextColor: [UIColor yellowColor], \
UITextAttributeTextShadowColor: [UIColor lightGrayColor], \
UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(1, 2)] \
}

@interface MSliderTabBarItem ()
@property (nonatomic, strong) NSMutableDictionary *attributeCollection;
@property (nonatomic, weak) id sliderTabBarTab;
@end
@implementation MSliderTabBarItem

+ (instancetype)appearance {
    return nil;
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return nil;
}


- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    self = [super init];
    if(self) {
        _title = title;
        _image = image;
    }
    return self;
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    self.attributeCollection[@(state)] = attributes;
    [self refreshSliderTabBarTab];
}

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state  {
    if (state & UIControlStateSelected) {
        return self.attributeCollection[@(UIControlStateSelected)];
    }
    return self.attributeCollection[@(state)];
}

- (NSMutableDictionary *)attributeCollection {
    if (!_attributeCollection) {
        _attributeCollection = [[NSMutableDictionary alloc] init];
        _attributeCollection[@(UIControlStateNormal)] = kMSliderTabBarItemAttributesDefault;
        _attributeCollection[@(UIControlStateSelected)] = kMSliderTabBarItemAttributesSelected;
        _attributeCollection[@(UIControlStateReserved)] = kMSliderTabBarItemAttributesSelected;
    }
    return _attributeCollection;
}

- (void)refreshSliderTabBarTab {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.sliderTabBarTab respondsToSelector:@selector(refreshLabel)]) {
        [self.sliderTabBarTab performSelector:@selector(refreshLabel)];
    }
#pragma clang diagnostic pop
}
@end
