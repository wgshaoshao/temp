//
//  FreeThreeView.h
//  Kuaikan
//
//  Created by 少少 on 16/12/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FreeThreeViewDelegate <NSObject>

- (void)freeThreeViewButton:(UIButton *)button;

@end

@interface FreeThreeView : UIView

@property (nonatomic, strong) id<FreeThreeViewDelegate>delegate;
- (void)creatFoureBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *boyBtn;
@property (nonatomic, strong) UIButton *girlBtn;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UILabel *boyLabel;
@property (nonatomic, strong) UILabel *girlLabel;

@end
