//
//  CatalogTopView.h
//  Kuaikan
//
//  Created by 少少 on 16/11/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatalogTopViewDelegate <NSObject>

- (void)catalogTopViewBtnClick;

@end

@interface CatalogTopView : UIView

- (void)creatView;
@property (nonatomic, strong) id<CatalogTopViewDelegate>delegate;
@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UIButton *chapterBtn;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *chapterStr;
@property (nonatomic, strong) NSString *totalStr;
@end
