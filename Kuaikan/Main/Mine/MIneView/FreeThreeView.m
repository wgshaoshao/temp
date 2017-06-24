//
//  FreeThreeView.m
//  Kuaikan
//
//  Created by 少少 on 16/12/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "FreeThreeView.h"

@implementation FreeThreeView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatFoureBtn{

    self.backgroundColor = WhiteColor;
    
    CGFloat fourBtnW = ScreenWidth / 3;
    
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.frame = CGRectMake(0, 0, fourBtnW, 44);
    [_selectBtn setTitle:@"精选" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = Font16;
    _selectBtn.tag = 10;
    [_selectBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _selectLabel = [[UILabel alloc] init];
    _selectLabel.frame = CGRectMake(0, 41.5, fourBtnW, 2.5);
    _selectLabel.backgroundColor = [UIColor colorWithRed:92/255.0 green:125/255.0 blue:187/255.0 alpha:0.7];
    [_selectBtn addSubview:_selectLabel];
    
    
    _boyBtn = [[UIButton alloc] init];
    _boyBtn.frame = CGRectMake(fourBtnW, 0, fourBtnW, 44);
    [_boyBtn setTitle:@"男生" forState:UIControlStateNormal];
    [_boyBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
    _boyBtn.titleLabel.font = Font16;
    _boyBtn.tag = 11;
    [_boyBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_boyBtn];
    
    _boyLabel = [[UILabel alloc] init];
    _boyLabel.frame = CGRectMake(0, 41.5, fourBtnW, 2.5);
    _boyLabel.backgroundColor = [UIColor colorWithRed:92/255.0 green:125/255.0 blue:187/255.0 alpha:0.7];
    _boyLabel.hidden = YES;
    [_boyBtn addSubview:_boyLabel];
    
    _girlBtn = [[UIButton alloc] init];
    _girlBtn.frame = CGRectMake(fourBtnW * 2, 0, fourBtnW, 44);
    [_girlBtn setTitle:@"女生" forState:UIControlStateNormal];
    [_girlBtn setTitleColor:LightTextColor forState:UIControlStateNormal];
    _girlBtn.titleLabel.font = Font16;
    _girlBtn.tag = 12;
    [_girlBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_girlBtn];
    
    _girlLabel = [[UILabel alloc] init];
    _girlLabel.frame = CGRectMake(0, 41.5, fourBtnW, 2.5);
    _girlLabel.backgroundColor = [UIColor colorWithRed:92/255.0 green:125/255.0 blue:187/255.0 alpha:0.7];
    _girlLabel.hidden = YES;
    [_girlBtn addSubview:_girlLabel];
    
}


//3个按钮
- (void)fourBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(freeThreeViewButton:)]) {
        
        [self.delegate freeThreeViewButton:button];
    }
}

@end
