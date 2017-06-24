//
//  SettingFirestCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingFirestCellDelegate <NSObject>

- (void)settingFirstBtnClick:(UISwitch *)mySwitch;

@end

@interface SettingFirestCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) id<SettingFirestCellDelegate>delegate;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, assign) NSInteger index;
@end
