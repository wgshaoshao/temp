//
//  AcountSafeView.m
//  Kuaikan
//
//  Created by 少少 on 17/3/20.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "AcountSafeView.h"

@implementation AcountSafeView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)creatThreeView:(NSDictionary *)dict{
    
    NSString *firstKey = @"";
    NSString *firstCoverWap = @"";
    NSString *firstNickname = @"";

    
    firstKey = dict[@"key"];
    firstCoverWap = dict[@"coverWap"];
    firstNickname = dict[@"nickname"];
    
    
    NSString *firstStr = @"";
    
    UIButton *firestBtn = [[UIButton alloc] init];
    firestBtn.frame = CGRectMake(ScreenWidth - 80, 18.5, 60, 27);

    if ([firstKey isEqualToString:@"WECHAT"]) {
        firstStr = @"微信";
        firestBtn.tag = 1;
    } else if ([firstKey isEqualToString:@"QQ"]) {
        firstStr = @"QQ";
        firestBtn.tag = 2;
    } else if ([firstKey isEqualToString:@"SINA"]) {
        firstStr = @"微博";
        firestBtn.tag = 3;
   
    }
    
    UIImageView *firestImage = [[UIImageView alloc] init];
    firestImage.frame = CGRectMake(20, 15.5, 33, 33);
    firestImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",firstStr]];
    [self addSubview:firestImage];
    
    UILabel *firestLablel = [[UILabel alloc] init];
    firestLablel.text = [NSString stringWithFormat:@"%@账号",firstStr];
    firestLablel.font = Font16;
    firestLablel.textColor = TextColor;
    CGFloat firestLabelX = CGRectGetMaxX(firestImage.frame) + 15;
    firestLablel.frame = CGRectMake(firestLabelX, 9, 100, 20);
    [self addSubview:firestLablel];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    if (firstCoverWap.length || firstNickname.length) {
        stateLabel.text = @"绑定状态：已绑定";
        firestBtn.hidden = YES;
    } else {
        stateLabel.text = @"绑定状态：未绑定";
        firestBtn.hidden = NO;
    }
    stateLabel.textColor = ADColor(153, 153, 153);
    CGFloat stateLabelY = CGRectGetMaxY(firestLablel.frame) + 8;
    stateLabel.frame = CGRectMake(firestLabelX, stateLabelY, 150, 20);
    stateLabel.font = Font14;
    [self addSubview:stateLabel];
    
    [firestBtn addTarget:self action:@selector(bundButton:) forControlEvents:UIControlEventTouchUpInside];
    [firestBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [firestBtn setTitleColor:ADColor(255, 84, 84) forState:UIControlStateNormal];
    [firestBtn setBackgroundImage:[UIImage imageNamed:@"button_safe"] forState:UIControlStateNormal];
    firestBtn.titleLabel.font = Font14;
    [self addSubview:firestBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = LineLabelColor;
    lineLabel.frame = CGRectMake(20, 63.5, ScreenWidth - 20, 0.5);
    [self addSubview:lineLabel];

}

- (void)bundButton:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(accountThreeButton:)]) {
        
        [self.delegate accountThreeButton:button];
    }
}

@end
