//
//  OneResultCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneResultModel.h"

@interface OneResultCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) OneResultModel *model;

@end
