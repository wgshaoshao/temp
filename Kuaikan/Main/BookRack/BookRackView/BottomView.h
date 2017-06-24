//
//  BottomView.h
//  Kuaikan
//
//  Created by 少少 on 16/6/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

@optional

- (void)bottomViewAllSelectBtnClick;
- (void)bottomViewCancelBtnClick;
- (void)bottomViewDeletebtnClick;

@end

@interface BottomView : UIView
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, weak) id<BottomViewDelegate> delegate;

- (void)creatView;
@end
