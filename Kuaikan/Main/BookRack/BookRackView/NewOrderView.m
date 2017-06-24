//
//  NewOrderView.m
//  Kuaikan
//
//  Created by 少少 on 16/7/14.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "NewOrderView.h"

@implementation NewOrderView

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
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, ScreenHeight - 340, ScreenWidth, 340);
    
    [coverBtn addSubview:_bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"图书订单";
    
    titleLabel.frame = CGRectMake(10, 0, ScreenWidth - 100, 40);
    titleLabel.font = Font18;
    [_bottomView addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(ScreenWidth - 40 - 10, 0, 50, 40);
    //    closeBtn.backgroundColor = ADColor(220, 220, 220);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_delete@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:closeBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabY = CGRectGetMaxY(titleLabel.frame) + 0.5;
    lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
    
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
    
    _autoButton = [[UIButton alloc] init];
    CGFloat autoBtnY = CGRectGetMaxY(_priceLabel.frame) + 5;
    _autoButton.frame = CGRectMake(0, autoBtnY, ScreenWidth - 200, 40);
    _autoButton.tag = 10;
    [_autoButton addTarget:self action:@selector(autoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_autoButton];
    
    _autoImageView = [[UIImageView alloc] init];
    _autoImageView.frame = CGRectMake(10, 12, 15, 15);
    
    [_autoButton addSubview:_autoImageView];
    
    _autoLabel = [[UILabel alloc] init];
    CGFloat autoLabelX = CGRectGetMaxX(_autoImageView.frame) + 5;
    _autoLabel.frame = CGRectMake(autoLabelX, 10, ScreenWidth - autoLabelX,20);
    NSString *oneLabelStr = @"自动订购下一章  在菜单-设置可取消自动购买";
    NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
    
    
    _autoLabel.font = Font13;
    [_autoButton addSubview:_autoLabel];
    
    _propmtLabel = [[UILabel alloc] init];
    CGFloat propmtLabY = CGRectGetMaxY(_autoButton.frame) + 10;
    _propmtLabel.frame = CGRectMake(10,propmtLabY , ScreenWidth - 20, 15);
    _propmtLabel.text = @"批量购买的章节，可享受离线阅读";
    _propmtLabel.font = Font13;
    [_bottomView addSubview:_propmtLabel];
    
    CGFloat moneyBtnX = 10;
//    CGFloat moneyBtnW = (ScreenWidth - 3 * moneyBtnX) / 2;
    CGFloat moneyBtnH = 60;
    
    CGFloat fiveBtnY = CGRectGetMaxY(_propmtLabel.frame) + moneyBtnX;
    _fiveBtn = [[NewButton alloc] initWithFrame:CGRectMake(moneyBtnX, fiveBtnY, ScreenWidth - 20, moneyBtnH)];
    _fiveBtn.isFirstBtn = NO;
    [_fiveBtn creatView];
    _fiveBtn.delegate = self;
    _fiveBtn.isSected = YES;
    _fiveBtn.layer.borderWidth = 1.0;
    
    _fiveBtn.titleLab.hidden = YES;
    [_bottomView addSubview:_fiveBtn];
    
    
    
    _remarkLabel = [[UILabel alloc] init];
    CGFloat remarkLabY = CGRectGetMaxY(_fiveBtn.frame) + 10 + moneyBtnX ;
    _remarkLabel.frame = CGRectMake(10, remarkLabY, ScreenWidth - 10, 15);
    _remarkLabel.font = Font13;
    
    [_bottomView addSubview:_remarkLabel];
    
    _ensureBtn = [[EnsureButton alloc] init];
    _ensureBtn.frame = CGRectMake(130, 280, ScreenWidth - 130, 60);
    [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [_ensureBtn addTarget:self action:@selector(ensureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:_ensureBtn];
    
    UIView *allView = [[UIView alloc] init];
    allView.frame = CGRectMake(0, 280, 130, 60);
    [_bottomView addSubview:allView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(130, 0.5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 1;
    
    layer.path = path.CGPath;
    [allView.layer addSublayer:layer];
    
    _allLabel = [[UILabel alloc] init];
    _allLabel.frame = CGRectMake(0, 12, 130, 15);
    
    _allLabel.font = Font13;
    _allLabel.textAlignment = NSTextAlignmentCenter;
    [allView addSubview:_allLabel];
    
    _balanceLabel = [[UILabel alloc] init];
    _balanceLabel.font = Font13;
    CGFloat balanceLabY = CGRectGetMaxY(_allLabel.frame) + 3;
    _balanceLabel.frame = CGRectMake(0, balanceLabY, 130, 15);
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
        [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(75, 75, 75) range:NSMakeRange(8, 14)];
        _autoLabel.attributedText = oneLabelStrs;
        _autoImageView.image = [UIImage imageNamed:@"night_bookshelf_btn_s"];
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
        [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(150, 150, 150) range:NSMakeRange(8, 14)];
        _autoLabel.attributedText = oneLabelStrs;
        _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_s"];
    }
}

#pragma mark - 选择的金额
- (void)rechareButtonClick:(UIButton *)button{
    NSString *titleStr = nil;
    
    _fiveBtn.isSected = YES;
    _orderDict = _fiveBtn.oneDict;
    
    titleStr = _fiveBtn.bottomLabel.text;
        
    _allLabel.text = [NSString stringWithFormat:@"合计：%@",titleStr];
}

#pragma mark - 自动订购下一章节
- (void)autoBtnClick:(UIButton *)button{
    
    if (_autoButton.tag == 10) {
        _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_n"];
        _autoButton.tag = 20;
    } else {
        if (isNightView) {
            _autoImageView.image = [UIImage imageNamed:@"night_bookshelf_btn_s"];
        } else {
            _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_s"];
        }
        
        _autoButton.tag = 10;
    }
    
    if ([self.delegate respondsToSelector:@selector(newOrderViewAutoBuyBtnClick:)]) {
        [self.delegate newOrderViewAutoBuyBtnClick:button];
    }
}

#pragma mark - 确认
- (void)ensureClick:(EnsureButton *)button{
    
    button.ensureDict = _orderDict;
    
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(newOrderViewEnsureBtnClick:)]) {
        [self.delegate newOrderViewEnsureBtnClick:button];
    }
}

#pragma mark - 关闭窗口
- (void)closeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(newOrderViewCancelBtnClick)]) {
        [self.delegate newOrderViewCancelBtnClick];
    }
    

    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    self.bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
   
}

@end
