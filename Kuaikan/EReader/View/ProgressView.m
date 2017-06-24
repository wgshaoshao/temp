//
//  ProgressView.m
//  Kuaikan
//
//  Created by 少少 on 17/3/27.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}

- (void)creatView{
    
    // 添加菜单整体到窗口身上
    UIWindow *window= [AppDelegate sharedApplicationDelegate].window;
    [window addSubview:self];

    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);;
    [self addSubview:cover];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = WhiteColor;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6.0;
    [cover addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示";
    titleLabel.font = Font18;
  //  titleLabel.textColor = LightTextColor;
    titleLabel.frame = CGRectMake(20, 5, ScreenWidth - 100, 40);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    NSDictionary *firstTip = _array[0];
    NSDictionary *secondTip = _array[1];
    NSDictionary *threeTip = _array[2];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = firstTip[@"tip"];
    firstLabel.font = Font15;
    titleLabel.textColor = TextColor;
    CGFloat firstLabelY = CGRectGetMaxY(titleLabel.frame);
    firstLabel.frame = CGRectMake(0, firstLabelY, ScreenWidth - 60, 20);
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = firstTip[@"tip"];
    secondLabel.font = Font15;
    CGFloat secondLabelY = CGRectGetMaxY(firstLabel.frame);
    secondLabel.frame = CGRectMake(0, secondLabelY, ScreenWidth - 60, 20);
    secondLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *secondTipStr = secondTip[@"tip"];
    NSMutableAttributedString *messagelStrs = [[NSMutableAttributedString alloc] initWithString:secondTipStr];
    [messagelStrs addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:secondTip[@"color"]] range:NSMakeRange(0, secondTipStr.length)];
    secondLabel.attributedText = messagelStrs;
    [backView addSubview:secondLabel];
    
    UILabel *threeLabel = [[UILabel alloc] init];
    threeLabel.text = threeTip[@"tip"];
    threeLabel.font = Font15;
    threeLabel.textColor = TextColor;
    CGFloat threeLabelY = CGRectGetMaxY(secondLabel.frame);
    threeLabel.frame = CGRectMake(0, threeLabelY, ScreenWidth - 60, 20);
    threeLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:threeLabel];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    CGFloat lineLabelY = CGRectGetMaxY(threeLabel.frame) + 15;
    lineLabel.frame = CGRectMake(0, lineLabelY, ScreenWidth - 60, 0.5);
    lineLabel.backgroundColor = LineLabelColor;
    [backView addSubview:lineLabel];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:ADColor(0, 111, 255) forState:UIControlStateNormal];
    backBtn.titleLabel.font = Font18;
    backBtn.tag = 10;
    [backBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backBtnY = CGRectGetMaxY(lineLabel.frame);
    backBtn.frame = CGRectMake(0, backBtnY, (ScreenWidth - 60) / 2, 40);
    [backView addSubview:backBtn];
    
    UILabel *secondLine = [[UILabel alloc] init];
    secondLine.frame = CGRectMake((ScreenWidth - 60) / 2, backBtnY, 0.5, 40);
    secondLine.backgroundColor = LineLabelColor;
    [backView addSubview:secondLine];
    
    UIButton *ensureBtn = [[UIButton alloc] init];
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:ADColor(0, 111, 255) forState:UIControlStateNormal];
    ensureBtn.titleLabel.font = Font18;
    [ensureBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    ensureBtn.tag = 11;
    CGFloat ensureBtnX = CGRectGetMaxX(secondLine.frame);
    ensureBtn.frame = CGRectMake(ensureBtnX, backBtnY, (ScreenWidth - 61) / 2, 40);
    [backView addSubview:ensureBtn];
  //  0 111 255
    CGFloat backViewY = CGRectGetMaxY(ensureBtn.frame);
    backView.frame = CGRectMake(30, (ScreenHeight - backViewY)/2, ScreenWidth - 60, backViewY);

}

- (void)threeBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(progressViewTwoBtnClick:)]) {
        
        [self.delegate progressViewTwoBtnClick:button];
    }
}

- (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
