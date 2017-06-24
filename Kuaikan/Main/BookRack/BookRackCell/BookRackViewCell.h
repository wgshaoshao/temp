//
//  BookRackViewCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/9.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookRackViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *bookNameLab;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *cornerImageView;
@property (nonatomic, strong) BookInforModel *model;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isShowUpdate;
@property (nonatomic, strong) NSArray *updateArray;
@property (nonatomic, assign) BOOL updateOneChapter;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger arrayCount;
@property (nonatomic, strong) NSMutableDictionary *deleteDict;

@end
