//
//  TwoOrderView.m
//  Kuaikan
//
//  Created by 少少 on 16/7/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "TwoOrderView.h"

@implementation TwoOrderView

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
    
    _coverBtn = [[UIButton alloc] init];
    _coverBtn.backgroundColor = ADColorRGBA(60, 60, 60, 0.7);
    _coverBtn.frame = self.frame;
    [self addSubview:_coverBtn];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, ScreenHeight - 310, ScreenWidth, 310);
    _bottomView.backgroundColor = WhiteColor;
    [_coverBtn addSubview:_bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"图书订单";
//    titleLabel.textColor = [UIColor blackColor];
    titleLabel.frame = CGRectMake(10, 0, ScreenWidth - 100, 40);
    titleLabel.font = Font18;
    [_bottomView addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(ScreenWidth - 40 - 10, 0, 50, 40);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_delete@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:closeBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabY = CGRectGetMaxY(titleLabel.frame) + 0.5;
    lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
//    lineLabel.backgroundColor = LineLabelColor;
    [_bottomView addSubview:lineLabel];
    
    _chaperNameLab = [[UILabel alloc] init];
    _chaperNameLab.font = Font15;
    CGFloat chaperLabY = CGRectGetMaxY(lineLabel.frame) + 10;
    _chaperNameLab.frame = CGRectMake(10, chaperLabY, ScreenWidth - 20, 15);
    [_bottomView addSubview:_chaperNameLab];
    
    _priceLabel = [[UILabel alloc] init];
    CGFloat peicrLabelY = CGRectGetMaxY(_chaperNameLab.frame) + 10;
    _priceLabel.frame = CGRectMake(10, peicrLabelY, ScreenWidth - 20, 15);
    _priceLabel.font = Font15;
    [_bottomView addSubview:_priceLabel];
    
    
    _propmtLabel = [[UILabel alloc] init];
    CGFloat propmtLabY = CGRectGetMaxY(_priceLabel.frame) + 20;
    _propmtLabel.frame = CGRectMake(10,propmtLabY , ScreenWidth - 20, 15);
    _propmtLabel.text = @"批量购买的章节，可享受离线阅读";
    _propmtLabel.font = Font13;
    [_bottomView addSubview:_propmtLabel];
    
    CGFloat moneyBtnX = 10;
    CGFloat moneyBtnW = (ScreenWidth - 3 * moneyBtnX) / 2;
    CGFloat moneyBtnH = 60;
    
    CGFloat fiveBtnY = CGRectGetMaxY(_propmtLabel.frame) + moneyBtnX;
    _fiveBtn = [[RechareButton alloc] initWithFrame:CGRectMake(moneyBtnX, fiveBtnY, moneyBtnW, moneyBtnH)];
    _fiveBtn.isFirstBtn = YES;
    [_fiveBtn creatView];
    _fiveBtn.delegate = self;
    _fiveBtn.tag = 10;
    _fiveBtn.isSected = YES;
//    _fiveBtn.backgroundColor = WhiteColor;
    _fiveBtn.layer.borderWidth = 1.0;
//    _fiveBtn.layer.borderColor = ADColor(228, 143, 57).CGColor;
//    _fiveBtn.titleLab.hidden = YES;
    [_bottomView addSubview:_fiveBtn];
    
    CGFloat tenBtnX = CGRectGetMaxX(_fiveBtn.frame) + moneyBtnX;
    _tenBtn = [[RechareButton alloc] initWithFrame:CGRectMake(tenBtnX, fiveBtnY, moneyBtnW, moneyBtnH)];
    _tenBtn.isFirstBtn = YES;
    [_tenBtn creatView];
    _tenBtn.delegate = self;
    _tenBtn.tag = 11;
    _tenBtn.hidden = YES;
    [_bottomView addSubview:_tenBtn];
    
    
    _remarkLabel = [[UILabel alloc] init];
    CGFloat remarkLabY = CGRectGetMaxY(_fiveBtn.frame) + 10 + moneyBtnX;
    _remarkLabel.frame = CGRectMake(10, remarkLabY, ScreenWidth - 10, 15);
    _remarkLabel.font = Font13;
//    _remarkLabel.textColor = LightTextColor;
    [_bottomView addSubview:_remarkLabel];
    
    _ensureBtn = [[EnsureButton alloc] init];
    _ensureBtn.frame = CGRectMake(130, 250, ScreenWidth - 130, 60);
    [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [_ensureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_ensureBtn addTarget:self action:@selector(ensureClick:) forControlEvents:UIControlEventTouchUpInside];
//    _ensureBtn.backgroundColor = ADColor(228, 143, 57);
    [_bottomView addSubview:_ensureBtn];
    
    UIView *allView = [[UIView alloc] init];
    allView.frame = CGRectMake(0, 250, 130, 60);
    [_bottomView addSubview:allView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(130, 0.5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 1;
//    layer.strokeColor = ADColor(228, 143, 57).CGColor;
//    layer.fillColor = ADColor(228, 143, 57).CGColor;
    layer.path = path.CGPath;
    [allView.layer addSublayer:layer];
    
    _allLabel = [[UILabel alloc] init];
    _allLabel.frame = CGRectMake(0, 12, 130, 15);
//    _allLabel.textColor = ADColor(228, 143, 57);
    _allLabel.font = Font13;
    _allLabel.textAlignment = NSTextAlignmentCenter;
    [allView addSubview:_allLabel];
    
    _balanceLabel = [[UILabel alloc] init];
    _balanceLabel.font = Font13;
    CGFloat balanceLabY = CGRectGetMaxY(_allLabel.frame) + 3;
    _balanceLabel.frame = CGRectMake(0, balanceLabY, 130, 15);
//    _balanceLabel.textColor = LightTextColor;
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    [allView addSubview:_balanceLabel];
    
    if (isNightView) {
        _bottomView.backgroundColor = ADColor(127, 127, 127);
        titleLabel.textColor = ADColor(27, 27, 27);
        _balanceLabel.textColor = ADColor(53, 53, 53);
        _allLabel.textColor = ADColor(113, 71, 32);
        layer.strokeColor = ADColor(113, 71, 32).CGColor;
        layer.fillColor = ADColor(113, 71, 32).CGColor;
        _ensureBtn.backgroundColor = ADColor(113, 71, 32);
        _remarkLabel.textColor = ADColor(53, 53, 53);
        _fiveBtn.backgroundColor = ADColor(127, 127, 127);
        _fiveBtn.layer.borderColor = ADColor(113, 71, 32).CGColor;
        [_ensureBtn setTitleColor:ADColor(127, 127, 127) forState:UIControlStateNormal];
        _remarkLabel.textColor = ADColor(53, 53, 53);
        lineLabel.backgroundColor = ADColor(110, 110, 110);
        //                [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(75, 75, 75) range:NSMakeRange(8, 14)];
        //                _autoLabel.attributedText = oneLabelStrs;
//        _autoImageView.image = [UIImage imageNamed:@"night_bookshelf_btn_s"];
    } else {
        _bottomView.backgroundColor = WhiteColor;
        titleLabel.textColor = TextColor;
        _balanceLabel.textColor = LightTextColor;
        _allLabel.textColor = ADColor(228, 143, 57);
        layer.strokeColor = ADColor(228, 143, 57).CGColor;
        layer.fillColor = ADColor(228, 143, 57).CGColor;
        _ensureBtn.backgroundColor = ADColor(228, 143, 57);
        _remarkLabel.textColor = LightTextColor;
        _fiveBtn.backgroundColor = WhiteColor;
        _fiveBtn.layer.borderColor = ADColor(228, 143, 57).CGColor;
        [_ensureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _remarkLabel.textColor = LightTextColor;
        lineLabel.backgroundColor = LineLabelColor;
        //        [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(150, 150, 150) range:NSMakeRange(8, 14)];
        //        _autoLabel.attributedText = oneLabelStrs;
//        _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_s"];
    }

}

#pragma mark - 选择的金额
- (void)rechareButtonClick:(UIButton *)button{
    NSString *titleStr = nil;
    if (button.tag == 10) {//5元
        _fiveBtn.isSected = YES;
        _tenBtn.isSected = NO;
        _orderDict = _fiveBtn.oneDict;
        titleStr = _fiveBtn.bottomLabel.text;
        
    } else if (button.tag == 11) {//10元
        _fiveBtn.isSected = NO;
        _tenBtn.isSected = YES;
        _orderDict = _tenBtn.oneDict;
        titleStr = _tenBtn.bottomLabel.text;
        
    }
    _allLabel.text = [NSString stringWithFormat:@"合计：%@",titleStr];
}


#pragma mark - 确认
- (void)ensureClick:(EnsureButton *)button{
    
    button.ensureDict = _orderDict;
    
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(twoOrderViewEnsureBtnClick:)]) {
        [self.delegate twoOrderViewEnsureBtnClick:button];
    }
}

#pragma mark - 关闭窗口
- (void)closeBtnClick{
    
   // if ([self.delegate respondsToSelector:@selector(twoOrderViewCancelBtnClick)]) {
        [self.delegate twoOrderViewCancelBtnClick];
    //}
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    self.bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    //    [self removeFromSuperview];
    
}


@end
