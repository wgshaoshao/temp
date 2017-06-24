//
//  CancelAutoBuyCell.h
//  Kuaikan
//
//  Created by 少少 on 16/6/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeModel.h"

@interface CancelAutoBuyCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UISwitch *mySwitch;
@end
