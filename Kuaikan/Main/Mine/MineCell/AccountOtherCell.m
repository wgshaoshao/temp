//
//  AccountOtherCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AccountOtherCell.h"


@implementation AccountOtherCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"AccountOtherCell";
    AccountOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AccountOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = Font15;
        _titleLab.textColor = ADColor(153, 153, 153);
        [self.contentView addSubview:_titleLab];
        _titleLab.frame = CGRectMake(15, 12, 30, 30);
        
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = Font15;
        _contentLab.textColor = TextColor;
        [self.contentView addSubview:_contentLab];
        CGFloat contentX = CGRectGetMaxX(_titleLab.frame) + 10;
        _contentLab.frame = CGRectMake(contentX, 12, ScreenWidth - contentX - 30 - 20, 30);
        
        _btnImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_btnImageView];
        _btnImageView.frame = CGRectMake(ScreenWidth - 20 - 15, 17, 20, 20);
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 53.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
    
    }
    return self;
}

@end
