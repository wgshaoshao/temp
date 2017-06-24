//
//  LoginView.h
//  Kuaikan
//
//  Created by 少少 on 17/3/21.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>
- (void)loginViewBtnClick;
@end

@interface LoginView : UIView
@property (nonatomic, strong) id<LoginViewDelegate>delegate;
- (void)creatView;
@end
