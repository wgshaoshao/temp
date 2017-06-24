//
//  RackAddView.m
//  Kuaikan
//
//  Created by 少少 on 16/12/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RackAddView.h"

@implementation RackAddView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}

- (void)creatView{

    // 添加菜单整体到窗口身上
    UIWindow *window= [AppDelegate sharedApplicationDelegate].window;
    //    self.frame = window.bounds;
    [window addSubview:self];
//    [window insertSubview:self belowSubview:[AppDelegate sharedApplicationDelegate].nightView];
    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    [cover addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cover.tag = 10;
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, ScreenHeight - 182, ScreenWidth, 182);
    [cover addSubview:backView];
    
  
    UIButton *freeButton = [[UIButton alloc] init];
    [freeButton addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    freeButton.tag = 11;
    freeButton.frame = CGRectMake(0, 0, ScreenWidth, 45);
    [backView addSubview:freeButton];
    
    UIImageView *freeImage = [[UIImageView alloc] init];
    freeImage.image = [UIImage imageNamed:@"bookshelf_icon_book"];
    freeImage.frame = CGRectMake(20, 11, 22, 22);
    [freeButton addSubview:freeImage];
    
    UILabel *freeLabel = [[UILabel alloc] init];
    freeLabel.text = @"逛书城";
    freeLabel.font = Font16;
    
    CGFloat freeLabelX = CGRectGetMaxX(freeImage.frame) + 10;
    freeLabel.frame = CGRectMake(freeLabelX, 0, ScreenWidth, 45);
    [freeButton addSubview:freeLabel];
    
    UILabel *freeLine = [[UILabel alloc] init];
    CGFloat freeLineY = CGRectGetMaxY(freeButton.frame);
    freeLine.frame = CGRectMake(0, freeLineY, ScreenWidth, 0.5);
    
    [backView addSubview:freeLine];
    
    UIButton *bookButton = [[UIButton alloc] init];
    [bookButton addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bookButton.tag = 12;
    CGFloat bookBtnY = CGRectGetMaxY(freeLine.frame);
    bookButton.frame = CGRectMake(0, bookBtnY, ScreenWidth, 45);
    [backView addSubview:bookButton];
    
    UIImageView *bookImage = [[UIImageView alloc] init];
    bookImage.image = [UIImage imageNamed:@"bookshelf_icon_Free-of-charge"];
    bookImage.frame = CGRectMake(20, 11, 22, 22);
    [bookButton addSubview:bookImage];
    
    UILabel *bookLabel = [[UILabel alloc] init];
    bookLabel.text = @"今日免费";
    bookLabel.font = Font16;
    CGFloat bookLabelX = CGRectGetMaxX(bookImage.frame) + 10;
    bookLabel.frame = CGRectMake(bookLabelX, 0, ScreenWidth, 45);
    [bookButton addSubview:bookLabel];
    
    UILabel *bookLine = [[UILabel alloc] init];
    CGFloat bookLineY = CGRectGetMaxY(bookButton.frame);
    
    bookLine.frame = CGRectMake(0, bookLineY, ScreenWidth, 0.5);
    [backView addSubview:bookLine];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font16;
    [cancelBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat cancelBtnY = CGRectGetMaxY(bookLine.frame) + 25;
    cancelBtn.tag = 10;
    cancelBtn.frame = CGRectMake(20, cancelBtnY, ScreenWidth - 40, 45);
    [backView addSubview:cancelBtn];
    

    if (isNightView) {
        backView.backgroundColor = ADColor(127, 127, 127);
        freeLabel.textColor = ADColor(53, 53, 53);
        bookLabel.textColor = ADColor(53, 53, 53);
        bookLine.backgroundColor = ADColor(110, 110, 110);
        freeLine.backgroundColor = ADColor(110, 110, 110);
        cancelBtn.backgroundColor = ADColor(110, 110, 110);
        [cancelBtn setTitleColor:ADColor(53, 53, 53) forState:UIControlStateNormal];
    } else {
        backView.backgroundColor = WhiteColor;
        freeLabel.textColor = LightTextColor;
        bookLabel.textColor = LightTextColor;
        bookLine.backgroundColor = LineLabelColor;
        freeLine.backgroundColor = LineLabelColor;
        cancelBtn.backgroundColor = LineLabelColor;
        [cancelBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
    }
}

- (void)showRackAddView{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dissRackAddView{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = ScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        //        [self removeFromSuperview];
    }];
}

//微信朋友圈、微信好友、取消
- (void)threeBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(rackAddViewBtnClick:)]) {
        
        [self.delegate rackAddViewBtnClick:button];
    }
}

@end
