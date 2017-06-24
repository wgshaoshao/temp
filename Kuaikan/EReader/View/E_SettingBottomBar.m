//
//  E_SettingBottomBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingBottomBar.h"
#import "E_ContantFile.h"
#import "E_CommonManager.h"
#import "ILSlider.h"
#import "E_HUDView.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@implementation E_SettingBottomBar
{
    ILSlider *ilSlider;
//    UILabel  *showLbl;
    BOOL isFirstShow;
//    UILabel *controlLabel;
//    double percent;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        isFirstShow = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    CGFloat marginX  = (ScreenWidth - 280) / 3;

    
    _coverBtn = [[LoginButton alloc] init];
    [_coverBtn setTitle:@"目录" forState:UIControlStateNormal];
    [_coverBtn setTitleColor:ADColor(184, 184, 184) forState:UIControlStateNormal];
    _coverBtn.titleLabel.font = Font13;
    [_coverBtn setImage:[UIImage imageNamed:@"reader_icon_Catalog_n"] forState:UIControlStateNormal];
    [_coverBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
    _coverBtn.frame = CGRectMake(20, self.frame.size.height - 70, 60, 60);
    [self addSubview:_coverBtn];
    
    LoginButton *batchBtn = [[LoginButton alloc] init];
    [batchBtn setTitle:@"批量购买" forState:UIControlStateNormal];
    [batchBtn setTitleColor:ADColor(184, 184, 184) forState:UIControlStateNormal];
    batchBtn.titleLabel.font = Font13;
    [batchBtn setImage:[UIImage imageNamed:@"reader_icon__n"] forState:UIControlStateNormal];
    CGFloat batchBtnX = CGRectGetMaxX(_coverBtn.frame) + marginX;
    batchBtn.frame = CGRectMake(batchBtnX, self.frame.size.height - 70, 60, 60);
    [batchBtn addTarget:self action:@selector(batchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:batchBtn];
    
    
    _nightBtn = [[LoginButton alloc] init];
    [_nightBtn setTitleColor:ADColor(184, 184, 184) forState:UIControlStateNormal];
    _nightBtn.titleLabel.font = Font13;
    
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        [_nightBtn setTitle:@"日间" forState:UIControlStateNormal];
        [_nightBtn setImage:[UIImage imageNamed:@"reader_icon_Day_n"] forState:UIControlStateNormal];
        
    } else {
        [_nightBtn setTitle:@"夜间" forState:UIControlStateNormal];
        [_nightBtn setImage:[UIImage imageNamed:@"reader_icon_Night_n"] forState:UIControlStateNormal];
        
    }
    
    
    CGFloat nightBtnX = CGRectGetMaxX(batchBtn.frame) + marginX;
    _nightBtn.frame = CGRectMake(nightBtnX, self.frame.size.height - 70, 60, 60);
    [_nightBtn addTarget:self action:@selector(nightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nightBtn];
    
    LoginButton *settingBtn = [[LoginButton alloc] init];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:ADColor(184, 184, 184) forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"reader_icon_Set-up_n"] forState:UIControlStateNormal];
    settingBtn.titleLabel.font = Font13;
    CGFloat settingBtnX = CGRectGetMaxX(_nightBtn.frame) + marginX;
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.frame = CGRectMake(settingBtnX, self.frame.size.height - 70, 60, 60);
    [self addSubview:settingBtn];
    
    
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 15 - 40 - 50 , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        
        if (!isFirstShow) {
            _percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);

        }
        isFirstShow = NO;
               
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        
        float percentNew = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        NSInteger page = (NSInteger)round(percentNew * _chapterTotalPage);
        if (page == 0) {
            page = 1;
        }

        [_delegate sliderToChapterPage:page];
    }];

    [self addSubview:ilSlider];
    
//    [self addSubview:controlLabel];
   
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 15 - 40 - 50, 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setTitle:@"上一章" forState:0];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:ADColor(184, 184, 184) forState:0];
    [self addSubview:preChapterBtn];
    
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 15 - 40 - 50, 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setTitle:@"下一章" forState:0];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:ADColor(184, 184, 184) forState:0];
    [self addSubview:nextChapterBtn];
    
}

#pragma mark - 批量下载
- (void)batchBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(batchBtnClick)]) {
        [_delegate batchBtnClick];
    }
}

- (void)themeButtonPressed:(UIButton *)sender{
    
    [sender setSelected:YES];
    
    for (int i = 1; i <= 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        if (button.tag != sender.tag) {
            [button setSelected:NO];
        }
    }
    
    [_delegate themeButtonAction:self themeIndex:sender.tag-7000];
    [E_CommonManager saveCurrentThemeID:sender.tag-7000];
}

- (void)goToNextChapter{
    
    [_delegate turnToNextChapter];
    
}

- (void)goToPreChapter{
    
    [_delegate turnToPreChapter];

}

#pragma mark - 小
- (void)changeSmall
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        [E_HUDView showMsg:MIN_TIPS inView:self];
        return;
    }
    fontSize--;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
}

- (void)changeBig
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        [E_HUDView showMsg:MAX_TIPS inView:self];
        return;
    }
    fontSize++;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
    
}


- (void)updateFontButtons
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    _bigFont.enabled = fontSize < MAX_FONT_SIZE;
    _smallFont.enabled = fontSize > MIN_FONT_SIZE;
}

//目录点击
- (void)showDrawerView{
   
    [_delegate callDrawerView];
}

- (void)changeSliderRatioNum:(float)percentNum{
    
    ilSlider.ratioNum = percentNum;

}

- (void)showCommentView{
    
    [_delegate callCommentView];
}




- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= kBottomBarH;
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
//    if (ilSlider.ratioNum < 0.1) {
//        controlLabel.frame = CGRectMake(ilSlider.ratioNum*(self.frame.size.width - 100) + 32, 10, 50, 20);
//
//    } else {
//        controlLabel.frame = CGRectMake(ilSlider.ratioNum*(self.frame.size.width - 100) + 24, 10, 50, 20);
//
//    }
//    controlLabel.text = [NSString stringWithFormat:@"%.0f%@",ilSlider.ratioNum * 100,@"%"];
//    controlLabel.textAlignment = NSTextAlignmentCenter;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}


//夜景点击
- (void)nightBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(nightBtnClick)]) {
        [_delegate nightBtnClick];
    }
}

//设置点击
- (void)settingBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(settingBtnClick)]) {
        [_delegate settingBtnClick];
    }
}

@end
