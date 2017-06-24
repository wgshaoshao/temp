//
//  RechargeView.h
//  Kuaikan
//
//  Created by 少少 on 16/9/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyButton.h"

typedef enum {
    RechargeStatusWX = 0,
    RechargeStatusAPPLE = 1,
    RechargeStatusZFB = 2,
    RechargeStatusRDO = 3
} RechargeStatus;

@protocol RechargeViewDelegate <NSObject>

- (void)rechargeViewPromptBtnClick:(NSInteger)indexBtn andListArray:(NSArray *)array andRecharStatus:(RechargeStatus)rechargeStatus andRDOPhoneStr:(NSString *)phoneStr;


@end

@interface RechargeView : UIView<MoneyButtonDelegate>

@property (nonatomic, strong) UILabel *sectLabel;
@property (nonatomic, strong) NSString *sectStr;
@property (nonatomic, strong) MoneyButton *button;
//@property (nonatomic, strong) MoneyButton *fiveBtn;
//@property (nonatomic, strong) MoneyButton *tenBtn;
//@property (nonatomic, strong) MoneyButton *thirtyBtn;
//@property (nonatomic, strong) MoneyButton *fiftyBtn;
//@property (nonatomic, strong) MoneyButton *oneHundredBtn;
//@property (nonatomic, strong) MoneyButton *twoHundredBtn;
//
//@property (nonatomic, strong) MoneyButton *sevenBtn;
//@property (nonatomic, strong) MoneyButton *eightBtn;
//@property (nonatomic, strong) MoneyButton *nineBtn;
//@property (nonatomic, strong) MoneyButton *lastTenBtn;

@property (nonatomic, strong) UIButton *promptBtn;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) NSInteger buyType;
@property (nonatomic, strong) UITextField *textField;

- (void)creatView;
@property (nonatomic, strong) id<RechargeViewDelegate>delegate;
@property (nonatomic, assign) RechargeStatus rechargeStatus;

@end
