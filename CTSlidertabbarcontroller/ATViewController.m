//
//  ATViewController.m
//  CTSlidertabbarcontroller
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "ATViewController.h"
#import "RootViewController.h"
@interface ATViewController ()
@property (nonatomic, copy) NSArray *rankingInfos;
@property (nonatomic, copy) NSArray *rankingListViewControllers;
@property (nonatomic, copy) NSArray *categoryListViewControllers;
@property (nonatomic, copy) NSArray *categorytypeLists;
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];


//    [self createControllers];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"标题" style:UIBarButtonItemStyleDone target:self action:@selector(action)];
    self.navigationItem.rightBarButtonItem = item;
    
}
-(void)action{
    RootViewController *root = [[RootViewController alloc]init];
    [self.navigationController pushViewController: root animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
//    [self createControllers];
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
    self.selectedIndex = 1;
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
