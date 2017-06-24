//
//  MineTopView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/11.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "MineTopView.h"
#import "UIImageView+LBBlurredImage.h"

@implementation MineTopView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{
    
    //背景图片
    _backGroundImage = [[UIImageView alloc] init];
    _backGroundImage.userInteractionEnabled = YES;
//    backGroundImage.backgroundColor = ADColor(107, 142, 209);
    _backGroundImage.image = _headImage.image;
    _backGroundImage.frame = CGRectMake(0, 0, ScreenWidth, MineTopViewH);
    [self addSubview:_backGroundImage];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_cover_new"];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, 210);
    [_backGroundImage addSubview:imageView];
   
    CGFloat TopY = 45;

    _headImage = [[UIImageView alloc] init];
    _headImage.frame = CGRectMake(20 * KKuaikan, TopY, 70, 70);
    _headImage.userInteractionEnabled = YES;
//    [_headImage sd_setImageWithURL:[NSURL URLWithString:_headImage] placeholderImage:[UIImage imageNamed:@""]];
    _headImage.layer.masksToBounds = YES; //没这句话它圆不起来
    _headImage.layer.cornerRadius = 35.0; //设置图片圆角的尺度
    [_backGroundImage addSubview:_headImage];

    _iconBtn = [[UIButton alloc] init];
    _iconBtn.frame = CGRectMake(0, 0, 70, 70);
    [_iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headImage addSubview:_iconBtn];
    
    //昵称
    _nameLabel = [[UILabel alloc] init];
    CGFloat nameLabX = CGRectGetMaxX(_headImage.frame) + 12;
    _nameLabel.frame = CGRectMake(nameLabX, TopY, ScreenWidth - nameLabX, 20);
    _nameLabel.font = Font16;
    _nameLabel.textColor = WhiteColor;
    [_backGroundImage addSubview:_nameLabel];
    
    //用户ID
    _userIDLabel = [[UILabel alloc] init];
    CGFloat authorLabelY = CGRectGetMaxY(_nameLabel.frame) + 10;
    _userIDLabel.frame = CGRectMake(nameLabX, authorLabelY, ScreenWidth - nameLabX, 20);
    _userIDLabel.font = Font15;
    _userIDLabel.textColor = ADColor(204, 214, 237);
    [_backGroundImage addSubview:_userIDLabel];
    
    //余额
    _balanceLab = [[UILabel alloc] init];
    CGFloat balanceLabY = CGRectGetMaxY(_userIDLabel.frame);
    _balanceLab.frame = CGRectMake(nameLabX, balanceLabY, ScreenWidth - nameLabX, 20);
    _balanceLab.font = Font15;
    
    _balanceLab.textColor = ADColor(204, 214, 237);
    [_backGroundImage addSubview:_balanceLab];
    
    //登录
    _registBtn = [[UIButton alloc] init];
    _registBtn.frame = CGRectMake(ScreenWidth - 15 * KKuaikan - 80* KKuaikan, balanceLabY - 15, 80 * KKuaikan, 30);
    [_registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_registBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[UIImage imageNamed:@"me_btn_Sign-in_s"] forState:UIControlStateNormal];
    _registBtn.titleLabel.font = Font14;
    [_backGroundImage addSubview:_registBtn];
    
    //登录
    _refreshBtn = [[UIButton alloc] init];
    _refreshBtn.frame = CGRectMake(ScreenWidth - 27 - 40, balanceLabY - 15, 27, 27);
    [_refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_refreshBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"me_icon_refresh"] forState:UIControlStateNormal];
    _refreshBtn.titleLabel.font = Font14;
    [_backGroundImage addSubview:_refreshBtn];
}

- (void)registBtnClick{

    if ([self.delegate respondsToSelector:@selector(registButtonClick)]) {
        [self.delegate registButtonClick];
    }
}


- (void)iconBtnClick{

    if ([self.delegate respondsToSelector:@selector(iconButtonClick)]) {
        [self.delegate iconButtonClick];
    }
}

- (void)refreshBtnClick{

    if ([self.delegate respondsToSelector:@selector(refreshButtonClick)]) {
        [self.delegate refreshButtonClick];
    }
}

@end
