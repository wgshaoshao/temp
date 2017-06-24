//
//  LoginButton.m
//  爱动
//
//  Created by shaoshao on 15/6/15.
//  Copyright (c) 2015年 aidong. All rights reserved.
//  自定义第三方登录按钮

#import "LoginButton.h"

@implementation LoginButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 字体
//        self.titleLabel.font = Font15;
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.width;
    CGFloat imageH = imageW - 18;
    CGFloat imageX = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = self.height - 17;
    CGFloat titleX = 0;
    CGFloat titleH = 17;
    CGFloat titleW = self.width;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

//- (void)setTitle:(NSString *)title forState:(UIControlState)state
//{
//    [super setTitle:title forState:state];
//    
//    // 1.计算文字的尺寸
//    CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
//    
//    // 2.计算按钮的宽度
//    self.width = titleSize.width + self.height + 10;
//}


@end
