//
//  BottomView.m
//  Kuaikan
//
//  Created by 少少 on 16/6/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = ADColor(30, 30, 30);
    }
    return self;
}

- (void)creatView{
    
//    // 添加菜单整体到窗口身上
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
////    self.frame = window.bounds;
//    [window addSubview:self];
    
    UIWindow *window= [AppDelegate sharedApplicationDelegate].window;
//    self.frame = window.bounds;
    [window addSubview:self];
//    [window insertSubview:self belowSubview:[AppDelegate sharedApplicationDelegate].nightView];
    
    UIButton *allSelectBtn = [[UIButton alloc] init];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self addSubview:allSelectBtn];
    allSelectBtn.titleLabel.font = Font14;
    [allSelectBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    allSelectBtn.frame = CGRectMake(0, 0, ScreenWidth/3, self.frame.size.height);
    [allSelectBtn addTarget:self action:@selector(allSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [self addSubview:lineLabel];
    lineLabel.frame = CGRectMake(ScreenWidth/3, 10, 1, self.frame.size.height - 20);
    lineLabel.backgroundColor = WhiteColor;
    
    
    _deleteBtn = [[UIButton alloc] init];
    CGFloat deleteLabelX = CGRectGetMaxX(lineLabel.frame) + 1;
    _deleteBtn.frame = CGRectMake(deleteLabelX, 0, ScreenWidth/3, self.frame.size.height);
    _deleteBtn.titleLabel.font = Font14;
    [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deletebtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    
    UILabel *secondLine = [[UILabel alloc] init];
    [self addSubview:secondLine];
    CGFloat secondLineX = CGRectGetMaxX(_deleteBtn.frame);
    secondLine.frame = CGRectMake(secondLineX, 10, 1, self.frame.size.height - 20);
    secondLine.backgroundColor = WhiteColor;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [self addSubview:cancelBtn];
    CGFloat cancelBtnX = CGRectGetMaxX(secondLine.frame);
    cancelBtn.frame = CGRectMake(cancelBtnX, 0, (ScreenWidth - 2)/3, self.frame.size.height);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font14;
    [cancelBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
}

//全选按钮
- (void)allSelectBtnClick{

    if ([self.delegate respondsToSelector:@selector(bottomViewAllSelectBtnClick)]) {
        [self.delegate bottomViewAllSelectBtnClick];
    }
}

//取消按钮
- (void)cancelBtnClick{

    if ([self.delegate respondsToSelector:@selector(bottomViewCancelBtnClick)]) {
        [self.delegate bottomViewCancelBtnClick];
    }
}

//删除按钮
- (void)deletebtnClick{

    if ([self.delegate respondsToSelector:@selector(bottomViewDeletebtnClick)]) {
        [self.delegate bottomViewDeletebtnClick];
    }
}

@end
