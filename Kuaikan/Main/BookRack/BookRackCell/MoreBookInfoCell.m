//
//  MoreBookInfoCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/9.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "MoreBookInfoCell.h"

@implementation MoreBookInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"MoreBookInfoCell";
    MoreBookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MoreBookInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _copRightLab = [[UILabel alloc] init];
        _copRightLab.font = Font11;
        _copRightLab.textColor = ADColor(153, 153, 153);
        _copRightLab.frame = CGRectMake(10, 5, 250, 20);
        [self.contentView addSubview:_copRightLab];
        
        UILabel *copTitleLab = [[UILabel alloc] init];
        copTitleLab.font = Font11;
        copTitleLab.text = @"版权所有-侵权必究";
        copTitleLab.textColor = ADColor(153, 153, 153);
        CGFloat copTitleLabY = CGRectGetMaxY(_copRightLab.frame) + 5;
        copTitleLab.frame = CGRectMake(10, copTitleLabY, 200, 20);
        [self.contentView addSubview:copTitleLab];
    }
    return self;
}



@end
