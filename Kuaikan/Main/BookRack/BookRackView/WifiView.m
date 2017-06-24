//
//  WifiView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/23.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "WifiView.h"


@implementation WifiView


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
    self.frame = window.bounds;
    [window addSubview:self];
//    [window insertSubview:self belowSubview:[AppDelegate sharedApplicationDelegate].nightView];
    
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.backgroundColor = ADColorRGBA(60, 60, 60, 0.7);
    coverBtn.frame = self.frame;
    [self addSubview:coverBtn];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
    bottomView.backgroundColor = WhiteColor;
    [coverBtn addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"wifi传书";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.frame = CGRectMake(0, 0, ScreenWidth, 40);
    titleLabel.font = Font18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabY = CGRectGetMaxY(titleLabel.frame) + 0.5;
    lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
    lineLabel.backgroundColor = LineLabelColor;
    [bottomView addSubview:lineLabel];
    
    UILabel *ipContentLab = [[UILabel alloc] init];
    ipContentLab.frame = CGRectMake(0, lineLabY + 10, ScreenWidth, 20);
    ipContentLab.font = Font14;
    ipContentLab.textAlignment = NSTextAlignmentCenter;
    ipContentLab.text = @"在电脑浏览器地址栏输入";
    [bottomView addSubview:ipContentLab];
    
    
    _IPLabel = [[UILabel alloc] init];
    CGFloat ipLabelY = CGRectGetMaxY(ipContentLab.frame) + 5;
    _IPLabel.frame = CGRectMake(0, ipLabelY, ScreenWidth, 20);
    _IPLabel.textAlignment = NSTextAlignmentCenter;
    _IPLabel.font = Font14;
    [bottomView addSubview:_IPLabel];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    CGFloat promptLabY = CGRectGetMaxY(_IPLabel.frame) + 20;
    promptLabel.frame = CGRectMake(10, promptLabY, ScreenWidth - 20, 40);
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = Font14;
    promptLabel.text = @"确保你的手机和电脑在同一局域网，上传过程中，请勿离开此页面或锁屏";
    promptLabel.numberOfLines = 0;
    [bottomView addSubview:promptLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    CGFloat closeBtnY = CGRectGetMaxY(promptLabel.frame) + 15;
    closeBtn.frame = CGRectMake(10, closeBtnY, ScreenWidth - 20, 40);
    closeBtn.backgroundColor = ADColor(220, 220, 220);
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeBtn];
}

- (void)closeBtnClick{

//    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(popMenuDidDismissed)]) {
        [self.delegate popMenuDidDismissed];
    }
}

@end
