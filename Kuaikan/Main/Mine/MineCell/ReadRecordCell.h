//
//  ReadRecordCell.h
//  Kuaikan
//
//  Created by 少少 on 16/5/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadRecordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *bookNameLab;
@property (nonatomic, strong) UILabel *authorLab;
@property (nonatomic, strong) UILabel *chapterLabel;        // 阅读至：章节
@property (nonatomic, strong) UIButton *continueReadBtn;    // 继续阅读
typedef void(^ReadBlock)();
@property (nonatomic, copy) ReadBlock readBlock;


@property (nonatomic, strong) BookInforModel *model;
@end
