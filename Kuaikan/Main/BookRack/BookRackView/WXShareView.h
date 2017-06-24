//
//  WXShareView.h
//  Kuaikan
//
//  Created by 少少 on 16/12/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WXShareViewDelegate <NSObject>

- (void)WXShareBtnClick:(UIButton *)button;

@end

@interface WXShareView : UIView
@property (nonatomic, strong) id<WXShareViewDelegate>delegate;
- (void)creatView;
- (void)showShareView;
- (void)dissShareView;
@end
