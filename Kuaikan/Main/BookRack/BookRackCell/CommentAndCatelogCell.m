//
//  CommentAndCatelogCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CommentAndCatelogCell.h"

#define CommentAndCatelog      [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]

@implementation CommentAndCatelogCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"CommentAndCatelogCell";
    CommentAndCatelogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentAndCatelogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font16;
        _titleLabel.backgroundColor = CommentAndCatelog;
        _titleLabel.frame = CGRectMake(0, 0, ScreenWidth, 44);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitleLabel:(UILabel *)titleLabel{

    _titleLabel = titleLabel;
    _titleLabel.text = titleLabel.text;
}



@end
