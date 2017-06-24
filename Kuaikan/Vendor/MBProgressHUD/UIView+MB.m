//
//  UIView+MB.m
//  ADFilterView
//
//  Created by AiDong on 15/9/16.
//  Copyright (c) 2015年 AiDong. All rights reserved.
//

#import "UIView+MB.h"

@implementation UIView (MB)

// 显示加载等待视图
- (void)showLoadingView
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

// 立即隐藏加载等待视图
- (void)hideLoadingImmediately
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

// 显示提示文字
-(void)showAlertTextWith:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:18.f] ;
    hud.labelText = string;
    hud.margin = 5.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

@end
