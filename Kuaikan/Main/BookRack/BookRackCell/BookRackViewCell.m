//
//  BookRackViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/9.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookRackViewCell.h"

@implementation BookRackViewCell

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 84 * KKuaikan, 115 * KKuaikan)];
        [self.contentView addSubview:_coverImageView];
        
        _cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34 * KKuaikan, 0, 50 * KKuaikan, 50 * KKuaikan)];
        [_coverImageView addSubview:_cornerImageView];
        
        CGFloat bookNameLabY = CGRectGetMaxY(_coverImageView.frame) + 7;
        _bookNameLab = [[UILabel alloc] initWithFrame:CGRectMake(-6 * KKuaikan, bookNameLabY, 98 * KKuaikan, 15)];
        _bookNameLab.font = Font15;
        _bookNameLab.textAlignment = NSTextAlignmentCenter;
        _bookNameLab.textColor = LightTextColor;
        [self.contentView addSubview:_bookNameLab];
        
        
        if (IPAD) {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CollectionCellWIPad - 45, 115 * KKuaikan - 30, 30, 30)];
        } else {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CollectionCellW - 45, 115 * KKuaikan - 30, 30, 30)];
        }
        [self.contentView addSubview:_deleteBtn];
    }
    
    return self;
}


- (void)setModel:(BookInforModel *)model{
    
    if (_index == _arrayCount - 1) {
        if (_isShow) {
            _coverImageView.image = [UIImage imageNamed:@""];
            _bookNameLab.text = @"";
            [_deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _cornerImageView.image = [UIImage imageNamed:@""];
        } else {
            _coverImageView.image = [UIImage imageNamed:@"bookshelf_Add-to"];
            _bookNameLab.text = @"";
            [_deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _cornerImageView.image = [UIImage imageNamed:@""];
        }
        
    } else {
        _model = model;
        
        if (_isShow) {
            
        } else {
            [_deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        
        
        
        if (_updateOneChapter) {
            _cornerImageView.image = [UIImage imageNamed:@""];
            _isShowUpdate = NO;
        } else {
            if (_updateArray.count) {
                
                
                
                
                for (int i = 0; i < _updateArray.count; i ++) {
                    NSDictionary *dict =  _updateArray[i];
                    
                    NSString *newChapter = [NSString stringWithFormat:@"%@",dict[@"newChapter"]];
                    
                    NSString *bookId = [NSString stringWithFormat:@"%@",dict[@"bookId"]];
                    
                    
                    
                    if ([bookId isEqualToString:model.bookid]) {
                        if ([newChapter isEqualToString:@"0"]) {//图书有更新
                            _cornerImageView.image = [UIImage imageNamed:@"icon_corner"];
                            _isShowUpdate = YES;
                        }  else {
                            _cornerImageView.image = [UIImage imageNamed:@""];
                            _isShowUpdate = NO;
                        }
                    }
                }
            } else {
                _cornerImageView.image = [UIImage imageNamed:@""];
                _isShowUpdate = NO;
            }
        }
        
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
        BookInforModel *book = [dataManager getBookWithBookId:model.bookid];
        if ([book.marketStatus isEqualToNumber:@(3)]) {//图书限免
            _cornerImageView.image = [UIImage imageNamed:@"icon_free"];
            _isShowUpdate = YES;
        }
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverurl] placeholderImage:[UIImage imageNamed:@"common_bg"]];
        _bookNameLab.text = model.bookName;
    }
    
    
    
}

@end
