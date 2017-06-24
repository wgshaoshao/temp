//
//  LoginView.m
//  Kuaikan
//
//  Created by 少少 on 17/3/21.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}

- (void)creatView{

    // 添加菜单整体到窗口身上
    UIWindow *window= [AppDelegate sharedApplicationDelegate].window;
    [window addSubview:self];

    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    
    cover.tag = 10;
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(47 * KKuaikan, (ScreenHeight - 250 * KKuaikan) / 2, ScreenWidth - 94 * KKuaikan, 250 * KKuaikan);
//    view.backgroundColor = [uico
//                            ]
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    //722 620
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, ScreenWidth - 94 * KKuaikan, 205 * KKuaikan);
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"login-pic"];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"登录更安全,阅读记录可永久保存";
    titleLabel.font = Font16;
    titleLabel.textColor = WhiteColor;
    titleLabel.frame = CGRectMake(0, 205 * KKuaikan - 40, ScreenWidth - 94 * KKuaikan, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(ScreenWidth - 94 * KKuaikan - 40, 0, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:backBtn];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 205 * KKuaikan, ScreenWidth - 94 * KKuaikan, 45 * KKuaikan);
    [button setTitle:@"立即登录" forState:UIControlStateNormal];
    button.titleLabel.font = Font16;
    button.backgroundColor =  WhiteColor;
    [button setTitleColor:ADColor(139, 57, 190) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

- (void)buttonClick{
    
    if ([self.delegate respondsToSelector:@selector(loginViewBtnClick)]) {
        
        [self.delegate loginViewBtnClick];
    }

}

- (void)backBtnClick{

    [self removeFromSuperview];
}


@end
