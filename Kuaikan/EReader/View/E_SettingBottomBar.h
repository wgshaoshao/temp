//
//  E_SettingBottomBar.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginButton.h"

/**
 *  底部设置条
 */
@protocol E_SettingBottomBarDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)fontSizeChanged:(int)fontSize;//改变字号
- (void)callDrawerView;//侧边栏
- (void)turnToNextChapter;//下一章
- (void)turnToPreChapter;//上一章
- (void)sliderToChapterPage:(NSInteger)chapterIndex;
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
- (void)callCommentView;//目录
- (void)nightBtnClick;//夜景
- (void)settingBtnClick;//设置
- (void)batchBtnClick;


@end


@interface E_SettingBottomBar : UIView

@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,assign) id<E_SettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;
@property (nonatomic,assign) double percent;
@property (nonatomic,strong) LoginButton *coverBtn;
@property (nonatomic,strong) LoginButton *nightBtn;
- (void)changeSliderRatioNum:(float)percentNum;

- (void)showToolBar;

- (void)hideToolBar;

@end
