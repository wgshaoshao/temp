//
//  NewThreeOrderView.h
//  Kuaikan
//
//  Created by 少少 on 16/7/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechareButton.h"
#import "EnsureButton.h"

@protocol NewThreeOrderViewDelegate <NSObject>

@optional
- (void)newThreeOrderViewOrderViewDismissed;
- (void)newThreeOrderViewEnsureBtnClick:(UIButton *)button;
- (void)newThreeOrderViewAutoBuyBtnClick:(UIButton *)button;
- (void)newThreeOrderViewCancelBtnClick;
@end

@interface NewThreeOrderView : UIView<RechareButtonDelegate>
@property (nonatomic, weak) id<NewThreeOrderViewDelegate> delegate;

@property (nonatomic, strong) UILabel *chaperNameLab;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *autoButton;
@property (nonatomic, strong) UIImageView *autoImageView;
@property (nonatomic, strong) UILabel *autoLabel;
@property (nonatomic, strong) UILabel *propmtLabel;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) RechareButton *fiveBtn;
@property (nonatomic, strong) RechareButton *tenBtn;
@property (nonatomic, strong) RechareButton *thirtyBtn;


@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) EnsureButton *ensureBtn;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) NSDictionary *orderDict;

- (void)creatView;
@end
