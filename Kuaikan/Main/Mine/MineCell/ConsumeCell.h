//
//  ConsumeCell.h
//  Kuaikan
//
//  Created by 少少 on 16/6/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeModel.h"

@interface ConsumeCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *suceessLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *lookLabel;
@property (nonatomic, strong) UILabel *presentLabel;

@property (nonatomic, strong) ConsumeModel *model;
@end
