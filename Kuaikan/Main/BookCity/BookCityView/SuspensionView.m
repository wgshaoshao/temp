//
//  SuspensionView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SuspensionView.h"

@implementation SuspensionView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (void)creatFoureBtn{
    
    NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"];
    NSString *secondName = [[NSUserDefaults standardUserDefaults] objectForKey:@"secondName"];
    NSString *threeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"threeName"];
    NSString *fourName = [[NSUserDefaults standardUserDefaults] objectForKey:@"fourName"];
    if (!firstName.length) {
        firstName = @"精选";
    }
    if (!secondName.length) {
        secondName = @"男生";
    }
    if (!threeName.length) {
        threeName = @"女生";
    }
    if (!fourName.length) {
        fourName = @"分类";
    }
    

    self.backgroundColor = ClearColor;
    
    CGFloat fourBtnW = ScreenWidth / 5;
    
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.frame = CGRectMake(0, 0, fourBtnW, 44);
    [_selectBtn setTitle:firstName forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = Font16;
    _selectBtn.tag = 10;
    [_selectBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _selectLabel = [[UILabel alloc] init];
    _selectLabel.frame = CGRectMake(10, 41, fourBtnW - 20, 3);
    _selectLabel.backgroundColor = ADColorRGBA(255, 255, 255, 0.7);
    [_selectBtn addSubview:_selectLabel];
    
    
    _boyBtn = [[UIButton alloc] init];
    _boyBtn.frame = CGRectMake(fourBtnW, 0, fourBtnW, 44);
    [_boyBtn setTitle:secondName forState:UIControlStateNormal];
    [_boyBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    _boyBtn.titleLabel.font = Font16;
    _boyBtn.tag = 11;
    [_boyBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_boyBtn];
    
    _boyLabel = [[UILabel alloc] init];
    _boyLabel.frame = CGRectMake(10, 41, fourBtnW - 20, 3);
    _boyLabel.backgroundColor = ADColorRGBA(255, 255, 255, 0.7);
    _boyLabel.hidden = YES;
    [_boyBtn addSubview:_boyLabel];
    
    _girlBtn = [[UIButton alloc] init];
    _girlBtn.frame = CGRectMake(fourBtnW * 2, 0, fourBtnW, 44);
    [_girlBtn setTitle:threeName forState:UIControlStateNormal];
    [_girlBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    _girlBtn.titleLabel.font = Font16;
    _girlBtn.tag = 12;
    [_girlBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_girlBtn];
    
    _girlLabel = [[UILabel alloc] init];
    _girlLabel.frame = CGRectMake(10, 41, fourBtnW - 20, 3);
    _girlLabel.backgroundColor = ADColorRGBA(255, 255, 255, 0.7);
    _girlLabel.hidden = YES;
    [_girlBtn addSubview:_girlLabel];
    
    _classifyBtn = [[UIButton alloc] init];
    _classifyBtn.frame = CGRectMake(fourBtnW * 3, 0, fourBtnW, 44);
    [_classifyBtn setTitle:fourName forState:UIControlStateNormal];
    [_classifyBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    _classifyBtn.titleLabel.font = Font16;
    _classifyBtn.tag = 13;
    [_classifyBtn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_classifyBtn];
    
    _classiftyLabel = [[UILabel alloc] init];
    _classiftyLabel.frame = CGRectMake(10, 41, fourBtnW - 20, 3);
    _classiftyLabel.backgroundColor = ADColorRGBA(255, 255, 255, 0.7);
    _classiftyLabel.hidden = YES;
    [_classifyBtn addSubview:_classiftyLabel];
    
}

//男生按钮
- (void)fourBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(suspensionViewFourBtn:)]) {
        
        [self.delegate suspensionViewFourBtn:button];
    }
}



@end
