//
//  E_ReaderViewController.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E_ReaderView.h"
/**
 *  显示阅读内容
 */

@protocol E_ReaderViewControllerDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)hideTheSettingBar;
- (void)ciBaWithString:(NSString *)ciBaString;

@end


@interface E_ReaderViewController : BaseViewController

@property (nonatomic,assign) id<E_ReaderViewControllerDelegate>delegate;
@property (nonatomic,unsafe_unretained) NSUInteger currentPage;
@property (nonatomic,unsafe_unretained) NSUInteger totalPage;
@property (nonatomic,strong)            NSString   *text;
@property (nonatomic,unsafe_unretained) NSUInteger  font;
@property (nonatomic, copy)             NSString   *chapterTitle;
@property (nonatomic, strong)           NSString   *bookName;
@property (nonatomic, assign)           float   progressRatio;
@property (nonatomic, unsafe_unretained,readonly) CGSize readerTextSize;
@property (nonatomic,strong)            UIImage    *themeBgImage;
@property (nonatomic,strong)            NSString   *keyWord;
@property (nonatomic,assign)            BOOL        isNightText;
@property (nonatomic, strong) E_ReaderView *readerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *electricLabel;
@property (nonatomic, strong) UILabel *chapterNameLabel;


- (CGSize)readerTextSize;

@end

