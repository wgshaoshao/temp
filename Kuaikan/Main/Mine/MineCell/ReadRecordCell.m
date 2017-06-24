//
//  ReadRecordCell.m
//  Kuaikan
//
//  Created by 少少 on 16/5/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ReadRecordCell.h"

@implementation ReadRecordCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ReadRecordCell";
    ReadRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ReadRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
            make.width.equalTo(_coverImageView.mas_height).multipliedBy(0.75);
        }];
        
        _bookNameLab = [[UILabel alloc] init];
        _bookNameLab.font = Font14;
        _bookNameLab.textColor = TextColor;
        [self.contentView addSubview:_bookNameLab];
        [_bookNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.left.equalTo(_coverImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.mas_equalTo(21);
        }];
        
        _authorLab = [[UILabel alloc] init];
        _authorLab.font = Font14;
        _authorLab.textColor = LightTextColor;
        [self.contentView addSubview:_authorLab];
        [_authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bookNameLab.mas_bottom).with.offset(0);
            make.left.equalTo(_coverImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.mas_equalTo(21);
        }];

        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.font = Font14;
        _chapterLabel.textColor = LightTextColor;
        _chapterLabel.numberOfLines = 0;
        _chapterLabel.lineBreakMode = NSLineBreakByClipping;
        [self.contentView addSubview:_chapterLabel];
        [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorLab.mas_bottom).with.offset(0);
            make.left.equalTo(_coverImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        _continueReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueReadBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
        [_continueReadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _continueReadBtn.titleLabel.font = Font14;
        _continueReadBtn.layer.borderColor = [UIColor redColor].CGColor;
        _continueReadBtn.layer.borderWidth = 1.0;
        _continueReadBtn.layer.cornerRadius = 10.5;
        [self.contentView addSubview:_continueReadBtn];
        [_continueReadBtn addTarget:self action:@selector(continueRead) forControlEvents:UIControlEventTouchUpInside];
        [_continueReadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 21));
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
    }
    return self;
}

- (void)setModel:(BookInforModel *)model{
    
    _model = model;
    
    _authorLab.text = _model.author;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_model.coverurl] placeholderImage:[UIImage imageNamed:@"common_bg"]];
    _authorLab.text = _model.author;
    _bookNameLab.text = _model.bookName;
    
    _model.introuce = [_model.introuce stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _model.introuce = [_model.introuce stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _model.introuce = [_model.introuce stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _chapterLabel.text = _model.introuce;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _chapterLabel.text = [self getWidthWithLabel:_chapterLabel];
    
    if (_model.isAddBook && [_model.isAddBook isEqual:@1]) {
        [_continueReadBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
    }else {
        [_continueReadBtn setTitle:@"加入书架" forState:UIControlStateNormal];
    }

}

- (NSString *)getWidthWithLabel:(UILabel *)label {
    
    NSString *temp = nil;
    NSString *temp1 = label.text;
    CGFloat length = 0;
    
    for (int i = 0; i < [label.text length]; i++) {
        
        temp = [label.text substringWithRange:NSMakeRange(i,1)];
        CGSize size = [temp boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
        length += size.width;
        if (length >= 2.2 * label.frame.size.width) {
            temp1= [[label.text substringToIndex:i - 4] stringByAppendingString:@"..."];
            return temp1;
        }
        
    }
    return temp1;
}

- (void)continueRead {
    
    if (_readBlock) {
        _readBlock();
    }
}

@end
