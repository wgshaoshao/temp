//
//  MineTopView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/11.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineTopViewDelegate <NSObject>

- (void)registButtonClick;
- (void)iconButtonClick;
- (void)refreshButtonClick;

@end

@interface MineTopView : UIView

- (void)creatView;

@property (nonatomic, strong) id<MineTopViewDelegate>delegate;


/** 头像 */
@property (nonatomic, strong) UIImageView *headImage;
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backGroundImage;
/** 昵称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 用户ID */
@property (nonatomic, strong) UILabel *userIDLabel;
/** 余额 */
@property (nonatomic, strong) NSString *balanceStr;
/** 登录 */
@property (nonatomic, strong) UIButton *registBtn;
/** 修改 */
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *balanceLab;


@end
