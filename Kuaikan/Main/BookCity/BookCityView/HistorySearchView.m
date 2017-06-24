//
//  HistorySearchView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "HistorySearchView.h"

@implementation HistorySearchView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)creatUI{
    
    self.backgroundColor = WhiteColor;
    
    UILabel *lineLabel =[[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 12, 2, 20);
    lineLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:lineLabel];
    
    UILabel *hotLabel = [[UILabel alloc] init];
    hotLabel.frame = CGRectMake(10, 12, 100, 20);
    hotLabel.text = @"搜索历史";
    hotLabel.font = Font15;
    hotLabel.textColor = ADColor(51, 51, 51);
    [self addSubview:hotLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    refreshBtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 50);
    [refreshBtn setImage:[UIImage imageNamed:@"search_icon_dustbin_s"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];
}

//刷新按钮
- (void)refreshBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(historySearchDeleteBtn)]) {
        [self.delegate historySearchDeleteBtn];
    }
}

@end
