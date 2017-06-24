//
//  SearchView.m
//  Kuaikan
//
//  Created by 少少 on 16/4/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (void)creatSearchView:(BOOL)isMore{
    
    _searchBtn = [[UIButton alloc] init];
    
    if (isMore) {
        _searchBtn.frame = CGRectMake(45, 7, ScreenWidth - 30 - 30, 30);
        
    } else {
        _searchBtn.frame = CGRectMake(15, 7, ScreenWidth - 30, 30);
    }

    _searchBtn.backgroundColor = [UIColor whiteColor];
    _searchBtn.layer.cornerRadius = 15.0;
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 250, 20)];
    label.text = _placeolderStr;
    label.font = Font14;
    label.textColor = [UIColor grayColor];
    [_searchBtn addSubview:label];
    
    UIImageView *magnifierImage = [[UIImageView alloc] init];
    if (isMore) {
        magnifierImage.frame = CGRectMake(ScreenWidth - 30 - 30 - 30, 7.5, 15, 15);
        
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.frame = CGRectMake(0, 0, 44, 44);
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        
    } else {
        magnifierImage.frame = CGRectMake(ScreenWidth - 30 - 30, 7.5, 15, 15);
    }
    magnifierImage.image = [UIImage imageNamed:@"common_nav_search_icon_s2@x"];
    [_searchBtn addSubview:magnifierImage];
}

//跳转搜索页面
- (void)searchBtnClick{
    
    _searchBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _searchBtn.enabled = YES;
    });
    
    if ([self.delegate respondsToSelector:@selector(searchViewBtnClick)]) {
        [self.delegate searchViewBtnClick];
    }
}

//更多按钮
- (void)moreBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(searchViewMoreBtnClick)]) {
        [self.delegate searchViewMoreBtnClick];
    }
}

@end
