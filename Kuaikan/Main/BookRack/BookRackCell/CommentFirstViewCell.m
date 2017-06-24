//
//  CommentFirstViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CommentFirstViewCell.h"

@implementation CommentFirstViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"CommentFirstViewCell";
    CommentFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentFirstViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font16;
        _titleLabel.frame = CGRectMake(10, 10, 150, 30);
        [self.contentView addSubview:_titleLabel];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(0, 17, 2, 17);
        lineLabel.backgroundColor = ADColor(53, 137, 238);
        [self.contentView addSubview:lineLabel];
        
    }
    return self;
}

- (void)setTitleLabel:(UILabel *)titleLabel{

    _titleLabel = titleLabel;
    _titleLabel.text = titleLabel.text;
}



@end
