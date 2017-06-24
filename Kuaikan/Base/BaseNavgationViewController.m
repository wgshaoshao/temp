//
//  BaseNavgationViewController.m
//  Kuaikan
//
//  Created by fangshufeng on 16/9/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BaseNavgationViewController.h"

@implementation BaseNavgationViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
