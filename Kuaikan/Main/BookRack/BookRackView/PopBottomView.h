//
//  PopBottomView.h
//  Kuaikan
//
//  Created by 少少 on 17/2/14.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopBottomViewDelegate <NSObject>
- (void)popBottomViewBtnClick;
@end

@interface PopBottomView : UIView

@property (nonatomic, strong) id<PopBottomViewDelegate>delegate;
@property (nonatomic, strong) NSString *imageStr;
- (void)creatView;

@end
