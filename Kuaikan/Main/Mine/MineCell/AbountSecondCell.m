//
//  AbountSecondCell.m
//  Kuaikan
//
//  Created by 少少 on 16/5/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AbountSecondCell.h"

@implementation AbountSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"AbountSecondCell";
    AbountSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AbountSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font13;
        titleLabel.text = @"点众科技   版权所有";
        titleLabel.textColor = ADColor(172, 172, 172);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 20, ScreenWidth, 15);
        [self.contentView addSubview:titleLabel];
        
        UILabel *summeryLabel = [[UILabel alloc] init];
        CGFloat summeryLabelY = CGRectGetMaxY(titleLabel.frame) + 5;
        summeryLabel.frame = CGRectMake(0, summeryLabelY, ScreenWidth, 15);
        summeryLabel.font = Font13;
        summeryLabel.textColor = ADColor(172, 172, 172);
        summeryLabel.text = @"Copyright@©2017 Dianzhong";
        summeryLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:summeryLabel];
        
        UILabel *secondLabel = [[UILabel alloc] init];
        CGFloat secondLabelY = CGRectGetMaxY(summeryLabel.frame) + 5;
        secondLabel.frame = CGRectMake(0, secondLabelY, ScreenWidth, 15);
        secondLabel.font = Font13;
        secondLabel.textColor = ADColor(172, 172, 172);
        secondLabel.text = @"All Rights Reservrd";
        secondLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:secondLabel];
        
    }
    return self;
}

@end
