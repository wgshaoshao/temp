//
//  AcountSafeView.h
//  Kuaikan
//
//  Created by 少少 on 17/3/20.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AcountSafeViewDelegate <NSObject>

- (void)accountThreeButton:(UIButton *)button;

@end

@interface AcountSafeView : UIView
- (void)creatThreeView:(NSDictionary *)dict;
@property (nonatomic, strong) id<AcountSafeViewDelegate>delegate;
@end
