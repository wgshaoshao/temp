//
//  PromptView.h
//  Kuaikan
//
//  Created by 少少 on 16/11/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromptViewDelegate <NSObject>

@optional
- (void)ensureBtn:(BOOL)successOrFalse;

@end

@interface PromptView : UIView
@property (nonatomic, weak) id<PromptViewDelegate> delegate;
- (void)creatView;
@property (nonatomic, strong) NSString *userIDStr;
@property (nonatomic, strong) NSString *resumainStr;
@property (nonatomic, assign) BOOL successOrFalse;

@end
