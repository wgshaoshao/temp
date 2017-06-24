//
//  PopMenuView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "PopMenuView.h"

#define buttonH    45

@implementation PopMenuView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.backgroundColor = ADColor(230, 230, 230);
        
        [self creatView];
    }
    return self;
}

- (void)creatView{
    
    NSArray *iconImageArray = @[@"bookshelf_menu_icon_switch",@"bookshelf_menu_icon_Books-management",@"bookshelf_menu_icon_Book-arrangement",@"bookshelf_menu_icon_Time-arrangement"];
    //判断日夜切换按钮状态
    NSString *lightTip = @"";
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        lightTip = @"切换白天";
    } else {
        lightTip = @"切换夜间";
    }

    NSArray *titleArray = @[lightTip,@"书籍管理",@"按书名排序",@"按时间排序"];
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i + 1;
        button.frame = CGRectMake(0,i * (buttonH + 0.5), self.frame.size.width, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",iconImageArray[i]]];
        iconImage.frame = CGRectMake(15,i * (buttonH + 0.5) + 14.5, 16, 16);
        [self addSubview:iconImage];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = [NSString stringWithFormat:@"%@",titleArray[i]];
        titleLab.font = Font15;
        titleLab.frame = CGRectMake(45, i * (buttonH + 0.5) + 2.5, self.frame.size.width - 45, 40);
        [self addSubview:titleLab];
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, (i + 1) * (buttonH + 0.5), self.frame.size.width, 0.5);
        [self addSubview:lineLab];
    }
}

- (void)buttonClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(popMenuViewBtnClick:)]) {
        [self.delegate popMenuViewBtnClick:button];
    }
}

@end
