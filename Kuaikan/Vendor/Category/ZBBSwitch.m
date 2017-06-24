//
//  ZBBSwitch.m
//  ZBBSwitchDemo
//
//  Created by zhangbinbin on 16/2/24.
//  Copyright © 2016年 zhangbinbin. All rights reserved.
//

#import "ZBBSwitch.h"

#define Line_Color [UIColor colorWithRed:116/255.0 green:144/255.0 blue:197/255.0 alpha:1.0]
#define RL_text_Color [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1.]

@interface ZBBSwitch()
{
    UILabel* _leftLabel;
    UILabel* _rightLabel;
    
    UIColor* _leftLastColor;
}
@end

@implementation ZBBSwitch

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 15;
        self.clipsToBounds = YES;
        
        _leftLabel = [self createLabelWithFrame:CGRectMake(0, 0, frame.size.width / 2, frame.size.height) WithTitle:@"充值记录" WithFontSize:14.0f];
        [self addSubview:_leftLabel];
        
        [_leftLabel setBackgroundColor:WhiteColor];
        _leftLabel.layer.borderWidth = 1.0;
        _leftLabel.layer.cornerRadius = 15;
        _leftLabel.clipsToBounds = YES;
        _leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;

        _leftLabel.textColor = RL_text_Color;
        _leftLastColor = _leftLabel.backgroundColor;
        
        _rightLabel = [self createLabelWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width / 2, frame.size.height) WithTitle:@"消费记录" WithFontSize:14.0f];
        [self addSubview:_rightLabel];
        _rightLabel.textColor = WhiteColor;
        _rightLabel.backgroundColor = Line_Color;
    }
    
    return self;
}

-(void)awakeFromNib
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸开始时手指的坐标（在self坐标系上
    UITouch *touch=[touches anyObject];
    CGPoint originPoint = [touch locationInView:self];
    
    if (originPoint.x <= self.frame.size.width / 2.)
    {
        [_leftLabel setBackgroundColor:WhiteColor];
        _rightLabel.backgroundColor = Line_Color;
        _rightLabel.textColor = WhiteColor;
        _leftLabel.textColor = RL_text_Color;
        _leftLabel.backgroundColor = WhiteColor;
        
        _leftLabel.layer.borderWidth = 1.0;
        _leftLabel.layer.cornerRadius = 15;
        _leftLabel.clipsToBounds = YES;
        _leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _rightLabel.layer.borderWidth = 0;
        _rightLabel.layer.cornerRadius = 0;
        _rightLabel.clipsToBounds = NO;
        _rightLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else
    {
        [_leftLabel setBackgroundColor:Line_Color];
        _leftLabel.textColor = WhiteColor;
        _rightLabel.backgroundColor = WhiteColor;
        _rightLabel.textColor = RL_text_Color;
        _leftLabel.layer.borderWidth = 0;
        _leftLabel.layer.cornerRadius = 0;
        _leftLabel.clipsToBounds = NO;
        _leftLabel.layer.borderColor = [UIColor clearColor].CGColor;
        
        _rightLabel.layer.borderWidth = 1.0;
        _rightLabel.layer.cornerRadius = 15;
        _rightLabel.clipsToBounds = YES;
        _rightLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    if (!CGColorEqualToColor(_leftLastColor.CGColor, _leftLabel.backgroundColor.CGColor))
    {
        _leftLastColor = _leftLabel.backgroundColor;
        _isOn = !_isOn;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(UILabel*)createLabelWithFrame:(CGRect)frame WithTitle:(NSString*)title WithFontSize:(CGFloat)fontSize
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

#pragma mark property

-(void)setLeftName:(NSString *)leftName
{
    _leftName = leftName;
    _leftLabel.text = leftName;
}

-(void)setRightName:(NSString *)rightName
{
    _rightName = rightName;
    _rightLabel.text = rightName;
}









@end
