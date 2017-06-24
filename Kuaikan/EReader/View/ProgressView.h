//
//  ProgressView.h
//  Kuaikan
//
//  Created by 少少 on 17/3/27.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressViewDelegate <NSObject>
- (void)progressViewTwoBtnClick:(UIButton *)button;
@end

@interface ProgressView : UIView

@property (nonatomic, strong) id<ProgressViewDelegate>delegate;
- (void)creatView;
@property (nonatomic, strong) NSArray *array;
@end
