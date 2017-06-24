//
//  NewOrderView.h
//  Kuaikan
//
//  Created by 少少 on 16/7/14.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewButton.h"
#import "EnsureButton.h"

@protocol NewOrderViewDelegate <NSObject>

@optional
- (void)newOrderViewOrderViewDismissed;
- (void)newOrderViewEnsureBtnClick:(UIButton *)button;
- (void)newOrderViewAutoBuyBtnClick:(UIButton *)button;
- (void)newOrderViewCancelBtnClick;
@end

@interface NewOrderView : UIView<NewButtonDelegate>

@property (nonatomic, weak) id<NewOrderViewDelegate> delegate;

@property (nonatomic, strong) UILabel *chaperNameLab;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *autoButton;
@property (nonatomic, strong) UIImageView *autoImageView;
@property (nonatomic, strong) UILabel *autoLabel;
@property (nonatomic, strong) UILabel *propmtLabel;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NewButton *fiveBtn;

@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) EnsureButton *ensureBtn;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) NSDictionary *orderDict;

- (void)creatView;

@end
