//
//  CommentPopView.h
//  Kuaikan
//
//  Created by 少少 on 17/1/12.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentPopViewDelegate <NSObject>
- (void)commentPopViewThreeBtnClick:(UIButton *)button;
@end

@interface CommentPopView : UIView
@property (nonatomic, strong) id<CommentPopViewDelegate>delegate;
- (void)creatView;
@end
