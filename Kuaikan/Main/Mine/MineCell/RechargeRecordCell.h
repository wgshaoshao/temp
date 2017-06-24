//
//  RechargeRecordCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"

@interface RechargeRecordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *suceessLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *lookLabel;
@property (nonatomic, strong) UILabel *presentLabel;

@property (nonatomic, strong) RechargeModel *model;

@end
