//
//  UserHelpCell.m
//  Kuaikan
//
//  Created by 少少 on 16/5/18.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "UserHelpCell.h"

@implementation UserHelpCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"UserHelpCell";
    UserHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UserHelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font13;
        titleLabel.textColor = ADColor(172, 172, 172);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(10, 0, ScreenWidth - 20, 30);
        [self.contentView addSubview:titleLabel];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = LineLabelColor;
        CGFloat lineLabelY = CGRectGetMaxY(titleLabel.frame);
        lineLabel.frame = CGRectMake(0, lineLabelY, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLabel];
        
        UILabel *summeryLabel = [[UILabel alloc] init];
        CGFloat summeryLabelY = CGRectGetMaxY(titleLabel.frame) + 5;
        summeryLabel.frame = CGRectMake(10, summeryLabelY, ScreenWidth - 20, 15);
        summeryLabel.font = Font13;
        summeryLabel.textColor = ADColor(172, 172, 172);
        summeryLabel.text = @"Copyright@©2015 Dianzhong";
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
