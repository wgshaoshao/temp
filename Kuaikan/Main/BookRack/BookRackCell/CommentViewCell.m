//
//  CommentViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CommentViewCell.h"

@interface CommentViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CommentViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"CommentViewCell";
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(10, 6, ScreenWidth - 20, 20);
        _nameLabel.font = Font14;
        _nameLabel.textColor = LightTextColor;
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] init];
        CGFloat contentLabY = CGRectGetMaxY(_nameLabel.frame) + 5;
        _contentLabel.frame = CGRectMake(10, contentLabY, ScreenWidth - 20, 20);
        _contentLabel.textColor = LightTextColor;
        _contentLabel.font = Font14;
        [self.contentView addSubview:_contentLabel];
        
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(0, 59.5, ScreenWidth, 0.5);
        lineLabel.backgroundColor = LineLabelColor;
        [self.contentView addSubview:lineLabel];
        
    }
    return self;
}

- (void)setModel:(CommentModel *)model{

    _model = model;
    _nameLabel.text = _model.person;
    _contentLabel.text = _model.bookComment;
}


@end
