//
//  MSliderTabBarItem.h
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//UITabBarItem
@interface MSliderTabBarItem : NSObject <UIAppearance>

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;

@property(nonatomic, copy) NSString    *title;        // default is nil
@property(nonatomic, retain) UIImage     *image;        // default is nil

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSDictionary *)titleTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end
