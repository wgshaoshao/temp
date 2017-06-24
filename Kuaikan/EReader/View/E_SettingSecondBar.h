//
//  E_SettingSecondBar.h
//  kuaidu
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 mac. All rights reserved.
//  点击设置第二个botton View

#import <UIKit/UIKit.h>

@protocol E_SettingSecondBarDelegate <NSObject>

- (void)fontSizeChanged:(int)fontSize;//改变字号
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;


@end

@interface E_SettingSecondBar : UIView
@property (nonatomic,assign) id<E_SettingSecondBarDelegate>delegate;

@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;

- (void)showToolBar;

- (void)hideToolBar;

@end
