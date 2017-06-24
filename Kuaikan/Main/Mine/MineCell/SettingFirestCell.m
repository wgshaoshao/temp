//
//  SettingFirestCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SettingFirestCell.h"

@implementation SettingFirestCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = @"SettingFirestCell";
    SettingFirestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SettingFirestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.frame = CGRectMake(10, 7, 30, 30);
//        [self.contentView addSubview:_iconImageView];
//        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font15;
//        CGFloat titleX = CGRectGetMaxX(_iconImageView.frame) + 10;
        _titleLabel.frame = CGRectMake(15, 2, 150, 50);
        [self.contentView addSubview:_titleLabel];

        _mySwitch = [[UISwitch alloc] init];
        _mySwitch.frame = CGRectMake(ScreenWidth - 50 - 15, 10, 50, 30);
        [_mySwitch addTarget:self action:@selector(mySwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
            [_mySwitch setOn:YES animated:YES];
            
        } else {
            [_mySwitch setOn:NO animated:YES];
        }
        
        [self.contentView addSubview:_mySwitch];
        
        UILabel *lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = LineLabelColor;
        lineLab.frame = CGRectMake(0, 53.5, ScreenWidth, 0.5);
        [self.contentView addSubview:lineLab];
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    _mySwitch.tag = index;
}

- (void)mySwitchClick:(UISwitch *)mySwitch{

    if ([self.delegate respondsToSelector:@selector(settingFirstBtnClick:)]) {
        [self.delegate settingFirstBtnClick:mySwitch];
    }
}

@end
