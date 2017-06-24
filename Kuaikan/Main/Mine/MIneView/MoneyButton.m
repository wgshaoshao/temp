//
//  MoneyButton.m
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "MoneyButton.h"

@implementation MoneyButton

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{
    
    self.backgroundColor = WhiteColor;

    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.frame = CGRectMake(5, 6, self.frame.size.width - 2 * 5, 30);
    _moneyLabel.textColor = TextColor;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLabel];
    
    _bottomLabel = [[UILabel alloc] init];
    CGFloat bottomLabelY = CGRectGetMaxY(_moneyLabel.frame) + 2;
    _bottomLabel.frame = CGRectMake(0, bottomLabelY, self.frame.size.width, 25);
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    if (ScreenWidth == 320) {
        _moneyLabel.font = Font16;

        _bottomLabel.font = Font13;
    } else {
        _moneyLabel.font = Font17;

        _bottomLabel.font = Font14;
    }
    [self addSubview:_bottomLabel];
    
    _sectImageView = [[UIImageView alloc] init];
    _sectImageView.frame = CGRectMake(self.frame.size.width - 20, self.frame.size.height - 20, 20, 20);
    [self addSubview:_sectImageView];
    
    [self addTarget:self action:@selector(selfClick:) forControlEvents:UIControlEventTouchUpInside];
//    [headImage.layer setBorderColor:colorref];//边框颜色
//    [headImage.layer setBorderWidth:1.0]; //边框宽度
}

- (void)setBottomLabel:(UILabel *)bottomLabel{
    
    
    NSString *electStr = bottomLabel.text;
    NSMutableAttributedString *electStrs = [[NSMutableAttributedString alloc] initWithString:electStr];
    [electStrs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    _bottomLabel.attributedText = electStrs;
    
}

- (void)selfClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(moneyButtonClick:)]) {
        [self.delegate moneyButtonClick:button];
    }
}

- (void)setIsSected:(BOOL)isSected{

    if (isSected) {
//        self.backgroundColor = WhiteColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = ADColor(246, 155, 62).CGColor;
    } else {
//        self.backgroundColor = ADColor(244, 244, 244);
        self.layer.borderWidth = 0;
        self.layer.borderColor = ADColor(246, 155, 62).CGColor;
    }
}

@end
