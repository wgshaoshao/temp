//
//  RechareButton.m
//  Kuaikan
//
//  Created by 少少 on 16/5/24.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RechareButton.h"

@implementation RechareButton

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)creatView{
    
    
    if (isNightView) {
        self.backgroundColor = ADColor(157, 157, 157);
    } else {
        self.backgroundColor = LineLabelColor;
    }

    if (_isFirstBtn) {
        
        if (_isTenChapter) {
    
            _moneyLabel = [[UILabel alloc] init];
            _moneyLabel.font = Font14;
            _moneyLabel.frame = CGRectMake(0, 5, self.frame.size.width, 25);
            _moneyLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_moneyLabel];
            
            CGFloat bottomLabelY = CGRectGetMaxY(_moneyLabel.frame);
            
            _bottomLabel = [[UILabel alloc] init];
            _bottomLabel.frame = CGRectMake(0, bottomLabelY, self.frame.size.width , 25);
            _bottomLabel.textAlignment = NSTextAlignmentCenter;
            _bottomLabel.font = Font14;
            [self addSubview:_bottomLabel];
        } else {
            _titleLab = [[UILabel alloc] init];
            if (isNightView) {
                _titleLab.backgroundColor = ADColor(113, 71, 32);
                
                _titleLab.textColor = ADColor(127, 127, 127);
            } else {
                _titleLab.backgroundColor = ADColor(228, 143, 57);
                _titleLab.textColor = WhiteColor;
            }
            
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _titleLab.font = Font12;
            _titleLab.frame = CGRectMake(0, 0, 40, 15);
            [self addSubview:_titleLab];
            
            _moneyLabel = [[UILabel alloc] init];
            _moneyLabel.font = Font14;
            CGFloat moneyLabelX = CGRectGetMaxX(_titleLab.frame) + 5;
            _moneyLabel.frame = CGRectMake(moneyLabelX, 5, self.frame.size.width - moneyLabelX, 25);
            _moneyLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_moneyLabel];
            
            CGFloat bottomLabelY = CGRectGetMaxY(_moneyLabel.frame);
            
            _firstLabel = [[UILabel alloc] init];
            _firstLabel.frame = CGRectMake(0, bottomLabelY, (self.frame.size.width - 5)/ 2, 25);
            _firstLabel.font = Font14;
            _firstLabel.textColor = [UIColor lightGrayColor];
            _firstLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_firstLabel];
            
            _lineLabel = [[UILabel alloc] init];
            
            CGFloat lineLabelX = CGRectGetMaxX(_firstLabel.frame);
            if (_isThirdLin) {
                _lineLabel.frame = CGRectMake(lineLabelX - 63, 12, 63, 1);
            
            } else {
                _lineLabel.frame = CGRectMake(lineLabelX - 55 , 12, 55, 1);
          
            }
            
            _lineLabel.backgroundColor = [UIColor lightGrayColor];
            [_firstLabel addSubview:_lineLabel];
//            _firstLabel.backgroundColor =[UIColor redColor];
            
            _bottomLabel = [[UILabel alloc] init];
            _bottomLabel.frame = CGRectMake((self.frame.size.width + 5 )/ 2, bottomLabelY, self.frame.size.width / 2, 25);
            _bottomLabel.textAlignment = NSTextAlignmentLeft;
            _bottomLabel.font = Font14;
            [self addSubview:_bottomLabel];
        }

    } else {
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = Font14;
        _moneyLabel.frame = CGRectMake(0, 5, self.frame.size.width, 25);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyLabel];
        
        CGFloat bottomLabelY = CGRectGetMaxY(_moneyLabel.frame);
        
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.frame = CGRectMake(0, bottomLabelY, self.frame.size.width , 25);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = Font14;
        [self addSubview:_bottomLabel];
    }
    
    
    _sectImageView = [[UIImageView alloc] init];
    _sectImageView.frame = CGRectMake(self.frame.size.width - 20, self.frame.size.height - 20, 20, 20);
    [self addSubview:_sectImageView];
    
    [self addTarget:self action:@selector(selfClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [headImage.layer setBorderColor:colorref];//边框颜色
    //    [headImage.layer setBorderWidth:1.0]; //边框宽度
}

- (void)selfClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(rechareButtonClick:)]) {
        [self.delegate rechareButtonClick:button];
    }
}

- (void)setIsSected:(BOOL)isSected{
    
    if (isSected) {
        if (isNightView) {
            self.backgroundColor = ADColor(127, 127, 127);
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = ADColor(113, 71, 32).CGColor;
        } else {
            self.backgroundColor = WhiteColor;
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = ADColor(228, 143, 57).CGColor;
        }
        
    } else {
        if (isNightView) {
            self.backgroundColor = ADColor(157, 157, 157);
            self.layer.borderWidth = 0;
            self.layer.borderColor = ADColor(113, 71, 32).CGColor;
        } else {
            self.backgroundColor = LineLabelColor;
            self.layer.borderWidth = 0;
            self.layer.borderColor = ADColor(228, 143, 57).CGColor;
        }
        
    }
}


@end
