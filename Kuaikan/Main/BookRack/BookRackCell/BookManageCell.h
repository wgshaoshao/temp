//
//  BookManageCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookManageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *bookNameLab;
@property (nonatomic, strong) UILabel *updateChapterLab;
@property (nonatomic, strong) UILabel *authorLab;
@property (nonatomic, strong) UIButton *isSelectBtn
;
@property (nonatomic, strong) BookInforModel *model;
@end
