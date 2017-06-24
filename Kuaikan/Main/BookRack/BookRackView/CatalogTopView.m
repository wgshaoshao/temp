//
//  CatalogTopView.m
//  Kuaikan
//
//  Created by 少少 on 16/11/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CatalogTopView.h"

@implementation CatalogTopView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = BackViewColor;
        
    }
    return self;
}


- (void)creatView{
    if (_totalLabel) {
        [_totalLabel removeFromSuperview];
    }
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.font = Font16;
    _totalLabel.text = [NSString stringWithFormat:@"共%@章",_totalStr];
    _totalLabel.textColor = LightTextColor;
    _totalLabel.frame = CGRectMake(15, 10, 200, 40);
    [self addSubview:_totalLabel];
    
    
    if (_chapterBtn) {
        [_chapterBtn removeFromSuperview];
    }
    _chapterBtn = [[UIButton alloc] init];
    _chapterBtn.backgroundColor = WhiteColor;
    [self addSubview:_chapterBtn];
    
    
    if (_chapterLabel) {
        [_chapterLabel removeFromSuperview];
    }
    _chapterLabel = [[UILabel alloc] init];
    _chapterLabel.font = Font16;
    _chapterLabel.textColor = LightTextColor;
    _chapterLabel.text = _chapterStr;
    CGFloat chapterLabelW = [self sizeWithText:_chapterStr font:Font16 maxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
    _chapterLabel.frame = CGRectMake(10, 5, chapterLabelW, 30);
    [_chapterBtn addSubview:_chapterLabel];
    
    
    if (_imageView) {
        [_imageView removeFromSuperview];
    }
    _imageView = [[UIImageView alloc] init];
    CGFloat imageViewX = CGRectGetMaxX(_chapterLabel.frame) + 10;
    _imageView.frame = CGRectMake(imageViewX, 16, 7, 7);
    _imageView.image = [UIImage imageNamed:@"a_def_Catalog_n"];
    [_chapterBtn addSubview:_imageView];
    
    
    CGFloat chapterBtnW = chapterLabelW + 7 + 30;
    _chapterBtn.frame = CGRectMake(ScreenWidth - chapterLabelW - 60, 10, chapterBtnW, 40);
    [_chapterBtn addTarget:self action:@selector(chapterBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chapterBtnClick{

    if ([self.delegate respondsToSelector:@selector(catalogTopViewBtnClick)]) {
        [self.delegate catalogTopViewBtnClick];
    }
}


//根据字数计算高度、长度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
