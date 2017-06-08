//
//  RootViewController.m
//  CTSlidertabbarcontroller
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, copy) NSArray *rankingInfos;
@property (nonatomic, copy) NSArray *rankingListViewControllers;
@property (nonatomic, copy) NSArray *categoryListViewControllers;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor grayColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [self createControllers];
}
- (NSArray *)rankingInfos {
    if (!_rankingInfos) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Rankings" ofType:@"json"];
        _rankingInfos = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    }
    return _rankingInfos;
}

- (NSArray *)rankingListViewControllers {
    if (!_rankingListViewControllers) {
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (NSDictionary *info in self.rankingInfos) {
            Class class = NSClassFromString(info[@"class"]);
            UIViewController *viewController = [[class alloc] init];
            if ([viewController isKindOfClass:[UIViewController class]]) {
                viewController.sliderTabBarItem.title = info[@"name"];
//                viewController.notifyTitle = info[@"name"];
                [viewController setValue:info[@"name"] forKey:@"notifyTitle"];
                [viewController setValue:info[@"file"] forKey:@"JSONFilename"];
                [viewControllers addObject:viewController];
            }
        }
        _rankingListViewControllers = [viewControllers copy];
    }
    return _rankingListViewControllers;
}

-(void)createControllers{
    self.viewControllers = self.rankingListViewControllers;
    self.selectedIndex = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
