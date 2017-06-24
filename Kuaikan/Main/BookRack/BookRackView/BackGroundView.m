//
//  BackGroundView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BackGroundView.h"
#import "UIImageView+LBBlurredImage.h"

@implementation BackGroundView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        //返回按钮
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.frame = CGRectMake(5, 20, 40, 40);
        [backBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = 10;
        [backBtn setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
        backBtn.titleLabel.font = Font14;
        backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:backBtn];

        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)creatView{

    //背景图片
    UIImageView *backGroundImage = [[UIImageView alloc] init];
    backGroundImage.userInteractionEnabled = YES;
    [backGroundImage sd_setImageWithURL:[NSURL URLWithString:_backGroundImage] placeholderImage:[UIImage imageNamed:@"common_bg"]];
    backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    backGroundImage.clipsToBounds = YES;

    backGroundImage.frame = CGRectMake(0, 0, ScreenWidth, 210);
    [self addSubview:backGroundImage];
    
    if (_backGroundImage) {
        [backGroundImage sd_setImageWithURL:[NSURL URLWithString:_backGroundImage] placeholderImage:[UIImage imageNamed:@"common_bg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (backGroundImage.image) {
                [backGroundImage setImageToBlur:backGroundImage.image blurRadius:20 completionBlock:nil];
            }
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Book-details_bg"];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, 210);
    [backGroundImage addSubview:imageView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(5, 20, 40, 40);
    [backBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 10;
    [backBtn setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = Font14;
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:backBtn];
    
    //分享按钮
    _shareBtn = [[UIButton alloc] init];
    _shareBtn.frame = CGRectMake(ScreenWidth - 45, 20, 40, 40);
    [_shareBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.tag = 11;
    [_shareBtn setImage:[UIImage imageNamed:@"Book-details-page_nav_icon_share"] forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = Font14;
    _shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_shareBtn];
    
    self.backgroundColor = [UIColor grayColor];
    
    
    //书籍标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(50, 20, ScreenWidth - 100, 40);
    titleLabel.text = _titleStr;
    titleLabel.font = Font17;
    titleLabel.textColor = WhiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backGroundImage addSubview:titleLabel];
    
    
    //封面图片   200 266
    UIImageView *bookCover = [[UIImageView alloc] init];
    [bookCover sd_setImageWithURL:[NSURL URLWithString:_backGroundImage] placeholderImage:[UIImage imageNamed:@"common_bg"]];
    CGFloat bookCoverY = CGRectGetMaxY(backBtn.frame) + 7;
    bookCover.frame = CGRectMake(10, bookCoverY, 100, 133);
    [backGroundImage addSubview:bookCover];
    
    //作者
    UILabel *authorLabel = [[UILabel alloc] init];
    CGFloat authorLabelX = CGRectGetMaxX(bookCover.frame) + 10;
    NSString *authorStr = [NSString stringWithFormat:@"%@\\著",_authorStr];
    CGFloat authorLabelW = [AppDelegate sizeWithText:authorStr font:Font14 maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    authorLabel.frame = CGRectMake(authorLabelX, bookCoverY + 10, authorLabelW, 20);
    authorLabel.font = Font14;
    authorLabel.text = authorStr;
    authorLabel.textColor = WhiteColor;
    [backGroundImage addSubview:authorLabel];
    
    //字数
    UILabel *bookNumber = [[UILabel alloc] init];
    CGFloat bookNumberX = CGRectGetMaxX(authorLabel.frame) + 10;
    bookNumber.frame = CGRectMake(bookNumberX, bookCoverY + 10, 100, 20);
    bookNumber.font = Font13;
    NSString *bookStr = [NSString stringWithFormat:@"%@字",_bookNumber];
    bookNumber.text = bookStr;
    bookNumber.textColor = WhiteColor;
    [backGroundImage addSubview:bookNumber];
    
    //玄幻|连载中
    UILabel *serialLabel = [[UILabel alloc] init];
    CGFloat serialLabelY = CGRectGetMaxY(authorLabel.frame) + 10;
    NSString *statusStr = @"";
    if (_status) {
        statusStr = @"完本";
    } else {
        statusStr = @"连载";
    }
    NSString *serialStr = [NSString stringWithFormat:@"%@",statusStr];
    
    CGFloat serialLabelW = [AppDelegate sizeWithText:serialStr font:Font14 maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    serialLabel.frame = CGRectMake(authorLabelX, serialLabelY, serialLabelW, 20);
    serialLabel.text = serialStr;
    serialLabel.font = Font14;
    serialLabel.textColor = WhiteColor;
    [backGroundImage addSubview:serialLabel];
    
    //多少人在追
    UILabel *chaseLabel = [[UILabel alloc] init];
    CGFloat chaseLabelX = CGRectGetMaxX(serialLabel.frame) + 10;
    chaseLabel.frame = CGRectMake(chaseLabelX, serialLabelY, 200, 20);
    chaseLabel.font = Font13;
    NSString *chaseStr = [NSString stringWithFormat:@"%@次点击",_clickNum];
    chaseLabel.text = chaseStr;
    chaseLabel.textColor = WhiteColor;
    [backGroundImage addSubview:chaseLabel];
    
    //加书架按钮
    _rackBtn = [[UIButton alloc] init];
    [_rackBtn setTitle:@"加书架" forState:UIControlStateNormal];
    [_rackBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    _rackBtn.titleLabel.font = Font14;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240, 240, 240, 1 });
    [_rackBtn.layer setBorderColor:colorref];//边框颜色
    [_rackBtn.layer setBorderWidth:1.0]; //边框宽度
    CGFloat rackBtnY = CGRectGetMaxY(serialLabel.frame) + 20;
    _rackBtn.frame = CGRectMake(authorLabelX, rackBtnY, (ScreenWidth - bookCover.frame.size.width - 20 -20)/2, 40);
    _rackBtn.tag = 12;
    [_rackBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundImage addSubview:_rackBtn];
    
    //开始阅读按钮
    UIButton *beginRedBtn = [[UIButton alloc] init];
    [beginRedBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    [beginRedBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [beginRedBtn.layer setBorderColor:colorref];//边框颜色
    [beginRedBtn.layer setBorderWidth:1.0]; //边框宽度
    beginRedBtn.titleLabel.font = Font14;
    CGFloat beginRedBtnX = authorLabelX + 10 + (ScreenWidth - bookCover.frame.size.width - 20 -20)/2;
    beginRedBtn.frame = CGRectMake(beginRedBtnX, rackBtnY, (ScreenWidth - bookCover.frame.size.width - 20 -20)/2, 40);
    beginRedBtn.tag = 13;
    [beginRedBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundImage addSubview:beginRedBtn];
}



- (void)backGroundBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(backGroundViewBtnClick:)]) {
        [self.delegate backGroundViewBtnClick:button];
    }
}



@end
