//
//  EmptyRackView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyRackViewDelegate <NSObject>

@optional
- (void)emptyRackViewBtnClick;

@end

@interface EmptyRackView : UIView
@property (nonatomic, strong) id<EmptyRackViewDelegate>delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@end
