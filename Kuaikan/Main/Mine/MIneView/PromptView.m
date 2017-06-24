//
//  PromptView.m
//  Kuaikan
//
//  Created by 少少 on 16/11/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "PromptView.h"

@interface PromptView ()

/**
 *  最底部的遮盖 ：屏蔽除菜单以外控件的事件
 */
@property (nonatomic, weak) UIButton *cover;

@end

@implementation PromptView


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
    backView.frame = CGRectMake((ScreenWidth - 300)/2, (ScreenHeight - 200)/2, 300, 200);
    backView.layer.masksToBounds = YES; //没这句话它圆不起来
    backView.layer.cornerRadius = 6.0;
    [cover addSubview:backView];
    
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.font = Font18;
    userLabel.numberOfLines = 0;
    userLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:userLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = Font18;
    titleLabel.numberOfLines = 0;
    
    
    CGFloat textLabelY = 0;
    if (_successOrFalse) {
        userLabel.frame = CGRectMake(25, 20, 250, 30);
        titleLabel.frame = CGRectMake(25, 60, 250, 30);
        userLabel.text = [NSString stringWithFormat:@"恭喜您(K%@),充值成功",_userIDStr];
        textLabelY = CGRectGetMaxY(titleLabel.frame) + 20;
        NSString *fiveStr = [NSString stringWithFormat:@"您的账户余额为%@看点",_resumainStr];
        NSMutableAttributedString *fiveStrs = [[NSMutableAttributedString alloc] initWithString:fiveStr];
        if (isNightView) {
            [fiveStrs addAttribute:NSForegroundColorAttributeName value:ADColor(100, 15, 15) range:NSMakeRange(7, _resumainStr.length + 2)];
        } else {
            [fiveStrs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, _resumainStr.length + 2)];
        }
        
        titleLabel.attributedText = fiveStrs;
    } else {
        titleLabel.frame = CGRectMake(0, 0, 0, 0);
        userLabel.frame = CGRectMake(25, 50, 250, 30);
        userLabel.text = [NSString stringWithFormat:@"很遗憾(K%@),充值失败",_userIDStr];
        textLabelY = CGRectGetMaxY(userLabel.frame) + 20;
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    

    UIButton *ensureBtn = [[UIButton alloc] init];
    ensureBtn.frame = CGRectMake(25, textLabelY, 250, 50);
    
    ensureBtn.titleLabel.font = Font20;
    ensureBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    ensureBtn.layer.cornerRadius = 4.0;
    [ensureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(ensureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:ensureBtn];
    
    if (isNightView) {
        backView.backgroundColor = ADColor(130, 130, 130);
        userLabel.textColor = ADColor(27, 27, 27);
        titleLabel.textColor = ADColor(27, 27, 27);
        [ensureBtn setTitleColor:ADColor(127, 127, 127) forState:UIControlStateNormal];
        ensureBtn.backgroundColor = ADColor(122, 60, 74);
    } else {
    
        backView.backgroundColor = ADColor(240, 240, 240);
        userLabel.textColor = TextColor;
        titleLabel.textColor = TextColor;
        [ensureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        ensureBtn.backgroundColor = ADColor(244, 121, 114);
    }

}

#pragma mark - 确定按钮的点击
- (void)ensureBtnClick{
    
   
    [self removeFromSuperview];
    
    
    if ([self.delegate respondsToSelector:@selector(ensureBtn:)]) {
        [self.delegate ensureBtn:_successOrFalse];
    }
}

#pragma mark - 内部方法
- (void)coverClick{
    
    [self dismiss];
}

- (void)dismiss{
    
//    if ([self.delegate respondsToSelector:@selector(ensureBtn)]) {
//        [self.delegate ensureBtn];
//    }
    
//    [self removeFromSuperview];
}
@end
