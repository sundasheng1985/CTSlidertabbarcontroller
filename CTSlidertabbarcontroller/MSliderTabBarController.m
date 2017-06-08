//
//  MSliderTabBarController.m
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import <objc/runtime.h>
#import "MSliderTabBarController.h"

static const CGFloat kMSliderTabBarHeight = 35.;
static const CGFloat kMSliderToolbarHeight = 40.;

#pragma mark - Class _MSliderTabBarContainerView

@interface _MSliderTabBarContainerView : UIView <UIScrollViewDelegate, MSliderTabBarDelegate>
@property (nonatomic, readonly) MSliderTabBar *sliderTabBar;
@property (nonatomic, readonly) UIScrollView *pageContainer;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, readonly) UIToolbar *toolbar;
@property(nonatomic,getter=isSliderTabBarHidden) BOOL sliderTabBarHidden;
- (void)setSliderTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/** 滑动许可 */
@property(nonatomic, getter=isAllowsSwipeable) BOOL allowsSwipeable;
/** 滚动是否循环 */
@property(nonatomic,getter=isCirculationEnabled) BOOL circulationEnabled;
/** 隐藏工具列，默认yes */
@property (nonatomic, assign, getter=isToolbarHidden) BOOL toolbarHidden;

- (void)resetContentOffset;
@end

@implementation _MSliderTabBarContainerView {
    struct {
        unsigned int sliderTabBarHidden:1;
        unsigned int allowsSwipeable:1;
        unsigned int toolbarHidden:1;
        unsigned int sliderDragging:1;
        int previousIndex;
        int nextIndex;
    } _mviewFlags;
}

@synthesize selectedViewController = _selectedViewController;
@synthesize sliderTabBar = _sliderTabBar;
@synthesize toolbar = _toolbar;
@synthesize pageContainer = _pageContainer;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mviewFlags.toolbarHidden = 1;
        _mviewFlags.allowsSwipeable = 0;
        _mviewFlags.sliderTabBarHidden = 0;
        [self addSubview:self.pageContainer];
        [self addSubview:self.sliderTabBar];
        [self addSubview:self.toolbar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetSubviews];
    [self resetContentSize];
    [self resetContentOffset];
}

- (MSliderTabBar *)sliderTabBar {
    if(!_sliderTabBar) {
        _sliderTabBar = [[MSliderTabBar alloc] initWithFrame:(CGRect) {
            {0, 0},
            {CGRectGetWidth(self.frame), kMSliderTabBarHeight}
        }];
        _sliderTabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sliderTabBar.delegate = self;
    }
    return _sliderTabBar;
}

- (UIScrollView *)pageContainer {
    if(!_pageContainer) {
        _pageContainer = [[UIScrollView alloc] initWithFrame:(CGRect) {
            {0, kMSliderTabBarHeight},
            {CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - kMSliderTabBarHeight}
        }];
        _pageContainer.showsVerticalScrollIndicator = self.pageContainer.showsHorizontalScrollIndicator = NO;
//        _pageContainer.bounces = NO;
        _pageContainer.delegate = self;
        _pageContainer.pagingEnabled = YES;
        _pageContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _pageContainer;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _toolbar;
}

- (void)resetContentOffset {
    if (self.selectedViewController) {
        self.pageContainer.contentOffset = CGPointMake([self containerWidth] * self.selectedIndex, 0);
    }
}

#pragma mark - Private methods

- (void)resetContentSize {
    if (self.circulationEnabled) {
        self.pageContainer.contentSize = CGSizeMake(3 * [self containerWidth], [self containerHeight]);
    }
    else {
        self.pageContainer.contentSize = CGSizeMake(self.viewControllers.count * [self containerWidth], [self containerHeight]);
    }
}

- (CGFloat)containerWidth {
    return CGRectGetWidth(self.pageContainer.frame);
}

- (CGFloat)containerHeight {
    return CGRectGetHeight(self.pageContainer.frame);
}

#pragma mark - setter & getter

- (void)setViewControllers:(NSArray *)viewControllers {
    for (UIViewController *viewController in _viewControllers) {
        if (viewController.view.superview) {
            [viewController.view removeFromSuperview];
        }
    }
    _viewControllers = viewControllers;
    NSMutableArray *sliderTabBarItems = [NSMutableArray array];
    for (UIViewController *viewController in _viewControllers) {
        [sliderTabBarItems addObject:viewController.sliderTabBarItem];
    }
    self.sliderTabBar.items = sliderTabBarItems;
    [self resetContentSize];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.sliderTabBar.selectedItem = self.sliderTabBar.items[selectedIndex];
    
    if (self.circulationEnabled) {
        _mviewFlags.previousIndex = (int)selectedIndex - 1;
        if (_mviewFlags.previousIndex < 0) {
            _mviewFlags.previousIndex = (int)self.viewControllers.count - 1;
        }
    }
    else {
        if (_selectedViewController) {
            [_selectedViewController viewWillDisappear:NO];
            [_selectedViewController viewDidDisappear:NO];
            [_selectedViewController removeFromParentViewController];
        }
        _selectedViewController = self.viewControllers[selectedIndex];
        
        [_selectedViewController.sliderTabBarController addChildViewController:_selectedViewController];
        
        if (!_selectedViewController.view.superview) {
            _selectedViewController.view.frame = CGRectMake([self containerWidth] * selectedIndex, 0, [self containerWidth], [self containerHeight]);
            [self.pageContainer addSubview:_selectedViewController.view];
        }
        else {
            [_selectedViewController viewWillAppear:NO];
            [_selectedViewController viewDidAppear:NO];
        }
        [self resetContentOffset];
    }
}

- (NSUInteger)selectedIndex {
    NSUInteger index = [self.sliderTabBar.items indexOfObject:self.sliderTabBar.selectedItem];
    return index;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    self.selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
}

- (UIViewController *)selectedViewController {
    if (self.selectedIndex == NSNotFound) {
        return nil;
    }
    return self.viewControllers[self.selectedIndex];
}

- (BOOL)isSliderTabBarHidden {
    return _mviewFlags.sliderTabBarHidden;
}

- (void)setSliderTabBarHidden:(BOOL)hidden {
    [self setSliderTabBarHidden:hidden animated:NO];
}

- (void)setSliderTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _mviewFlags.sliderTabBarHidden = hidden;
    if (animated) {
        [UIView animateWithDuration:.2 animations:^{
            [self resetSubviews];
        }];
    }
    else {
        [self resetSubviews];
    }
}

- (void)resetSubviews {
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    self.sliderTabBar.frame = (CGRect) {
        {0, _mviewFlags.sliderTabBarHidden ? -kMSliderTabBarHeight : 0},
        {viewWidth, kMSliderTabBarHeight}
    };
    self.toolbar.frame = (CGRect) {
        {0, _mviewFlags.toolbarHidden ? viewHeight : viewHeight - kMSliderToolbarHeight},
        {viewWidth, kMSliderToolbarHeight}
    };
    self.pageContainer.frame = (CGRect) {
        {0, _mviewFlags.sliderTabBarHidden ? 0 : kMSliderTabBarHeight},
        {viewWidth, viewHeight - (_mviewFlags.sliderTabBarHidden ? 0 : kMSliderTabBarHeight) - (_mviewFlags.toolbarHidden ? 0 : kMSliderToolbarHeight)}
    };
}

- (void)setAllowsSwipeable:(BOOL)allowsSwipeable {
    self.pageContainer.scrollEnabled = allowsSwipeable;
}

- (BOOL)isAllowsSwipeable {
    return self.pageContainer.scrollEnabled;
}

- (void)setToolbarHidden:(BOOL)toolbarHidden {
    _mviewFlags.toolbarHidden = toolbarHidden;
    [self resetSubviews];
}

- (BOOL)isToolbarHidden {
    return _mviewFlags.toolbarHidden;
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _mviewFlags.sliderDragging = true;
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    /// 手勢滾動才setSelectedIndex，防止ScrollView frame改變觸發此delegate而造成selectedIndex改變。
    /// @see _mviewFlags.sliderDragging
    if(scrollView == self.pageContainer && _mviewFlags.sliderDragging) {
        NSInteger selectedIndex = self.pageContainer.contentOffset.x / CGRectGetWidth(self.pageContainer.frame);
        self.selectedIndex = selectedIndex;
    }
    _mviewFlags.sliderDragging = false;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScroll:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndScroll:scrollView];
}

#pragma mark Slider tabbar delegate

- (void)sliderTabBar:(MSliderTabBar *)sliderTabBar didSelectItem:(MSliderTabBarItem *)item {
    NSInteger selectedIndex = [self.sliderTabBar.items indexOfObject:item];
    self.selectedIndex = selectedIndex;
}

@end

#pragma mark - Category UIViewController(MSliderTabBarControllerPrivate)

@interface UIViewController (MSliderTabBarControllerPrivate)
- (void)setSliderTabBarController:(MSliderTabBarController *)sliderTabBarController;
- (void)setSliderTabBarItem:(MSliderTabBarItem *)sliderTabBarItem;
@end

#pragma mark - Class MSliderTabBarController

@interface MSliderTabBarController ()
@property (nonatomic, strong) _MSliderTabBarContainerView *containerView;
@end

@implementation MSliderTabBarController

@synthesize allowsSwipeable = _allowsSwipeable;
@dynamic toolbarHidden;

- (id)init {
    self = [super init];
    if(self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.containerView];
    }
    return self;
}

- (void)awakeFromNib {
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver:self forKeyPath:@"containerView.selectedIndex" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView performSelector:@selector(resetContentOffset) withObject:nil afterDelay:.1];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"containerView.selectedIndex"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter & setter

- (_MSliderTabBarContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[_MSliderTabBarContainerView alloc] initWithFrame:self.view.bounds];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

- (MSliderTabBar *)sliderTabBar {
    return self.containerView.sliderTabBar;
}

- (UIToolbar *)toolbar {
    return self.containerView.toolbar;
}

- (void)setToolbarHidden:(BOOL)toolbarHidden {
    self.containerView.toolbarHidden = toolbarHidden;
}

- (BOOL)isToolbarHidden {
    return self.containerView.isToolbarHidden;
}

#pragma mark Selected view controller

- (NSUInteger)selectedIndex {
    return self.containerView.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.containerView.selectedIndex = selectedIndex;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    self.selectedIndex = [self.containerView.viewControllers indexOfObject:selectedViewController];
}

- (UIViewController *)selectedViewController {
    return self.containerView.selectedViewController;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    for (UIViewController *viewController in self.containerView.viewControllers) {
        [viewController setSliderTabBarController:nil];
    }
    
    self.containerView.viewControllers = viewControllers;
    
    for (UIViewController *viewController in self.containerView.viewControllers) {
        [viewController setSliderTabBarController:self];
    }
}

- (NSArray *)viewControllers {
    return self.containerView.viewControllers;
}

- (void)setAllowsSwipeable:(BOOL)allowsSwipeable {
    self.containerView.allowsSwipeable = allowsSwipeable;
}

- (BOOL)isAllowsSwipeable {
    return self.containerView.allowsSwipeable;
}

- (void)setSliderTabBarHidden:(BOOL)sliderTabBarHidden {
    [self setSliderTabBarHidden:sliderTabBarHidden animated:NO];
}

- (void)setSliderTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self.containerView setSliderTabBarHidden:hidden animated:animated];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self) {
        if ([keyPath isEqualToString:@"containerView.selectedIndex"]) {
//            NSInteger index = [change[NSKeyValueChangeNewKey] integerValue];
            if ([self.delegate respondsToSelector:@selector(sliderTabBarController:didSelectViewController:)]) {
                [self.delegate sliderTabBarController:self didSelectViewController:self.selectedViewController];
            }
            return;
        }
    }
}

@end

@implementation UIViewController (MSliderTabBarController)

static char sliderTabBarItemKey;
static char sliderTabBarControllerKey;
static char sliderTabContentHeightKey;

- (void)setSliderTabBarController:(MSliderTabBarController *)sliderTabBarController {
    [self willChangeValueForKey:@"sliderTabBarController"];
    objc_setAssociatedObject(self,
                             &sliderTabBarControllerKey,
                             sliderTabBarController,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"sliderTabBarController"];
}

- (MSliderTabBarController *)sliderTabBarController {
    id controller = objc_getAssociatedObject(self,
                                             &sliderTabBarControllerKey);
    if (!controller && self.navigationController) {
        controller = self.navigationController.sliderTabBarController;
    }
    if (!controller && self.tabBarController) {
        controller = self.tabBarController.sliderTabBarController;
    }
    return controller;
}

- (MSliderTabBarItem *)sliderTabBarItem {
    id item = objc_getAssociatedObject(self, &sliderTabBarItemKey);
    if(!item) {
        item = [[MSliderTabBarItem alloc] initWithTitle:@"" image:nil tag:0];
        [self setSliderTabBarItem:item];
    }
    return item;
}

- (void)setSliderTabBarItem:(MSliderTabBarItem *)sliderTabBarItem {
    [self willChangeValueForKey:@"sliderTabBarItem"];
    objc_setAssociatedObject(self, &sliderTabBarItemKey, sliderTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"sliderTabBarItem"];
}

- (CGFloat)contentHeightInSliderTab {
    return [objc_getAssociatedObject(self, &sliderTabContentHeightKey) floatValue];
}

- (void)setContentHeightInSliderTab:(CGFloat)contentHeightInSliderTab {
    [self willChangeValueForKey:@"contentHeightInSliderTab"];
    objc_setAssociatedObject(self, &sliderTabContentHeightKey, @(contentHeightInSliderTab), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"contentHeightInSliderTab"];
}

@end

