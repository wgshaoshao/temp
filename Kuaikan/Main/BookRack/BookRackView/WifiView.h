//
//  WifiView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/23.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WifiViewDelegate <NSObject>

@optional
- (void)popMenuDidDismissed;
@end

@interface WifiView : UIView

@property (nonatomic, weak) id<WifiViewDelegate> delegate;
@property (nonatomic, strong) UILabel *IPLabel;

- (void)creatView;
@end
