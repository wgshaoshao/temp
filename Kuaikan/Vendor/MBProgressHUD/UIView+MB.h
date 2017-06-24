//
//  UIView+MB.h
//  ADFilterView
//
//  Created by AiDong on 15/9/16.
//  Copyright (c) 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (MB)

/**
 *  显示加载等待视图
 */
- (void)showLoadingView ;

/**
 *  立即隐藏加载等待视图
 */
- (void)hideLoadingImmediately ;

/**
 *  显示提示文字
 */
- (void)showAlertTextWith:(NSString *)string ;

@end
