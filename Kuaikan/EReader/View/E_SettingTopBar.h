//
//  E_SettingBar.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  顶部设置条
 */

@protocol E_SettingTopBarDelegate <NSObject>

- (void)goBack;//退出
- (void)showMultifunctionButton;
- (void)clickMarkButton;

@end

@interface E_SettingTopBar : UIView

@property(nonatomic,assign)id<E_SettingTopBarDelegate>delegate;

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIButton *markBtn;
//@property (nonatomic,assign) BOOL isMarkBtn;

- (void)showToolBar;

- (void)hideToolBar;

@end
