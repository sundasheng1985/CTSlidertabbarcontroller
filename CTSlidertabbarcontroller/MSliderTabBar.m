//
//  MSliderTabBar.m
//  SliderSegment
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "MSliderTabBar.h"

static const CGFloat kMSliderTabBarFontSize = 13.;
static const CGFloat kMSliderTabBarTabMargin = 10.;

#pragma mark - MSliderTabBarTab

@interface MSliderTabBarTab : UIControl
@property (nonatomic, copy) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) MSliderTabBarItem *item;
@property (nonatomic, strong) UILabel *textLabel;

- (id)initWithFrame:(CGRect)frame item:(MSliderTabBarItem *)item;

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSDictionary *)titleTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)refreshLabel;
@end

@implementation MSliderTabBarTab


- (id)initWithFrame:(CGRect)frame item:(MSliderTabBarItem *)item {
    self = [super initWithFrame:frame]; {
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.font = [UIFont boldSystemFontOfSize:kMSliderTabBarFontSize];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:self.textLabel];
        
        self.item = item;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (void)setItem:(MSliderTabBarItem *)item {
    _item = item;
    [_item setValue:self forKey:@"sliderTabBarTab"];
    [self refreshLabel];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refreshLabel];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor) {
        self.textLabel.layer.borderColor = borderColor.CGColor;
        self.textLabel.layer.borderWidth = 1;
    }
    else {
        self.textLabel.layer.borderWidth = 0;
    }
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.textLabel.layer.borderColor];
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    [self.item setTitleTextAttributes:attributes forState:state];
}

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state {
    return [self.item titleTextAttributesForState:state];
}

- (void)refreshLabel {
    self.textLabel.text = self.item.title;
    
    NSDictionary *attributes = [self.item titleTextAttributesForState:self.state];
    self.textLabel.font = attributes[UITextAttributeFont];
    self.textLabel.textColor = attributes[UITextAttributeTextColor];
    self.textLabel.layer.shadowColor = [attributes[UITextAttributeTextShadowColor] CGColor];
    self.textLabel.layer.shadowOffset = [attributes[UITextAttributeTextShadowOffset] CGSizeValue];
}

@end


#pragma mark - MSliderTabBar

@interface MSliderTabBar ()
/** 所有页签 */
@property (nonatomic, copy) NSArray *tabs;
@property (nonatomic, strong) CALayer *selectionIndicatorLayer;
@end

@implementation MSliderTabBar
@dynamic delegate;
@synthesize selectionIndicatorImage = _selectionIndicatorImage;
@synthesize tintColor = _tintColor;

- (id)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if(self) {
        self.showsHorizontalScrollIndicator = self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.backgroundColor = [UIColor colorWithRed:41./255. green:41./255. blue:41./255. alpha:1];
        [self.layer addSublayer:self.selectionIndicatorLayer];
        [self.layer setNeedsDisplay];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    CGFloat monospacedWidth = 0;
    CGFloat totalWidth = [self contentWidth];
    if(totalWidth < viewWidth) {
        monospacedWidth = viewWidth / [self.tabs count];
    }
    
    CGFloat posX = 0;
//    UIFont *font = [UIFont boldSystemFontOfSize:kMSliderTabBarFontSize];
    NSInteger index = 0;
    for (MSliderTabBarItem *item in self.items) {
        MSliderTabBarTab *tab = self.tabs[index];
        CGFloat buttonWidth = 0;
        if(monospacedWidth > 0) {
            buttonWidth = monospacedWidth;
        } else {
            NSDictionary *titleTextAttributes = [tab titleTextAttributesForState:tab.state];
            UIFont *font = titleTextAttributes[UITextAttributeFont];
            CGSize size = [item.title sizeWithFont:font];
            buttonWidth = size.width + (kMSliderTabBarTabMargin * 2);
        }
        tab.frame = CGRectMake(posX, 0, buttonWidth, viewHeight);
        index++;
        posX += buttonWidth;
    }
    self.contentSize = CGSizeMake(posX, viewHeight);
    if (self.selectedItem) {
        MSliderTabBarTab *tab = self.tabs[[self.items indexOfObject:self.selectedItem]];
        self.selectionIndicatorLayer.frame = tab.frame;
    }
}

- (CGFloat)contentWidth {
    CGFloat totalWidth = 0;
    
    NSInteger index = 0;
    for(MSliderTabBarItem *item in self.items) {
        MSliderTabBarTab *tab = self.tabs[index];
        NSDictionary *titleTextAttributes = [tab titleTextAttributesForState:tab.state];
        UIFont *font = titleTextAttributes[UITextAttributeFont];
        CGSize size = [item.title sizeWithFont:font];
        totalWidth += size.width + (kMSliderTabBarTabMargin * 2);
        index++;
    }
    return totalWidth;
}

#pragma mark Drawing

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    UIColor *color = [UIColor colorWithRed:32./255. green:88./255. blue:203./255. alpha:1];
    if (self.selectionIndicatorColor) {
        color = self.selectionIndicatorColor;
    }
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextMoveToPoint(ctx, 0, CGRectGetHeight(layer.frame));
    CGContextAddLineToPoint(ctx, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
    CGContextStrokePath(ctx);
}

#pragma mark Getter & Setter
- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    _selectionIndicatorColor = selectionIndicatorColor;
    [self.layer setNeedsDisplay];
    self.selectionIndicatorImage = nil;
    self.selectionIndicatorLayer.contents = (__bridge id)(self.selectionIndicatorImage.CGImage);
}

- (CALayer *)selectionIndicatorLayer {
    if (!_selectionIndicatorLayer) {
        _selectionIndicatorLayer = [[CALayer alloc] init];
        _selectionIndicatorLayer.contents = (__bridge id)(self.selectionIndicatorImage.CGImage);
    }
    return _selectionIndicatorLayer;
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage {
    _selectionIndicatorImage = selectionIndicatorImage;
    self.selectionIndicatorLayer.contents = (__bridge CALayer *)(_selectionIndicatorImage.CGImage);
}

- (UIImage *)selectionIndicatorImage {
    if (!_selectionIndicatorImage) {
        CGSize size = CGSizeMake(10, 35);
        UIGraphicsBeginImageContext(size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(ctx, false);
        if (self.selectionIndicatorColor) {
        CGContextSetStrokeColorWithColor(ctx, self.selectionIndicatorColor.CGColor);
        } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:32./255. green:88./255. blue:203./255. alpha:1].CGColor);
        }
        CGContextSetLineWidth(ctx, 4.);
        CGContextMoveToPoint(ctx, 0, size.height - 0.5);
        CGContextAddLineToPoint(ctx, 10, size.height - 0.5);
        CGContextStrokePath(ctx);
        _selectionIndicatorImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _selectionIndicatorImage;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    self.backgroundColor = barTintColor;
}

- (UIColor *)barTintColor {
    return self.backgroundColor;
}

- (void)setItems:(NSArray *)items {
    _items = nil;
    _items = [items copy];
    self.selectedItem = nil;
    [self loadTabs];
}

- (void)setSelectedItem:(MSliderTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    _selectedItem = selectedItem;
    if (!_selectedItem) {
        return;
    }
    
    MSliderTabBarTab *tab = self.tabs[[self.items indexOfObject:self.selectedItem]];
    for (MSliderTabBarTab* t in self.tabs) {
        t.selected = (tab == t);
    }
    self.selectionIndicatorLayer.frame = tab.frame;
    [self correctPosition];
}

#pragma mark event

- (void)tabSelected:(MSliderTabBarTab *)tab {
    self.selectedItem = tab.item;
    if([self.delegate respondsToSelector:@selector(sliderTabBar:didSelectItem:)]) {
        [self.delegate sliderTabBar:self didSelectItem:[tab item]];
    }
}

#pragma mark private methods

- (void)loadTabs {
    for(MSliderTabBarTab *tab in self.tabs) {
        [tab removeFromSuperview];
    }
    
    NSMutableArray *tabs = [NSMutableArray array];
    for(MSliderTabBarItem *item in self.items) {
        MSliderTabBarTab *tab = [[MSliderTabBarTab alloc] initWithFrame:CGRectZero item:item];
        tab.backgroundColor = [UIColor clearColor];
        [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tabs addObject:tab];
        [self addSubview:tab];
    }
    self.tabs = tabs;
}

- (void)correctPosition {
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    MSliderTabBarTab *tab = self.tabs[[self.items indexOfObject:self.selectedItem]];
    CGFloat midX = CGRectGetMidX(tab.frame);
    CGFloat contentOffsetX = midX - (viewWidth / 2.);
    if(contentOffsetX < 0) {
        contentOffsetX = 0;
    } else if(contentOffsetX > (self.contentSize.width - viewWidth)) {
        contentOffsetX = (self.contentSize.width - viewWidth);
    }
    self.contentOffset = CGPointMake(contentOffsetX, 0);
}

@end
