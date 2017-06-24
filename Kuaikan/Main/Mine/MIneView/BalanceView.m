//
//  BalanceView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BalanceView.h"

@implementation BalanceView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"账户余额";
    titleLabel.font = Font16;
    titleLabel.textColor = ADColor(153, 153, 153);
    titleLabel.frame = CGRectMake(20, 20, 100, 20);
    [self addSubview:titleLabel];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.frame = CGRectMake(ScreenWidth - 60 - 200, 20, 200, 20);
    _numberLabel.font = Font14;
    _numberLabel.textColor = LightTextColor;
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numberLabel];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"me_recharge_refresh"] forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenWidth - 45, 17.5, 25, 25);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];


}

//刷新
- (void)buttonClick{

    if ([self.delegate respondsToSelector:@selector(balanceViewRefreshBtn)]) {
        [self.delegate balanceViewRefreshBtn];
    }
}




@end
