//
//  CommentFirstViewCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentFirstViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
