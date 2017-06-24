//
//  AboutFirstCell.m
//  Kuaikan
//
//  Created by 少少 on 16/5/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AboutFirstCell.h"

@implementation AboutFirstCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"AboutFirstCell";
    AboutFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AboutFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.frame = CGRectMake((ScreenWidth - 68) / 2, 30, 68, 68);
        _backImageView.image = [UIImage imageNamed:@"kuaikan_icon@2x"];
        [self.contentView addSubview:_backImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = Font16;
        titleLabel.text = @"快看阅读";
        titleLabel.textColor = TextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat titleLabelY = CGRectGetMaxY(_backImageView.frame) + 15;
        titleLabel.frame = CGRectMake(0, titleLabelY, ScreenWidth, 15);
        [self.contentView addSubview:titleLabel];
        
        UILabel *summeryLabel = [[UILabel alloc] init];
        CGFloat summeryLabelY = CGRectGetMaxY(titleLabel.frame) + 10;
        summeryLabel.frame = CGRectMake(0, summeryLabelY, ScreenWidth, 15);
        summeryLabel.font = Font15;
        summeryLabel.textColor = TextColor;
        summeryLabel.text = [NSString stringWithFormat:@"版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        summeryLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:summeryLabel];
        
    }
    return self;
}


@end
