//
//  HotStrawView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotStrawViewDelegate <NSObject>

- (void)hotStrawViewBtnClick;

@end

@interface HotStrawView : UIView
@property (nonatomic, strong) id<HotStrawViewDelegate>delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary *listDict;
@end
