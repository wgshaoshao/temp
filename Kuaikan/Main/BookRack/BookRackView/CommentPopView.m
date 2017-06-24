//
//  CommentPopView.m
//  Kuaikan
//
//  Created by 少少 on 17/1/12.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "CommentPopView.h"

@implementation CommentPopView

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
    [window addSubview:self];
    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    [cover addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cover.tag = 10;
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(30, (ScreenHeight - 190)/2, ScreenWidth - 60, 195);
    backView.backgroundColor = WhiteColor;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6.0;
    [cover addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"客官，看完书，再来评价一下吧~";
    titleLabel.font = Font16;
    titleLabel.textColor = LightTextColor;
    titleLabel.frame = CGRectMake(0, 10, ScreenWidth - 60, 60);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [backView addSubview:titleLabel];
    
    UIButton *gotoReputation = [[UIButton alloc] init];
    CGFloat gotoReputationY = CGRectGetMaxY(titleLabel.frame);
    gotoReputation.frame = CGRectMake(0, gotoReputationY, ScreenWidth - 60, 40);
    [gotoReputation addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    gotoReputation.tag = 11;
    [gotoReputation setTitle:@"去好评" forState:UIControlStateNormal];
    [gotoReputation setTitleColor:ADColor(230, 68, 45) forState:UIControlStateNormal];
    gotoReputation.titleLabel.textAlignment = NSTextAlignmentCenter;
    gotoReputation.titleLabel.font = Font16;
    [backView addSubview:gotoReputation];
    
    UIButton *ideaFeed = [[UIButton alloc] init];
    CGFloat ideaFeedY = CGRectGetMaxY(gotoReputation.frame);
    ideaFeed.frame = CGRectMake(0, ideaFeedY, ScreenWidth - 60, 40);
    [ideaFeed addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    ideaFeed.tag = 12;
    [ideaFeed setTitle:@"我要吐槽" forState:UIControlStateNormal];
    [ideaFeed setTitleColor:LightTextColor forState:UIControlStateNormal];
    ideaFeed.titleLabel.textAlignment = NSTextAlignmentCenter;
    ideaFeed.titleLabel.font = Font16;
    [backView addSubview:ideaFeed];
    
    UIButton *closeView = [[UIButton alloc] init];
    CGFloat closeViewY = CGRectGetMaxY(ideaFeed.frame);
    closeView.frame = CGRectMake(0, closeViewY, ScreenWidth - 60, 40);
    [closeView addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    closeView.tag = 13;
    [closeView setTitle:@"不，谢谢" forState:UIControlStateNormal];
    [closeView setTitleColor:LightTextColor forState:UIControlStateNormal];
    closeView.titleLabel.textAlignment = NSTextAlignmentCenter;
    closeView.titleLabel.font = Font16;
    [backView addSubview:closeView];
}

- (void)threeBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(commentPopViewThreeBtnClick:)]) {
        
        [self.delegate commentPopViewThreeBtnClick:button];
    }
}

@end
