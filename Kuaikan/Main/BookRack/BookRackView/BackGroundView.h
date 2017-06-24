//
//  BackGroundView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackGroundViewDelegate <NSObject>

- (void)backGroundViewBtnClick:(UIButton *)button;

@end

@interface BackGroundView : UIView

- (void)creatView;

@property (nonatomic, strong) id<BackGroundViewDelegate>delegate;
/** 背景图片 */
@property (nonatomic, strong) NSString *backGroundImage;
/** 书籍标题 */
@property (nonatomic, strong) NSString *titleStr;
/** 作者 */
@property (nonatomic, strong) NSString *authorStr;
/** 字数 */
@property (nonatomic, strong) NSString *bookNumber;
/** 书籍类型 */
@property (nonatomic, strong) NSString *bookTypeName;
/** 书籍状态(0连载,1完本) */
@property (nonatomic, assign) NSInteger status;
/** 点击数 */
@property (nonatomic, strong) NSString *clickNum;

@property (nonatomic, strong) UIButton *rackBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareBtn;

@end
