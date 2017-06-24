//
//  BaseViewController.m
//  Kuaikan
//
//  Created by fangshufeng on 16/9/10.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavBar];
}

- (void)configNavBar {
    
    self.navigationController.navigationBar.barTintColor = NavigationColor;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle=  UIBarStyleBlack;
    self.navigationController.navigationBar.alpha = 1.0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)settingViewFrame
{
    CGRect viewFrame = [UIScreen mainScreen].bounds;
    
    if ((nil != self.navigationController)&& (NO == self.navigationController.navigationBarHidden)) {
        
        viewFrame.size.height -= (64);
    }
    [self.view setFrame:viewFrame];
}

@end
