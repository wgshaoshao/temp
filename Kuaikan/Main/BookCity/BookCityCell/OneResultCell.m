//
//  OneResultCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "OneResultCell.h"


@interface OneResultCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextView *introldLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *chaseLabel;

@end

@implementation OneResultCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"OneResultCell";
    OneResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OneResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        CGFloat nameLabX = CGRectGetMaxX(_iconImageView.frame) + 8;
        _nameLabel.frame = CGRectMake(nameLabX + 4, 15, ScreenWidth - nameLabX, 20);
        _nameLabel.font = Font15;
        [self.contentView addSubview:_nameLabel];
        
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = Font13;
        _authorLabel.textColor = ADColor(153, 153, 153);
        CGFloat authorLabY = CGRectGetMaxY(_nameLabel.frame) + 5;
        _authorLabel.frame = CGRectMake(nameLabX + 4, authorLabY, ScreenWidth - nameLabX - 10 - 80, 20);
        [self.contentView addSubview:_authorLabel];
        
        _introldLabel = [[UITextView alloc] init];
        _introldLabel.font = Font13;
        _introldLabel.editable = NO;
//        _introldLabel.backgroundColor = [UIColor redColor];
        _introldLabel.scrollEnabled = NO;
        _introldLabel.userInteractionEnabled = NO;
        _introldLabel.textColor = ADColor(153, 153, 153);
        CGFloat introldLabY = CGRectGetMaxY(_authorLabel.frame);
        _introldLabel.frame = CGRectMake(nameLabX, introldLabY, ScreenWidth - nameLabX - 10, 90);
        [self.contentView addSubview:_introldLabel];
    
        
//        _chaseLabel = [[UILabel alloc] init];
//        _chaseLabel.textAlignment = NSTextAlignmentRight;
//        _chaseLabel.font = Font11;
//        _chaseLabel.textColor = ADColor(153, 153, 153);
//        CGFloat chaseLabX = CGRectGetMaxX(_authorLabel.frame);
//        _chaseLabel.frame = CGRectMake(chaseLabX, authorLabY, 80, 20);
//        [self.contentView addSubview:_chaseLabel];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        CGFloat lineLabY = CGRectGetMaxY(_iconImageView.frame) + 10;
        lineLabel.frame = CGRectMake(0, lineLabY, ScreenWidth, 0.5);
        lineLabel.backgroundColor = LineLabelColor;
        [self.contentView addSubview:lineLabel];
        
    }
    return self;
}

- (void)setModel:(OneResultModel *)model{
    
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.coverWap] placeholderImage:nil];
    _nameLabel.text = _model.bookName;
    _authorLabel.text = [NSString stringWithFormat:@"%@\\著",_model.author];
    _introldLabel.text = _model.introduction;
}

@end
