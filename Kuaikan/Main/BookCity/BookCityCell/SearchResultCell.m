//
//  SearchResultCell.m
//  Kuaikan
//
//  Created by 少少 on 16/3/31.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SearchResultCell.h"

@interface SearchResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *resultText;

@end

@implementation SearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SearchModel *)model{
    
    _model = model ;
    
    _resultText.text = _model.resultName;
    
    [_resultImage sd_setImageWithURL:[NSURL URLWithString:_model.resultImageUrl] placeholderImage:[UIImage imageNamed:@""]];
}

@end
