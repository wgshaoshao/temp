//
//  SettingSecondCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SettingSecondCell.h"

@implementation SettingSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"SettingSecondCell";
    SettingSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SettingSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.frame = CGRectMake(10, 7, 30, 30);
//        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font15;
//        CGFloat titleX = CGRectGetMaxX(_iconImageView.frame) + 10;
        _titleLabel.frame = CGRectMake(15, 2, 150, 50);
        [self.contentView addSubview:_titleLabel];

        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.frame = CGRectMake(ScreenWidth - 7 - 20, 21, 7, 12);
        [self.contentView addSubview:_arrowImageView];
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 53.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}


@end
