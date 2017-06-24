//
//  HotStrawView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "HotStrawView.h"

@implementation HotStrawView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.backgroundColor = WhiteColor;
        
        [self creatView];
    }
    return self;
}

- (void)creatView{

    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(10, 5, ScreenWidth - 20, 34);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = WhiteColor;
    [self addSubview:button];
    
    UIButton *hotLabel = [[UIButton alloc] init];
    hotLabel.frame = CGRectMake(6, 8, 35, 19);
    [hotLabel setBackgroundImage:[UIImage imageNamed:@"bookshelf_Know"] forState:UIControlStateNormal];
    [hotLabel setTitle:@"热荐" forState:UIControlStateNormal];
    [hotLabel setTitleColor:WhiteColor forState:UIControlStateNormal];
    hotLabel.titleLabel.font = Font12;
//    hotLabel.backgroundColor = ADColor(238, 117, 53);
//    hotLabel.text = @"热荐";
//    hotLabel.font = Font13;
//    hotLabel.textColor = WhiteColor;
//    hotLabel.textAlignment = NSTextAlignmentCenter;
    [button addSubview:hotLabel];
    
    _titleLabel = [[UILabel alloc] init];
    CGFloat titleLabelX = CGRectGetMaxX(hotLabel.frame) + 10;
    _titleLabel.frame = CGRectMake(titleLabelX, 5, ScreenWidth - 20 - 6 - 30 - 30, 25);
    _titleLabel.font = Font15;
    _titleLabel.textColor = LightTextColor;
    [button addSubview:_titleLabel];
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.image = [UIImage imageNamed:@"bookshelf_icon"];
    arrowImage.frame = CGRectMake(ScreenWidth - 20 - 10 - 10, 12, 10, 10);
    [button addSubview:arrowImage];
}

- (void)buttonClick{

    if ([self.delegate respondsToSelector:@selector(hotStrawViewBtnClick)]) {
        [self.delegate hotStrawViewBtnClick];
    }
}

@end
