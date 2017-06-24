//
//  CatalogView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CatalogView.h"

@implementation CatalogView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (void)creatView{
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 10, 2, 17);
    lineLabel.backgroundColor = ADColor(53, 137, 238);
    [self addSubview:lineLabel];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, ScreenWidth, 42);
//    button.backgroundColor = [UIColor blackColor];
    [self addSubview:button];
    
    UILabel *catelogLabel = [[UILabel alloc] init];
    catelogLabel.text = @"目录";
    catelogLabel.font = Font16;
    catelogLabel.frame = CGRectMake(10, 8, 35, 20);
    [self addSubview:catelogLabel];
    
    UILabel *topLabel = [[UILabel alloc] init];
    CGFloat topLabelY = CGRectGetMaxY(catelogLabel.frame) + 13;
    topLabel.frame = CGRectMake(0, topLabelY, ScreenWidth, 0.5);
    topLabel.backgroundColor = LineLabelColor;
    [self addSubview:topLabel];
    
    UILabel *totalChapter = [[UILabel alloc] init];
    NSString *totalStr = [NSString stringWithFormat:@"共%@",_totalStr];
    totalChapter.text = totalStr;
    totalChapter.font = Font11;
    totalChapter.textColor = ADColor(153, 153, 153);
    CGFloat totalChapterX = CGRectGetMaxX(catelogLabel.frame) + 5;
    totalChapter.frame = CGRectMake(totalChapterX, 14, 150, 10);
    [self addSubview:totalChapter];
    
    UILabel *newChapterLab = [[UILabel alloc] init];
    CGFloat newChapterLabY = CGRectGetMaxY(topLabel.frame) + 10;
    newChapterLab.frame = CGRectMake(10, newChapterLabY, ScreenWidth - 20, 27);
    newChapterLab.text = [NSString stringWithFormat:@"最新章节：%@",_lastChapterInfo];
    newChapterLab.textAlignment = NSTextAlignmentCenter;
    newChapterLab.font = Font16;
    [self addSubview:newChapterLab];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    CGFloat bottomLabelY = CGRectGetMaxY(newChapterLab.frame) + 8;
    bottomLabel.backgroundColor = LineLabelColor;
    bottomLabel.frame = CGRectMake(0, bottomLabelY, ScreenWidth, 0.5);
    [self addSubview:bottomLabel];
}

@end
