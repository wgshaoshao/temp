//
//  CancelAutoBuyCell.m
//  Kuaikan
//
//  Created by 少少 on 16/6/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CancelAutoBuyCell.h"

@implementation CancelAutoBuyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"CancelAutoBuyCell";
    CancelAutoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CancelAutoBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Font15;
        _nameLabel.frame = CGRectMake(20, 0, ScreenWidth - 100, 54);
        [self.contentView addSubview:_nameLabel];
        
        _mySwitch = [[UISwitch alloc] init];
        _mySwitch.frame = CGRectMake(ScreenWidth - 60 - 10, 10, 50, 34);
        [self.contentView addSubview:_mySwitch];

        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 53.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
    }
    return self;
}



@end
