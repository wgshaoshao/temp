//
//  RechargeView.m
//  Kuaikan
//
//  Created by 少少 on 16/9/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RechargeView.h"

@implementation RechargeView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{
    
    _buyType = 0;
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(10, 2, 2, 15);
    lineLabel.backgroundColor = ADColor(246, 155, 62);
    [self addSubview:lineLabel];

    _sectLabel = [[UILabel alloc] init];
    _sectLabel.frame = CGRectMake(15, 0, 200, 20);
    _sectLabel.textColor = TextColor;
    _sectLabel.text = _sectStr;
    _sectLabel.font = Font16;
    [self addSubview:_sectLabel];
    
    CGFloat moneyBtnX = 10;
    CGFloat moneyBtnW = (ScreenWidth - 3 * moneyBtnX) / 2;
    CGFloat moneyBtnH = 70;
    
 
    NSDictionary *dict = nil;
    CGFloat promptBtnY = 0;
    for (int i = 0; i < _listArray.count; i ++) {
      
        dict = _listArray[i];
        
        CGFloat buttonY = CGRectGetMaxY(_sectLabel.frame) + moneyBtnX;
        MoneyButton *button = [[MoneyButton alloc] initWithFrame:CGRectMake(moneyBtnX + (i%2) * (moneyBtnW + moneyBtnX), buttonY + (i/2)*(moneyBtnH + moneyBtnX), moneyBtnW, moneyBtnH)];
        [button creatView];
        button.delegate = self;
        button.tag = 10 + i;
        
        if (i == 0) {
            button.isSected = YES;
        } else {
            button.isSected = NO;
        }
        button.moneyLabel.text = dict[@"name"];
        button.moneyLabel.textColor = LightTextColor;
        
        button.bottomLabel.textColor = LightTextColor;
        NSString *onetipsTR = dict[@"tipsTR"];
        NSString *onetipsBL = dict[@"tipsBL"];
        NSString *onetipsBR = dict[@"tipsBR"];
        
        if (onetipsBR.length) {
            NSString *fiveStr = nil;
            fiveStr = [NSString stringWithFormat:@"%@+%@",onetipsBL,onetipsBR];
            NSMutableAttributedString *fiveStrs = [[NSMutableAttributedString alloc] initWithString:fiveStr];
            [fiveStrs addAttribute:NSForegroundColorAttributeName value:ADColor(86, 204, 95) range:NSMakeRange(onetipsBL.length, onetipsBR.length + 1)];
            button.bottomLabel.attributedText = fiveStrs;
        } else {
            button.bottomLabel.text = dict[@"tipsBL"];
        }
        
        
        if (onetipsTR.length) {
            UIImageView *fiveImageView = [[UIImageView alloc] init];
            fiveImageView.frame = CGRectMake(moneyBtnW - 46*KKuaikan, -3*KKuaikan, 49*KKuaikan, 49*KKuaikan);
            fiveImageView.image = [UIImage imageNamed:@"Recharge_def"];
            
            UILabel *fiveLabel = [[UILabel alloc] init];
            fiveLabel.text = dict[@"tipsTR"];
            fiveLabel.textAlignment = NSTextAlignmentCenter;
            fiveLabel.frame = CGRectMake(18 * KKuaikan, 12 * KKuaikan, 31 * KKuaikan, 12 * KKuaikan);
            fiveLabel.font = Font9;
            fiveLabel.textColor = WhiteColor;
            fiveLabel.transform=CGAffineTransformMakeRotation(M_PI/4);
            [fiveImageView addSubview:fiveLabel];
            [button addSubview:fiveImageView];
        }
        
        [self addSubview:button];
        
        promptBtnY = CGRectGetMaxY(button.frame);
        
        _button = button;
        
    }
    

    if (_rechargeStatus == RechargeStatusRDO) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 10, 40);
        
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(10, promptBtnY + 20, ScreenWidth - 20, 40);
        _textField.placeholder = @"请输入您的手机号码";
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = view;
        _textField.font = Font18;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.backgroundColor = WhiteColor;
        [self addSubview:_textField];
        
        promptBtnY = CGRectGetMaxY(_textField.frame) + 20;
        
    } else {
        _textField = nil;
    }
   
    
    NSDictionary *dictOne = _listArray[0];
    
    _promptBtn = [[UIButton alloc] init];
    _promptBtn.frame = CGRectMake(10, promptBtnY + 20, ScreenWidth - 20, 40);
    [_promptBtn setTitle:[NSString stringWithFormat:@"立即充值：%@",dictOne[@"name"]] forState:UIControlStateNormal];
    [_promptBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _promptBtn.backgroundColor = ADColor(86, 204, 95);
    [_promptBtn addTarget:self action:@selector(promptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_promptBtn];
}



//判断是否为电话号码
- (BOOL)validateTel:(NSString *)candidate{
    
    NSString *telRegex = @"^1[0-9]\\d{9}$";
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3}\\d{7,8}$)";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telRegex];
    NSPredicate *PHSP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    if ([telTest evaluateWithObject:candidate] == YES || [PHSP evaluateWithObject:candidate] == YES) {
        return YES;
    } else{
        return NO;
    }
}

#pragma mark - 选择的金额
- (void)moneyButtonClick:(MoneyButton *)button{
    
    NSString *titleStr = nil;
    
    _button.isSected = NO;
    NSDictionary *dict = nil;
      NSArray *buttonArray = self.subviews;
    NSMutableArray *moneyButtons = [NSMutableArray new];
    for (int i = 0; i<buttonArray.count; i++) {
        id btton = buttonArray[i];
        if ([btton isKindOfClass:[MoneyButton class]]) {
            [moneyButtons addObject:btton];
        }
    }
    NSArray *tempArray = [NSArray arrayWithArray:moneyButtons];
    tempArray =  [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {//按时间排序
        return ((MoneyButton *)obj1).tag - ((MoneyButton *)obj2).tag;
    }];
    
    for (int i = 0; i < moneyButtons.count; i ++) {
        MoneyButton *btn = moneyButtons[i];
        LRLog(@"btn----%ld",btn.tag);
        if (btn.tag == button.tag) {
            btn.isSected = YES;
            _buyType = i;
            dict = _listArray[i];
            titleStr = dict[@"name"];
        } else {
            btn.isSected = NO;
        }
        
    }

    [_promptBtn setTitle:[NSString stringWithFormat:@"立即充值：%@",titleStr] forState:UIControlStateNormal];
}


#pragma mark - 立即充值
- (void)promptBtnClick:(UIButton *)button{
    
    if (_rechargeStatus == RechargeStatusRDO) {//短信支付才有这些
        if (_textField.text.length) {//输入文字了
            if ([self validateTel:_textField.text]) {//正确的手机号码
                if ([self.delegate respondsToSelector:@selector(rechargeViewPromptBtnClick:andListArray:andRecharStatus:andRDOPhoneStr:)]) {
                    [self.delegate rechargeViewPromptBtnClick:_buyType andListArray:_listArray andRecharStatus:_rechargeStatus andRDOPhoneStr:_textField.text];
                }
            } else {//错误的手机号码
                [SVProgressHUD showErrorWithStatus:@"您输入的手机号码有误，请检查"];
            }
        } else {//没有输入电话号码
            [SVProgressHUD showErrorWithStatus:@"请您先输入待支付的手机号码"];
        }
    } else {//非短信支付
        if ([self.delegate respondsToSelector:@selector(rechargeViewPromptBtnClick:andListArray:andRecharStatus:andRDOPhoneStr:)]) {
            [self.delegate rechargeViewPromptBtnClick:_buyType andListArray:_listArray andRecharStatus:_rechargeStatus andRDOPhoneStr:@""];
        }
    }
}


@end
