//
//  SimilarBookViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SimilarBookViewCell.h"

@interface SimilarBookViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introldLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *chaseLabel;

@end

@implementation SimilarBookViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"SimilarBookViewCell";
    SimilarBookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SimilarBookViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //240 320 200 266
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(10, 10, 100, 133);
        [self.contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] init];
        CGFloat nameLabX = CGRectGetMaxX(_iconImageView.frame) + 5;
        _nameLabel.frame = CGRectMake(nameLabX, 15, ScreenWidth - nameLabX, 20);
        _nameLabel.font = Font15;
        [self.contentView addSubview:_nameLabel];
        
        _introldLabel = [[UILabel alloc] init];
        _introldLabel.font = Font13;
        _introldLabel.textColor= LightTextColor;
        _introldLabel.numberOfLines = 0;
        CGFloat introldLabY = CGRectGetMaxY(_nameLabel.frame) + 10;
        _introldLabel.frame = CGRectMake(nameLabX, introldLabY, ScreenWidth - nameLabX - 10, 70);
        [self.contentView addSubview:_introldLabel];
        
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = Font13;
        _authorLabel.textColor = ADColor(153, 153, 153);
        CGFloat authorLabY = CGRectGetMaxY(_introldLabel.frame) + 5;
        _authorLabel.frame = CGRectMake(nameLabX, authorLabY, ScreenWidth - nameLabX - 10 - 100, 20);
        [self.contentView addSubview:_authorLabel];
        
        _chaseLabel = [[UILabel alloc] init];
        _chaseLabel.textAlignment = NSTextAlignmentRight;
        _chaseLabel.font = Font11;
        _chaseLabel.textColor = ADColor(153, 153, 153);
        CGFloat chaseLabX = CGRectGetMaxX(_authorLabel.frame);
        _chaseLabel.frame = CGRectMake(chaseLabX, authorLabY, 100, 20);
        [self.contentView addSubview:_chaseLabel];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        CGFloat lineLabY = CGRectGetMaxY(_iconImageView.frame) + 10;
        lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
        lineLabel.backgroundColor = LineLabelColor;
        [self.contentView addSubview:lineLabel];
        
    }
    return self;
}

- (void)setModel:(SimilarBookModel *)model{

    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.coverWap] placeholderImage:nil];
    _nameLabel.text = _model.otherName;
    _chaseLabel.text = @"";
    _authorLabel.text = @"";
    _introldLabel.text = @"";
}


@end
