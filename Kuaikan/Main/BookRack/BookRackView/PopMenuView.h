//
//  PopMenuView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuViewDelegate <NSObject>

- (void)popMenuViewBtnClick:(UIButton *)button;

@end

@interface PopMenuView : UIView

@property (nonatomic, strong) id<PopMenuViewDelegate>delegate;

@end
