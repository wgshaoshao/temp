//
//  BookManageCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookManageCell.h"

@implementation BookManageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"BookManageCell";
    BookManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BookManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.frame = CGRectMake(15, 10, 60, 80);
        [self.contentView addSubview:_coverImageView];
        
        _bookNameLab = [[UILabel alloc] init];
        _bookNameLab.font = Font15;
        _bookNameLab.textColor = LightTextColor;
        CGFloat bookNameLabX = CGRectGetMaxX(_coverImageView.frame) + 10;
        _bookNameLab.frame = CGRectMake(bookNameLabX, 17, ScreenWidth - bookNameLabX - 30, 15);
        [self.contentView addSubview:_bookNameLab];
        
        _updateChapterLab = [[UILabel alloc] init];
        _updateChapterLab.font = Font13;
        _updateChapterLab.textColor = ADColor(153, 153, 153);

        CGFloat updateChapterLabY = CGRectGetMaxY(_bookNameLab.frame) + 10;
        _updateChapterLab.frame = CGRectMake(bookNameLabX, updateChapterLabY, ScreenWidth - bookNameLabX, 15);
        [self.contentView addSubview:_updateChapterLab];
        
        _authorLab = [[UILabel alloc] init];
        CGFloat authorLabY = CGRectGetMaxY(_updateChapterLab.frame) + 10;
        _authorLab.font = Font13;
        _authorLab.textColor = ADColor(153, 153, 153);
        _authorLab.frame = CGRectMake(bookNameLabX, authorLabY, ScreenWidth - bookNameLabX, 20);
        [self.contentView addSubview:_authorLab];
        
        _isSelectBtn = [[UIButton alloc] init];
        _isSelectBtn.frame = CGRectMake(ScreenWidth - 30 - 20, 35, 30, 30);
        [_isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
        _isSelectBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_isSelectBtn];
    }
    
    return self;
}


- (void)setModel:(BookInforModel *)model{
    
    _model = model;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverurl] placeholderImage:[UIImage imageNamed:@"common_bg"]];
    
    _bookNameLab.text = model.bookName;
    //    _updateChapterLab.text = model.updateChapter;
    _authorLab.text = model.author;
    
    
}

@end
