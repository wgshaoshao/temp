//
//  ViewController.h
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : BaseViewController

@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootTabBarController *mainTabBarController;
@property (strong, nonatomic) UIView *nightView;

@end

