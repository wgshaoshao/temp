//
//  UserViewCell.h
//  爱动
//
//  Created by shaoshao on 15/6/3.
//  Copyright (c) 2015年 aidong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@end
