//
//  BackRackView.m
//  Kuaikan
//
//  Created by 少少 on 16/7/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BackRackView.h"

@interface BackRackView ()

/**
 *  最底部的遮盖 ：屏蔽除菜单以外控件的事件
 */
@property (nonatomic, weak) UIButton *cover;

@end


@implementation BackRackView

#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame
{
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

    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = self.frame;
    [self addSubview:cover];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake((ScreenWidth - 300)/2, (ScreenHeight - 150)/2, 300, 150);
    backView.layer.masksToBounds = YES; //没这句话它圆不起来
    backView.layer.cornerRadius = 6.0;
    
    [cover addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 20, 300, 30);
    titleLabel.font = Font18;
    titleLabel.textColor = TextColor;
    titleLabel.text = @"是否加入书架？";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    textLabel.text = @"选择加入书架可以更方便从书架阅读";
    textLabel.font = Font14;
    textLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat textLabelY = CGRectGetMaxY(titleLabel.frame) + 10;
    textLabel.frame = CGRectMake(0, textLabelY, 300, 20);
    [backView addSubview:textLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = Font15;
    CGFloat cancelBtnY = CGRectGetMaxY(textLabel.frame) + 15;
    cancelBtn.frame = CGRectMake(20, cancelBtnY, 115, 40);
  
    
    cancelBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    cancelBtn.layer.cornerRadius = 4.0;
    [cancelBtn setTitleColor:TextColor forState:UIControlStateNormal];
    [backView addSubview:cancelBtn];
    
    UIButton *ensureBtn = [[UIButton alloc] init];
    ensureBtn.frame = CGRectMake(165, cancelBtnY, 115, 40);
    
    
    ensureBtn.titleLabel.font = Font15;
    ensureBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    ensureBtn.layer.cornerRadius = 4.0;
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    if (isNightView) {
        ensureBtn.backgroundColor = ADColor(121, 60, 58);
        [ensureBtn setTitleColor:ADColor(127, 127,127) forState:UIControlStateNormal];
        cancelBtn.backgroundColor = ADColor(127, 127, 127);
        textLabel.textColor = ADColor(53, 53, 53);
        backView.backgroundColor = ADColor(120, 120, 120);
    } else {
        ensureBtn.backgroundColor = ADColor(244, 121, 114);
        [ensureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        cancelBtn.backgroundColor = WhiteColor;
        textLabel.textColor = LightTextColor;
        backView.backgroundColor = ADColor(240, 240, 240);
    }
    [ensureBtn addTarget:self action:@selector(ensureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:ensureBtn];
}


#pragma mark - 确定按钮的点击
- (void)ensureBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(backRackViewEnsureBtnClick)]) {
        [self.delegate backRackViewEnsureBtnClick];
    }
}



#pragma mark - 取消按钮的点击
- (void)cancelBtnClick{

    if ([self.delegate respondsToSelector:@selector(backRackViewCancelBtnClick)]) {
        [self.delegate backRackViewCancelBtnClick];
    }
}

#pragma mark - 内部方法
- (void)coverClick{
   
    [self dismiss];
}

- (void)dismiss{
    
    
    [self removeFromSuperview];
}


@end
