//
//  AccountHeadCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountHeadCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *btnImageView;

@end
