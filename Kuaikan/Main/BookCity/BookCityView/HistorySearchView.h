//
//  HistorySearchView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/1.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistorySearchDelegate <NSObject>

- (void)historySearchDeleteBtn;

@end

@interface HistorySearchView : UIView

@property (nonatomic, strong) id<HistorySearchDelegate>delegate;

- (void)creatUI;
@end
