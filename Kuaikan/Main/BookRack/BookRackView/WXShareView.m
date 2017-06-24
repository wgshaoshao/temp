//
//  WXShareView.m
//  Kuaikan
//
//  Created by 少少 on 16/12/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "WXShareView.h"

@implementation WXShareView

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
//    self.frame = window.bounds;
    [window addSubview:self];
//    [window insertSubview:self belowSubview:[AppDelegate sharedApplicationDelegate].nightView];
    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    [cover addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cover.tag = 10;
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
    
    [cover addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"分享到";
    titleLabel.font = Font18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, ScreenWidth, 40);
    
    [backView addSubview:titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabelY = CGRectGetMaxY(titleLabel.frame);
    
    lineLabel.frame = CGRectMake(0, lineLabelY, ScreenWidth, 0.5);
    [backView addSubview:lineLabel];
    
    UIButton *wxCircle = [[UIButton alloc] init];
    [wxCircle addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat WXButtonY = CGRectGetMaxY(lineLabel.frame) + 20;
    wxCircle.tag = 11;
    wxCircle.frame = CGRectMake((ScreenWidth - 200)/2, WXButtonY, 80, 60 + 30);
    [backView addSubview:wxCircle];
    
    UIImageView *circleImage = [[UIImageView alloc] init];
    circleImage.frame = CGRectMake(10, 0, 60, 60);
    
    [wxCircle addSubview:circleImage];
    
    UILabel *circleLabel = [[UILabel alloc] init];
    CGFloat circleLabelY = CGRectGetMaxY(circleImage.frame) + 10;
    circleLabel.frame = CGRectMake(0, circleLabelY, 80, 20);
    circleLabel.text = @"微信朋友圈";
    circleLabel.font = Font14;
    circleLabel.textAlignment = NSTextAlignmentCenter;
    
    [wxCircle addSubview:circleLabel];
    
    UIButton *wxFirend = [[UIButton alloc] init];
    [wxFirend addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    wxFirend.frame = CGRectMake((ScreenWidth + 80)/2, WXButtonY, 80, 60 + 30);
    wxFirend.tag = 12;
    [backView addSubview:wxFirend];
    
    UIImageView *friendImage = [[UIImageView alloc] init];
    friendImage.frame = CGRectMake(10, 0, 60, 60);
    
    [wxFirend addSubview:friendImage];
    
    UILabel *friendLabel = [[UILabel alloc] init];
    friendLabel.frame = CGRectMake(0, circleLabelY, 80, 20);
    friendLabel.text = @"微信好友";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    friendLabel.font = Font14;
    
    [wxFirend addSubview:friendLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
   
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font16;
    cancelBtn.tag = 10;
    CGFloat cancelBtnY = CGRectGetMaxY(wxFirend.frame) + 20;
    cancelBtn.frame = CGRectMake(20, cancelBtnY, ScreenWidth - 40, 50);
    
    [cancelBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
   
    if (isNightView) {
        backView.backgroundColor = ADColor(127, 127, 127);
        titleLabel.textColor = ADColor(53, 53, 53);
        lineLabel.backgroundColor = ADColor(110, 110, 110);
        circleLabel.textColor = ADColor(53, 53, 53);
        friendLabel.textColor = ADColor(53, 53, 53);
        [cancelBtn setTitleColor:ADColor(53, 53, 53) forState:UIControlStateNormal];
         cancelBtn.backgroundColor = ADColor(115, 115, 115);
        friendImage.image = [UIImage imageNamed:@"night_wechat"];
        circleImage.image = [UIImage imageNamed:@"night_circle_friend"];
    } else {
    
        backView.backgroundColor = WhiteColor;
        titleLabel.textColor = LightTextColor;
        lineLabel.backgroundColor = LineLabelColor;
        circleLabel.textColor = LightTextColor;
        friendLabel.textColor = LightTextColor;
        [cancelBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
        cancelBtn.backgroundColor = ADColor(238, 238, 238);
        friendImage.image = [UIImage imageNamed:@"common_icom_WeChat_n"];
        circleImage.image = [UIImage imageNamed:@"common_icom_Circle-of-friends_n"];
    }
}

- (void)showShareView{

    CGRect newFrame = self.frame;
    newFrame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dissShareView{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = ScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}

//微信朋友圈、微信好友、取消
- (void)threeBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(WXShareBtnClick:)]) {
        
        [self.delegate WXShareBtnClick:button];
    
    }
}



@end
