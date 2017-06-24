//
//  EmptyRackView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "EmptyRackView.h"

@implementation EmptyRackView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        [self creatView];
    }
    return self;
}

- (void)creatView{

    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@""];
    iconImage.frame = CGRectMake((ScreenWidth - 50)/2, (ScreenHeight - 88 - 100 - 40 - 80 - 80)/2, 50, 50);
//    iconImage.backgroundColor = [UIColor brownColor];
    [self addSubview:iconImage];
    
    _titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"书城空荡荡的，快去书城挑本书看吧";
    _titleLabel.font = Font16;
    _titleLabel.textColor = ADColor(153, 153, 153);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat titleLabelY = CGRectGetMaxY(iconImage.frame) + 10;
    _titleLabel.frame = CGRectMake(0, titleLabelY, ScreenWidth, 20);
    [self addSubview:_titleLabel];
    _button = [[UIButton alloc] init];
    CGFloat buttonY = CGRectGetMaxY(_titleLabel.frame) + 10;
    _button.frame = CGRectMake((ScreenWidth - 150)/2, buttonY, 150, 40);
    [_button setTitle:@"去书城逛逛" forState:UIControlStateNormal];
    _button.backgroundColor = GreenColor;
    [_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    _button.titleLabel.font = Font15;
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

- (void)buttonClick{

    if ([self.delegate respondsToSelector:@selector(emptyRackViewBtnClick)]) {
        [self.delegate emptyRackViewBtnClick];
    }

}


@end
