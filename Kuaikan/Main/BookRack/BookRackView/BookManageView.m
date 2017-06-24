//
//  BookManageView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/20.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookManageView.h"

@implementation BookManageView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{
    
    NSArray *array = @[@"",@"删除",@"更新",@"全选"];
    
    CGFloat gapSpace = 10;
    CGFloat foureBtnW = (ScreenWidth - 5 * gapSpace) / 4;
    CGFloat foureBtnH = 40;
    
    
    _selectLabel = [[UILabel alloc] init];
    _selectLabel.frame = CGRectMake(0, 25, foureBtnW + 2 * gapSpace, 20);
    _selectLabel.textAlignment = NSTextAlignmentCenter;
    _selectLabel.font = Font15;
    _selectLabel.textColor = TextColor;
    [self addSubview:_selectLabel];
    
    for (int i = 1; i < 4; i ++) {
        if (i == 3) {
            _allButton = [[UIButton alloc] init];
            _allButton.frame = CGRectMake(gapSpace + (gapSpace + foureBtnW) * i, 15, foureBtnW, foureBtnH);
            _allButton.tag = i;
            _allButton.backgroundColor = ADColor(221, 221, 221);
            [_allButton setTitleColor:TextColor forState:UIControlStateNormal];
            [_allButton setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            _allButton.titleLabel.font = Font15;
            [_allButton addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_allButton];
        } else {
            UIButton *fourBtn = [[UIButton alloc] init];
            fourBtn.frame = CGRectMake(gapSpace + (gapSpace + foureBtnW) * i, 15, foureBtnW, foureBtnH);
            fourBtn.tag = i;
            if (i == 1) {
                fourBtn.backgroundColor = ADColor(216, 69, 60);
                [fourBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            } else {
                fourBtn.backgroundColor = ADColor(221, 221, 221);
                [fourBtn setTitleColor:TextColor forState:UIControlStateNormal];
            }
            
            [fourBtn setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            fourBtn.titleLabel.font = Font15;
            [fourBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:fourBtn];
        }
        
        
        
    }
}

- (void)fourBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(bookManageViewBtnClick:)]) {
        [self.delegate bookManageViewBtnClick:button];
    }
}




@end
