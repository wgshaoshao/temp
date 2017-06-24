//
//  BookManageView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/20.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookManageViewDelegate <NSObject>

- (void)bookManageViewBtnClick:(UIButton *)button;

@end

@interface BookManageView : UIView

- (void)creatView;

@property (nonatomic, strong) id<BookManageViewDelegate>delegate;

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIButton *allButton;

@end
