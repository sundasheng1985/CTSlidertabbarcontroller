//
//  RankingListViewController.m
//  CTSlidertabbarcontroller
//
//  Created by 孙玉震 on 16/9/27.
//  Copyright © 2016年 孙玉震. All rights reserved.
//

#import "RankingListViewController.h"

@interface RankingListViewController ()

@end

@implementation RankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.navigationBar.translucent = NO;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
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
