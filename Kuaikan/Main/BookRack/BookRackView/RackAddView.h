//
//  RackAddView.h
//  Kuaikan
//
//  Created by 少少 on 16/12/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RackAddViewDelegate <NSObject>
- (void)rackAddViewBtnClick:(UIButton *)button;
@end

@interface RackAddView : UIView

@property (nonatomic, strong) id<RackAddViewDelegate>delegate;
- (void)creatView;
- (void)showRackAddView;
- (void)dissRackAddView;

@end
