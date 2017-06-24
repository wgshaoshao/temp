//
//  E_SettingSecondBar.m
//  kuaidu
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "E_SettingSecondBar.h"
#import "E_HUDView.h"
#import "E_CommonManager.h"
#import "ILSlider.h"
#import "LoginButton.h"
#import "LightControl.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@implementation E_SettingSecondBar
{
    LightControl *ilSlider;
//    UILabel  *showLbl;
    BOOL isFirstShow;
//    UILabel *controlLabel;
}


- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        isFirstShow = YES;

        [self setupSecondUI];
    }
    return self;
}


- (void)setupSecondUI{
        
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 50 - 40 - 50, 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setImage:[UIImage imageNamed:@"reader_icon_Brightness-minus"] forState:UIControlStateNormal];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:preChapterBtn];
    
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 50 - 40 - 50, 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setImage:[UIImage imageNamed:@"reader_icon_Brightness-plus"] forState:UIControlStateNormal];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:nextChapterBtn];
    
    ilSlider = [[LightControl alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 50 - 40 - 50 , self.frame.size.width - 100, 40) direction:LightControlDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        
        isFirstShow = NO;
        //屏幕亮度
        [[UIScreen mainScreen] setBrightness:percent];
        
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {

        float percentNew = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        [[UIScreen mainScreen] setBrightness:percentNew];
    }];
    
    [self addSubview:ilSlider];
    
    //大字体
    _bigFont = [UIButton buttonWithType:0];
    _bigFont.frame = CGRectMake((self.frame.size.width + 20)/2, self.frame.size.height - 40 - 54, 100, 35);
    [_bigFont setImage:[UIImage imageNamed:@"reader_btn_n"] forState:0];
    _bigFont.backgroundColor = [UIColor clearColor];
    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bigFont];
    
//    小字体
    _smallFont = [UIButton buttonWithType:0];
    [_smallFont setImage:[UIImage imageNamed:@"reader_btn_reduce_n"] forState:0];
    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    _smallFont.frame =  CGRectMake((self.frame.size.width - 220)/2, self.frame.size.height - 40 - 54, 100, 35);
    [self addSubview:_smallFont];
    
//    主题颜色滚动条
        UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 45 , self.frame.size.width - 60, 40)];
        [self addSubview:themeScroll];
    
//    背景颜色
        NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    
        for (int i = 1; i <= 4; i ++) {
    
            UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            themeButton.layer.cornerRadius = 2.0f;
            themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
            themeButton.frame = CGRectMake(-20 + 46*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
    
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_sbg%d.png",i]] forState:UIControlStateSelected];
    
            if (i == themeID) {
                themeButton.selected = YES;
            }
    

            themeButton.tag = 7000+i;
            [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [themeScroll addSubview:themeButton];
    
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


//剪亮度
- (void)goToPreChapter{
    
    float brightNess = [UIScreen mainScreen].brightness;
    
    float newBright = 100 * brightNess;
    -- newBright;
    brightNess = newBright / 100;

    [[UIScreen mainScreen] setBrightness:brightNess];
    ilSlider.ratioNum = [UIScreen mainScreen].brightness;

}

//加亮度
- (void)goToNextChapter{

    float brightNess = [UIScreen mainScreen].brightness;
    
    float newBright = 100 * brightNess;
    ++ newBright;
    brightNess = newBright / 100;
    
    [[UIScreen mainScreen] setBrightness:brightNess];
    ilSlider.ratioNum = [UIScreen mainScreen].brightness;

}

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


- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= KSecondBottonBarH;
    
    ilSlider.ratioNum = [UIScreen mainScreen].brightness;
    
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += KSecondBottonBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
