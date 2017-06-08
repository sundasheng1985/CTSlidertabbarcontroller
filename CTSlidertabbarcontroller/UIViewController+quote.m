//
//  UIViewController+quote.m
//  CTSlidertabbarcontroller
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "UIViewController+quote.h"
#import <objc/runtime.h>
@implementation UIViewController (quote)

static char kUIViewControllerKeyNotifyTitle;

- (NSString *)notifyTitle {
    return objc_getAssociatedObject(self, &kUIViewControllerKeyNotifyTitle);
}

- (void)setNotifyTitle:(NSString *)notifyTitle {
    [self willChangeValueForKey:@"notifyTitle"];
    objc_setAssociatedObject(self, &kUIViewControllerKeyNotifyTitle, notifyTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"notifyTitle"];
}

@end
