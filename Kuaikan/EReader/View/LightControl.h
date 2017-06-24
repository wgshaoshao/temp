//
//  LightControl.h
//  Kuaikan
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchStateEnd) (CGFloat);
typedef void(^TouchStateChanged) (CGFloat);

typedef enum {
    LightControlDirectionHorizonal  =   0,
    LightControlDirectionVertical   =   1
} LightControlDirection;

@interface LightControl : UIControl
@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat ratioNum;//滑动的比值

@property (nonatomic, assign) LightControlDirection direction;//方向
@property (nonatomic, copy) TouchStateChanged StateChanged;
@property (nonatomic, copy) TouchStateEnd StateEnd;



- (id)initWithFrame:(CGRect)frame direction:(LightControlDirection)direction;


- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock;
- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock;


@end
