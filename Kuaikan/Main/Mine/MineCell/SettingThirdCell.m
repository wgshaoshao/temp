//
//  SettingThirdCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SettingThirdCell.h"

@implementation SettingThirdCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"SettingThirdCell";
    SettingThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SettingThirdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        _cacheLabel = [[UILabel alloc] init];
        _cacheLabel.frame = CGRectMake(ScreenWidth - 180 - 15, 2, 180, 50);
        _cacheLabel.font = Font14;
        _cacheLabel.textColor = ADColor(153, 153, 153);
        _cacheLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_cacheLabel];
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 53.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}

@end
