//
//  MSliderTabBar.h
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSliderTabBarItem.h"

@class MSliderTabBarItem;
@protocol MSliderTabBarDelegate;
//UITabBar
@interface MSliderTabBar : UIScrollView <UIAppearance>
/** 代理 */
@property(nonatomic,assign) id<MSliderTabBarDelegate, UIScrollViewDelegate> delegate;
/** 设置SliderTabBarItems */
@property(nonatomic,copy)   NSArray             *items;
/** 目前选择的SliderTabBarItem */
@property(nonatomic,assign) MSliderTabBarItem        *selectedItem;
/** 指示器的图片 */
@property(nonatomic,retain) UIImage *selectionIndicatorImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *selectionIndicatorColor;
@property(nonatomic,retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,retain) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

@end

@protocol MSliderTabBarDelegate <UIScrollViewDelegate>

- (void)sliderTabBar:(MSliderTabBar *)sliderTabBar didSelectItem:(MSliderTabBarItem *)item;

@end
