//
//  OrderView.m
//  Kuaikan
//
//  Created by 少少 on 16/5/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

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
    _bottomView.frame = CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400);
//    _bottomView.backgroundColor = WhiteColor;
    [_coverBtn addSubview:_bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"图书订单";
//    titleLabel.textColor = [UIColor blackColor];
    titleLabel.frame = CGRectMake(10, 0, ScreenWidth - 100, 40);
    titleLabel.font = Font18;
    [_bottomView addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 40);
//    closeBtn.backgroundColor = ADColor(220, 220, 220);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_delete@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:closeBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabY = CGRectGetMaxY(titleLabel.frame) + 0.5;
    lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
    lineLabel.backgroundColor = LineLabelColor;
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
    _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_s"];
    [_autoButton addSubview:_autoImageView];
    
    _autoLabel = [[UILabel alloc] init];
    CGFloat autoLabelX = CGRectGetMaxX(_autoImageView.frame) + 5;
    _autoLabel.frame = CGRectMake(autoLabelX, 10, ScreenWidth - autoLabelX,20);
    NSString *oneLabelStr = @"自动订购下一章  在菜单-设置可取消自动购买";
    NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
    [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(150, 150, 150) range:NSMakeRange(8, 14)];
    _autoLabel.attributedText = oneLabelStrs;
    _autoLabel.font = Font13;
    [_autoButton addSubview:_autoLabel];
    
    _propmtLabel = [[UILabel alloc] init];
    CGFloat propmtLabY = CGRectGetMaxY(_autoButton.frame) + 10;
    _propmtLabel.frame = CGRectMake(10,propmtLabY , ScreenWidth - 20, 15);
    _propmtLabel.text = @"批量购买的章节，可享受离线阅读";
    _propmtLabel.font = Font13;
    [_bottomView addSubview:_propmtLabel];
    
    CGFloat moneyBtnX = 10;
    CGFloat moneyBtnW = (ScreenWidth - 3 * moneyBtnX) / 2;
    CGFloat moneyBtnH = 60;
    
    CGFloat fiveBtnY = CGRectGetMaxY(_propmtLabel.frame) + moneyBtnX;
    _fiveBtn = [[RechareButton alloc] initWithFrame:CGRectMake(moneyBtnX, fiveBtnY, moneyBtnW, moneyBtnH)];
    _fiveBtn.isFirstBtn = NO;
    [_fiveBtn creatView];
    _fiveBtn.delegate = self;
    _fiveBtn.tag = 10;
    _fiveBtn.isSected = YES;
//    _fiveBtn.backgroundColor = WhiteColor;
//    _fiveBtn.layer.borderWidth = 1.0;
//    _fiveBtn.layer.borderColor = ADColor(228, 143, 57).CGColor;
    _fiveBtn.titleLab.hidden = YES;
    [_bottomView addSubview:_fiveBtn];
    
    CGFloat tenBtnX = CGRectGetMaxX(_fiveBtn.frame) + moneyBtnX;
    _tenBtn = [[RechareButton alloc] initWithFrame:CGRectMake(tenBtnX, fiveBtnY, moneyBtnW, moneyBtnH)];
    _tenBtn.isFirstBtn = YES;
    [_tenBtn creatView];
    _tenBtn.delegate = self;
    _tenBtn.tag = 11;
    _tenBtn.hidden = YES;
    [_bottomView addSubview:_tenBtn];
    
    CGFloat thirtyBtnY = CGRectGetMaxY(_fiveBtn.frame) + moneyBtnX;
    _thirtyBtn = [[RechareButton alloc] initWithFrame:CGRectMake(moneyBtnX, thirtyBtnY, moneyBtnW, moneyBtnH)];
    _thirtyBtn.isFirstBtn = YES;
    [_thirtyBtn creatView];
    _thirtyBtn.delegate = self;
    _thirtyBtn.tag = 12;
    _thirtyBtn.hidden = YES;
    [_bottomView addSubview:_thirtyBtn];
    
    CGFloat fiftyBtnX = CGRectGetMaxX(_thirtyBtn.frame) + moneyBtnX;
    _fiftyBtn = [[RechareButton alloc] initWithFrame:CGRectMake(fiftyBtnX, thirtyBtnY, moneyBtnW, moneyBtnH)];
    _fiftyBtn.isFirstBtn = YES;
    _fiftyBtn.isThirdLin = YES;
    [_fiftyBtn creatView];
    _fiftyBtn.delegate = self;
    _fiftyBtn.tag = 13;
    _fiftyBtn.hidden = YES;
    [_bottomView addSubview:_fiftyBtn];
    
    _remarkLabel = [[UILabel alloc] init];
    CGFloat remarkLabY = CGRectGetMaxY(_fiveBtn.frame) + 10 + moneyBtnX + moneyBtnH;
    _remarkLabel.frame = CGRectMake(10, remarkLabY, ScreenWidth - 10, 15);
    _remarkLabel.font = Font13;
//    _remarkLabel.textColor = LightTextColor;
    [_bottomView addSubview:_remarkLabel];
    
    _ensureBtn = [[EnsureButton alloc] init];
    _ensureBtn.frame = CGRectMake(130, 340, ScreenWidth - 130, 60);
    [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [_ensureBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_ensureBtn addTarget:self action:@selector(ensureClick:) forControlEvents:UIControlEventTouchUpInside];
//    _ensureBtn.backgroundColor = ADColor(228, 143, 57);
    [_bottomView addSubview:_ensureBtn];
    
    UIView *allView = [[UIView alloc] init];
    allView.frame = CGRectMake(0, 340, 130, 60);
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
    if (button.tag == 10) {//5元
        _fiveBtn.isSected = YES;
        _tenBtn.isSected = NO;
        _thirtyBtn.isSected = NO;
        _fiftyBtn.isSected = NO;
        _orderDict = _fiveBtn.oneDict;

        titleStr = _fiveBtn.bottomLabel.text;
 
    } else if (button.tag == 11) {//10元
        _fiveBtn.isSected = NO;
        _tenBtn.isSected = YES;
        _thirtyBtn.isSected = NO;
        _fiftyBtn.isSected = NO;
        _orderDict = _tenBtn.oneDict;

        titleStr = _tenBtn.bottomLabel.text;
    
    } else if (button.tag == 12) {//30元
        _fiveBtn.isSected = NO;
        _tenBtn.isSected = NO;
        _thirtyBtn.isSected = YES;
        _fiftyBtn.isSected = NO;
        titleStr = _thirtyBtn.bottomLabel.text;
        _orderDict = _thirtyBtn.oneDict;

      
    } else if (button.tag == 13) {//50元
        _fiveBtn.isSected = NO;
        _tenBtn.isSected = NO;
        _thirtyBtn.isSected = NO;
        _fiftyBtn.isSected = YES;
        titleStr = _fiftyBtn.bottomLabel.text;
        _orderDict = _fiftyBtn.oneDict;
    }
    if ([self.delegate respondsToSelector:@selector(clickOneTwoThreeOrFour:)]) {
        [self.delegate clickOneTwoThreeOrFour:button];
    }
    _allLabel.text = [NSString stringWithFormat:@"合计：%@",titleStr];    
}

#pragma mark - 自动订购下一章节
- (void)autoBtnClick:(UIButton *)button{
    
    if (_autoButton.tag == 10) {
        _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_n"];
        _autoButton.tag = 20;
    } else {
        _autoImageView.image = [UIImage imageNamed:@"bookshelf_btn_s"];
        _autoButton.tag = 10;
    }
    
    if ([self.delegate respondsToSelector:@selector(autoBuyBtnClick:)]) {
        [self.delegate autoBuyBtnClick:button];
    }
}

#pragma mark - 确认
- (void)ensureClick:(EnsureButton *)button{
    
    button.ensureDict = _orderDict;
    
    [self removeFromSuperview];

    if ([self.delegate respondsToSelector:@selector(ensureBtnClick:)]) {
        [self.delegate ensureBtnClick:button];
    }
}

#pragma mark - 关闭窗口
- (void)closeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(cancelBtnClick)]) {
        [self.delegate cancelBtnClick];
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
