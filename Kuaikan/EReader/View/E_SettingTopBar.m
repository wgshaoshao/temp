//
//  E_SettingBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingTopBar.h"

@implementation E_SettingTopBar


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configUI];
    }
    return self;
}


- (void)configUI{
   
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(44, 20, 200, 44);
    self.titleLabel.font = Font16;
    self.titleLabel.textColor = WhiteColor;
    [self addSubview:self.titleLabel];
    
}


- (void)backToFront{
    
    [_delegate goBack];
}


- (void)showToolBar{
   
    CGRect newFrame = self.frame;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end
