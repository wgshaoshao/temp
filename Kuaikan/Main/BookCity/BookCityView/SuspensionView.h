//
//  SuspensionView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuspensionViewDelegate <NSObject>

- (void)suspensionViewFourBtn:(UIButton *)button;

@end

@interface SuspensionView : UIView

@property (nonatomic, strong) id<SuspensionViewDelegate>delegate;

- (void)creatFoureBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *boyBtn;
@property (nonatomic, strong) UIButton *girlBtn;
@property (nonatomic, strong) UIButton *classifyBtn;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UILabel *boyLabel;
@property (nonatomic, strong) UILabel *girlLabel;
@property (nonatomic, strong) UILabel *classiftyLabel;
@end

