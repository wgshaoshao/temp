//
//  AllHotSearch.h
//  Kuaikan
//
//  Created by 少少 on 16/4/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllHotSearchDelegate <NSObject>

- (void)allHotSearchRefreshBtn;

@end

@interface AllHotSearch : UIView

@property (nonatomic, strong) id<AllHotSearchDelegate>delegate;

- (void)creatUI;
@end
