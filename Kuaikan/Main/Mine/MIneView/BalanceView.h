//
//  BalanceView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BalanceViewDelegate <NSObject>

- (void)balanceViewRefreshBtn;

@end

@interface BalanceView : UIView

@property (nonatomic, strong) id<BalanceViewDelegate>delegate;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *refreshBtn;
- (void)creatView;
@end
