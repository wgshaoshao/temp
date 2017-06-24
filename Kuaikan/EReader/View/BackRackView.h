//
//  BackRackView.h
//  Kuaikan
//
//  Created by 少少 on 16/7/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackRackViewDelegate <NSObject>

@optional
- (void)popMenuDidDismissed;
- (void)backRackViewCancelBtnClick;
- (void)backRackViewEnsureBtnClick;
@end

@interface BackRackView : UIView

@property (nonatomic, weak) id<BackRackViewDelegate> delegate;
- (void)creatView;
@end
