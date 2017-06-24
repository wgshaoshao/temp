//
//  ActivityViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"ActivityViewCell";
    ActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ActivityViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.frame = CGRectMake(15, 20, ScreenWidth - 30, 110 * KKuaikan);
//        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_backImageView];
        
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.font = Font14;
//        _titleLabel.backgroundColor = ADColorRGBA(100, 100, 100, 0.5);
//        _titleLabel.textColor = WhiteColor;
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.frame = CGRectMake(0, 180 - 25, ScreenWidth - 20, 25);
//        [_backImageView addSubview:_titleLabel];
        
        _summeryLabel = [[UILabel alloc] init];
        CGFloat summeryLabelY = CGRectGetMaxY(_backImageView.frame) + 8;
        _summeryLabel.frame = CGRectMake(15, summeryLabelY, ScreenWidth - 30, 20);
        _summeryLabel.textColor = LightTextColor;
        _summeryLabel.font = Font14;
//        _summeryLabel.layer.borderWidth = 1;
//        _summeryLabel.layer.borderColor = [LineLabelColor CGColor];
        [self.contentView addSubview:_summeryLabel];
        
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"查看详情";
        detailLabel.font = Font16;
        detailLabel.textColor = ADColor(51, 51, 51);

        CGFloat detailLabelY = CGRectGetMaxY(_summeryLabel.frame) - 1;
        detailLabel.frame = CGRectMake(15, detailLabelY, ScreenWidth - 30, 30);
        [self.contentView addSubview:detailLabel];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"me_def_icon"];
        imageView.frame = CGRectMake(ScreenWidth - 14 - 10, detailLabelY + 15, 7, 12);
        [self.contentView addSubview:imageView];
        
        UIView *lineLabel = [[UIView alloc] init];
        CGFloat lineLabelY = CGRectGetMaxY(detailLabel.frame) + 5;
        lineLabel.frame = CGRectMake(0, lineLabelY, ScreenWidth, 0.5);
        lineLabel.backgroundColor = LineLabelColor;
        [self.contentView addSubview:lineLabel];
        
    
    }
    return self;
}

- (void)setModel:(ActicityModel *)model{

    _model = model;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:model.activityImage] placeholderImage:nil];
//    _titleLabel.text = model.activitySummary;
    _summeryLabel.text = model.activitySummary;
}

@end
