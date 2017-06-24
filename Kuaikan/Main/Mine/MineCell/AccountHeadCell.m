//
//  AccountHeadCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AccountHeadCell.h"

@implementation AccountHeadCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"AccountHeadCell";
    AccountHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AccountHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = Font15;
        _headLabel.text = @"头像";
        _headLabel.textColor = ADColor(153, 153, 153);
        [self.contentView addSubview:_headLabel];
        _headLabel.frame = CGRectMake(15, 0, 40, 78);
        
        _headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        CGFloat headImageViewX = CGRectGetMaxX(_headLabel.frame) + 10;
        _headImageView.frame = CGRectMake(headImageViewX, 12, 54, 54);
        _headImageView.layer.masksToBounds = YES; //没这句话它圆不起来
        _headImageView.layer.cornerRadius = 27.0; //设置图片圆角的尺度
        
        _btnImageView = [[UIImageView alloc] init];
        _btnImageView.image = [UIImage imageNamed:@"My-account_icon_camera"];
        [self.contentView addSubview:_btnImageView];
        _btnImageView.frame = CGRectMake(ScreenWidth - 20 - 15, 29, 20, 20);
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0,77.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
        
    }
    
    return self;
}

@end
