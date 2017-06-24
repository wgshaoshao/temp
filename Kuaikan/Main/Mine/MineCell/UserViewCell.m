//
//  UserViewCell.m
//  爱动
//
//  Created by shaoshao on 15/6/3.
//  Copyright (c) 2015年 aidong. All rights reserved.
//

#import "UserViewCell.h"

@implementation UserViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"UserViewCell";
    UserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat padding = 8.5;
        
        CGFloat iconImageS = 24;
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.frame = CGRectMake(15, padding + 6.5, iconImageS, iconImageS);
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = Font15;
        _contentLabel.textColor = TextColor;
        [self.contentView addSubview:_contentLabel];
        CGFloat contentLabX = CGRectGetMaxX(_iconImageView.frame) + 10;
        _contentLabel.frame = CGRectMake(contentLabX, 2 * padding, ScreenWidth - 100, 20);
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(20, 53.5, ScreenWidth - 20, 0.5);
        [self.contentView addSubview:lineLab];

    }
    
    return self;
}


@end
