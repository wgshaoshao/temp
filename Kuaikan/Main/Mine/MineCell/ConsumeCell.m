//
//  ConsumeCell.m
//  Kuaikan
//
//  Created by 少少 on 16/6/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ConsumeCell.h"

@implementation ConsumeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"ConsumeCell";
    ConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ConsumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _suceessLabel = [[UILabel alloc] init];
        _suceessLabel.frame = CGRectMake(10, 10, 250, 20);
        _suceessLabel.font = Font14;
        _suceessLabel.textColor = ADColor(51, 51, 51);
        [self.contentView addSubview:_suceessLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = Font12;
        _timeLabel.textColor = LightTextColor;
        CGFloat titleY = CGRectGetMaxY(_suceessLabel.frame) + 5;
        _timeLabel.frame = CGRectMake(10, titleY, 200, 20);
        [self.contentView addSubview:_timeLabel];
        
        _lookLabel = [[UILabel alloc] init];
        _lookLabel.font = Font14;
        _lookLabel.textColor = ADColor(51, 51, 51);
        _lookLabel.textAlignment = NSTextAlignmentRight;
        _lookLabel.frame = CGRectMake(ScreenWidth - 100 - 10, 10, 100, 20);
        [self.contentView addSubview:_lookLabel];
        
        _presentLabel = [[UILabel alloc] init];
        _presentLabel.font = Font12;
        _presentLabel.textColor = LightTextColor;
        _presentLabel.textAlignment = NSTextAlignmentRight;
        _presentLabel.frame = CGRectMake(ScreenWidth - 100 - 10, titleY, 100, 20);
        [self.contentView addSubview:_presentLabel];
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 64.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}

- (void)setModel:(ConsumeModel *)model{

    _model = model;
    
    _suceessLabel.text = model.bookName;
    _timeLabel.text = model.orderTime;
    _lookLabel.text = [NSString stringWithFormat:@"%@%@",model.payPrice,model.payUnit];
    _presentLabel.text = model.unitTips;
}
@end
