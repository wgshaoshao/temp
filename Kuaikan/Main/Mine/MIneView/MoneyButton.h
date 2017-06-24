//
//  MoneyButton.h
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoneyButtonDelegate <NSObject>

- (void)moneyButtonClick:(UIButton *)button;

@end

@interface MoneyButton : UIButton

@property (nonatomic, strong) id<MoneyButtonDelegate>delegate;

- (void)creatView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *sectImageView;

@property (nonatomic, assign) BOOL isSected;

@end
