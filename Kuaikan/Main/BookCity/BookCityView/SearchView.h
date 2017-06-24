//
//  SearchView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void)searchViewBtnClick;

@optional
- (void)searchViewMoreBtnClick;

@end

@interface SearchView : UIView

- (void)creatSearchView:(BOOL)isMore;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, assign) BOOL YesOrNo;
@property (nonatomic, strong) NSString *placeolderStr;
@property (nonatomic, strong) id<SearchViewDelegate>delegate;
@property (nonatomic, strong) UIButton *searchBtn;

@end
