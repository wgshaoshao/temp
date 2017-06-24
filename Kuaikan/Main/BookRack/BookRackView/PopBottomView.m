//
//  PopBottomView.m
//  Kuaikan
//
//  Created by 少少 on 17/2/14.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "PopBottomView.h"

@implementation PopBottomView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
//        self.backgroundColor = ADColor(30, 30, 30);
    }
    return self;
}

- (void)creatView{

//    UIWindow *window= [AppDelegate sharedApplicationDelegate].window;
//    [window addSubview:self];
    
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    cover.tag = 10;
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, ScreenHeight - 160, ScreenWidth, 160);
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:nil];
    imageView.userInteractionEnabled = YES;
    [cover addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, ScreenWidth, 160);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
    
    UIButton *moreBtn = [[UIButton alloc] init];
//    moreBtn.backgroundColor = [UIColor blackColor];
    moreBtn.frame = CGRectMake(ScreenWidth - 34, ScreenHeight - 170, 44, 44);
    [moreBtn setImage:[UIImage imageNamed:@"lodin_icon_cancel_-normal"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:moreBtn];


}

- (void)buttonClick{

    if ([self.delegate respondsToSelector:@selector(popBottomViewBtnClick)]) {
        
        [self.delegate popBottomViewBtnClick];
    }
}

- (void)moreBtnClick{

    [self removeFromSuperview];
}

@end
