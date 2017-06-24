//
//  AllLookCell.m
//  Kuaikan
//
//  Created by 少少 on 16/6/14.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AllLookCell.h"


@implementation AllLookCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"AllLookCell";
    AllLookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AllLookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        CGFloat margin = 20 * KKuaikan;
        CGFloat imageBtnW = (ScreenWidth - 4 * margin) / 3;
        CGFloat imageBtnH = 130;
        
        _firstButton = [[UIButton alloc] init];
        _firstButton.frame = CGRectMake(margin, 10, imageBtnW, imageBtnH);
        [_firstButton addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_firstButton];
        
        _secondButton = [[UIButton alloc] init];
        _secondButton.frame = CGRectMake(imageBtnW + 2 * margin, 10, imageBtnW, imageBtnH);
        [_secondButton addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_secondButton];
        
        _thirdButton = [[UIButton alloc] init];
        _thirdButton.frame = CGRectMake(2 * imageBtnW + 3 * margin, 10, imageBtnW, imageBtnH);
        [_thirdButton addTarget:self action:@selector(thirdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_thirdButton];
        
        _firstImage = [[UIImageView alloc] init];
        _firstImage.frame = CGRectMake(margin, 10, imageBtnW, imageBtnH);
        _firstImage.userInteractionEnabled = NO;
        [self.contentView addSubview:_firstImage];
        
        _secondImagbe = [[UIImageView alloc] init];
        _secondImagbe.frame = CGRectMake(imageBtnW + 2 * margin, 10, imageBtnW, imageBtnH);
        _secondImagbe.userInteractionEnabled = NO;
        [self.contentView addSubview:_secondImagbe];
        
        _thirdImage = [[UIImageView alloc] init];
        _thirdImage.frame = CGRectMake(2 * imageBtnW + 3 * margin, 10, imageBtnW, imageBtnH);
        _thirdImage.userInteractionEnabled = NO;
        [self.contentView addSubview:_thirdImage];
        
        _firstLabel = [[UILabel alloc] init];
        CGFloat nameLabY = CGRectGetMaxY(_firstButton.frame);
        _firstLabel.frame = CGRectMake(margin, nameLabY, imageBtnW, 25);
        _firstLabel.font = Font14;
        _firstLabel.textColor = TextColor;
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_firstLabel];
        
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.frame = CGRectMake(imageBtnW + 2 * margin, nameLabY, imageBtnW, 25);
        _secondLabel.font = Font14;
        _secondLabel.textColor = TextColor;
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_secondLabel];
        
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.frame = CGRectMake(2 * imageBtnW + 3 * margin, nameLabY, imageBtnW, 25);
        _thirdLabel.font = Font14;
        _thirdLabel.textColor = TextColor;
        _thirdLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_thirdLabel];
   
    }
    return self;
}

- (void)firstBtnClick{

    if ([self.delegate respondsToSelector:@selector(allLookCellFirstBtnClick)]) {
        [self.delegate allLookCellFirstBtnClick];
    }
}

- (void)secondBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(allLookCellSecondBtnClick)]) {
        [self.delegate allLookCellSecondBtnClick];
    }
}

- (void)thirdBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(allLookCellThirdBtnClick)]) {
        [self.delegate allLookCellThirdBtnClick];
    }
}

@end
