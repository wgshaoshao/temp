//
//  OneBookManageView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/20.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "OneBookManageView.h"

@implementation OneBookManageView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (void)creatView{
    
    NSArray *array = @[@"",@"详情",@"更新",@"全选"];
    
    CGFloat gapSpace = 10;
    CGFloat foureBtnW = (ScreenWidth - 5 * gapSpace) / 4;
    CGFloat foureBtnH = 40;
    
    
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.frame = CGRectMake(gapSpace, 15, foureBtnW, foureBtnH);
    _deleteBtn.backgroundColor = ADColor(221, 221, 221);
    _deleteBtn.tag = 1;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:TextColor forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = Font15;
    [_deleteBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    
    for (int i = 1; i < 4; i ++) {
        if (i == 3) {
            _allButton = [[UIButton alloc] init];
            _allButton.frame = CGRectMake(gapSpace + (gapSpace + foureBtnW) * i, 15, foureBtnW, foureBtnH);
            _allButton.tag = i + 1;
            _allButton.backgroundColor = ADColor(221, 221, 221);
            [_allButton setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            [_allButton setTitleColor:TextColor forState:UIControlStateNormal];
            _allButton.titleLabel.font = Font15;
            [_allButton addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_allButton];
        } else {
            UIButton *fourBtn = [[UIButton alloc] init];
            fourBtn.frame = CGRectMake(gapSpace + (gapSpace + foureBtnW) * i, 15, foureBtnW, foureBtnH);
            fourBtn.tag = i + 1;
            fourBtn.backgroundColor = ADColor(221, 221, 221);
            [fourBtn setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            [fourBtn setTitleColor:TextColor forState:UIControlStateNormal];
            fourBtn.titleLabel.font = Font15;
            [fourBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:fourBtn];
        }
    }
}


- (void)fourBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(OneBookManageViewBtnClick:)]) {
        [self.delegate OneBookManageViewBtnClick:button];
    }
}

@end
