//
//  BaseViewController.h
//  Kuaikan
//
//  Created by fangshufeng on 16/9/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RootTabBarController.h"
#import "BookCityHomeController.h"
#import "BookRackHomeController.h"
#import "MineHomeController.h"
#import "BaseNavgationViewController.h"
//#import "FreeH5Controller.h"
@interface RootTabBarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabBarController

#pragma mark - life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BookRackHomeController *bookRackVC = [[BookRackHomeController alloc] init];
    BaseNavgationViewController *nav1  =[[BaseNavgationViewController alloc]initWithRootViewController:bookRackVC];
    
    BookCityHomeController *bookCityVC = [[BookCityHomeController alloc] init];
    BaseNavgationViewController *nav2  =[[BaseNavgationViewController alloc]initWithRootViewController:bookCityVC];
    
    MineHomeController *mineVC = [[MineHomeController alloc] init];
    BaseNavgationViewController *nav3  =[[BaseNavgationViewController alloc]initWithRootViewController:mineVC];
   
    NSArray *navArry = @[nav1,nav2,nav3];
    self.viewControllers = navArry;
    
    CGRect frame = CGRectMake(0.0, 0, ScreenWidth, self.tabBar.bounds.size.height);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar insertSubview:v atIndex:0];
    
//    FreeH5Controller *freeVC = [[FreeH5Controller alloc] init];
//    [self.navigationController pushViewController:freeVC animated:YES];
    
    NSArray *tabTitleArray = [NSArray arrayWithObjects:@"书架",@"书城",@"我的", nil];
    for(int i=0; i<navArry.count;i++) {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        UIImage *norimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_nor_%d",i]];
        UIImage *selimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_sel_%d",i]];
        tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -5);
        tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        tabBarItem.title = tabTitleArray[i];
        norimg = [norimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selimg = [selimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.image = norimg;
        tabBarItem.selectedImage = selimg;
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    [self.tabBar setTintColor:[UIColor whiteColor]];

}


@end
