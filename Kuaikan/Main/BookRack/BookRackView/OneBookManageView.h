//
//  OneBookManageView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/20.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneBookManageViewDelegate <NSObject>

- (void)OneBookManageViewBtnClick:(UIButton *)button;

@end

@interface OneBookManageView : UIView

- (void)creatView;

@property (nonatomic, strong) id<OneBookManageViewDelegate>delegate;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL isRed;
@property (nonatomic, strong) UIButton *allButton;
@end
