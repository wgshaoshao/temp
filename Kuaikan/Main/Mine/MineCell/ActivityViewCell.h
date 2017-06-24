//
//  ActivityViewCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActicityModel.h"

@interface ActivityViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *summeryLabel;
@property (nonatomic, strong) ActicityModel *model;
@end
