//
//  EmptyView.m
//  Kuaikan
//
//  Created by 少少 on 16/6/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        [self creatView];
    }
    return self;
}

- (void)creatView{
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = Font16;
    _titleLabel.textColor = ADColor(153, 153, 153);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.frame = CGRectMake(0, 150, ScreenWidth, 20);
    [self addSubview:_titleLabel];
   
}

@end
