//
//  MSliderTabBarController.h
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSliderTabBar.h"
//UITabBarController
//UINavigationController
@protocol MSliderTabBarControllerDelegate;

@interface MSliderTabBarController : UIViewController
/** 设置视图控制器阵列 */
@property(nonatomic,copy) NSArray *viewControllers;
/** 目前选择的视图控制器 */
@property(nonatomic,assign) UIViewController *selectedViewController;
/** 目前选择的视图控制器索引 */
@property(nonatomic) NSUInteger selectedIndex;
/** 菜单条 */
@property(nonatomic,readonly) MSliderTabBar *sliderTabBar;
/** 代理 */
@property(nonatomic,assign) id<MSliderTabBarControllerDelegate> delegate;
/** 滑动许可 */
@property(nonatomic, getter=isAllowsSwipeable) BOOL allowsSwipeable;
/** 隐藏标签 */
@property(nonatomic,getter=isSliderTabBarHidden) BOOL sliderTabBarHidden;
/** 隐藏标签 */
- (void)setSliderTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
/** 滚动是否循环 */
@property(nonatomic,getter=isCirculationEnabled) BOOL circulationEnabled;

/** 隐藏工具列，默认yes */
@property (nonatomic, assign, getter=isToolbarHidden) BOOL toolbarHidden;

@property (nonatomic, readonly) UIToolbar *toolbar;
@end

@protocol MSliderTabBarControllerDelegate <NSObject>
@optional

- (void)sliderTabBarController:(MSliderTabBarController *)sliderTabBarController didSelectViewController:(UIViewController *)viewController;


@end



@interface UIViewController (MSliderTabBarController)
/** */
@property(nonatomic,retain) MSliderTabBarItem *sliderTabBarItem;
/** */
@property(nonatomic,readonly,retain) MSliderTabBarController *sliderTabBarController;

@property(nonatomic,readwrite) CGFloat contentHeightInSliderTab;

@end
