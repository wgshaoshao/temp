//
//  ViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ViewController.h"
#import "FreeH5Controller.h"
#import "BookDetailController.h"
#import "H5ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL isAhead;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat kkuaikan = (ScreenHeight / 667);
    
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlStr"];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, -64, ScreenWidth, ScreenHeight);
    if (urlStr.length) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""]];
    } else {
        imageView.image = [UIImage imageNamed:@"aa_loading.jpg"];
    }
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    _button = [[UIButton alloc] init];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    _button.frame = CGRectMake(0, -64, ScreenWidth, ScreenHeight);
    [imageView addSubview:_button];
    
    UIImageView *bootomImage = [[UIImageView alloc] init];

    if (kkuaikan == 1) {//6
        bootomImage.image = [UIImage imageNamed:@"750-1334.png"];
    } else if (kkuaikan > 1) {//6p
        if (ScreenHeight > 1000) {
            bootomImage.image = [UIImage imageNamed:@"1536-2048.png"];
        } else {
            bootomImage.image = [UIImage imageNamed:@"1080-1920.png"];
        }

    } else if (kkuaikan < 1) {//5
         bootomImage.image = [UIImage imageNamed:@"640-1136.png"];
    }
    
    bootomImage.frame = CGRectMake(0, ScreenHeight - 60 * kkuaikan - 64, ScreenWidth, 60 * kkuaikan);
    
    [self.view addSubview:bootomImage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!_isAhead) {
            BOOL isGotoWheelPicturVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGotoWheelPicturVC"] boolValue];
            if (!isGotoWheelPicturVC) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoWheelPictur" object:self];
            } else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"enterMain" object:self];
            }
        }
    });
}

//跳转到指定控制器
- (void)buttonClick{
    
    _button.enabled = NO;

    RootTabBarController *rootTab = [[RootTabBarController alloc]init];
    [AppDelegate sharedApplicationDelegate].window.rootViewController = rootTab;
 
    [[AppDelegate sharedApplicationDelegate].window makeKeyAndVisible];
    [AppDelegate sharedApplicationDelegate].mainTabBarController = rootTab;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGFloat nightAlpha = [[userDefaults objectForKey:@"NightAlpha"] floatValue];
    _isAhead = YES;
    
    [userDefaults setObject:@(YES) forKey:@"isloadingJump"];
    
    [AppDelegate sharedApplicationDelegate].nightView.backgroundColor = [UIColor blackColor];
    [AppDelegate sharedApplicationDelegate].nightView.alpha = nightAlpha;
    [AppDelegate sharedApplicationDelegate].nightView.userInteractionEnabled = NO;
    [[AppDelegate sharedApplicationDelegate].window addSubview:[AppDelegate sharedApplicationDelegate].nightView];

}


@end
