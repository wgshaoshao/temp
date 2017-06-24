//
//  NewButton.h
//  Kuaikan
//
//  Created by 少少 on 16/7/14.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewButtonDelegate <NSObject>

- (void)rechareButtonClick:(UIButton *)button;

@end


@interface NewButton : UIButton

@property (nonatomic, strong) id<NewButtonDelegate>delegate;

- (void)creatView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UIImageView *sectImageView;

@property (nonatomic, assign) BOOL isSected;
@property (nonatomic, assign) BOOL isFirstBtn;
@property (nonatomic, assign) BOOL isThirdLin;
@property (nonatomic, strong) NSDictionary *oneDict;

@end
