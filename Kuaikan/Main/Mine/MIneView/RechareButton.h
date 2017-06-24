//
//  RechareButton.h
//  Kuaikan
//
//  Created by 少少 on 16/5/24.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RechareButtonDelegate <NSObject>

- (void)rechareButtonClick:(UIButton *)button;

@end

@interface RechareButton : UIButton

@property (nonatomic, strong) id<RechareButtonDelegate>delegate;

- (void)creatView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UIImageView *sectImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, assign) BOOL isSected;
@property (nonatomic, assign) BOOL isFirstBtn;
@property (nonatomic, assign) BOOL isThirdLin;
@property (nonatomic, assign) BOOL isTenChapter;
@property (nonatomic, strong) NSDictionary *oneDict;

@end
