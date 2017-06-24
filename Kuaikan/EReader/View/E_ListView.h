//
//  E_ListView.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/15.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E_CommonManager.h"
#import "E_Mark.h"

@protocol E_ListViewDelegate <NSObject>

- (void)clickMark:(E_Mark *)eMark;
- (void)clickChapter:(NSInteger)chaperIndex;
- (void)removeE_ListView;

@end

@interface E_ListView : UIView<UITableViewDataSource,UITableViewDelegate>{
   
    UISegmentedControl *_segmentControl;
    NSInteger dataCount;
    NSArray *_dataSource;
    NSArray *_markDataSource;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    BOOL    _isNote;

}
@property (nonatomic,assign)id<E_ListViewDelegate>delegate;

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *totalTitlArray;
@property (nonatomic, strong) NSArray *chapterIDArray;
@property (nonatomic, assign) BOOL isFooterRefresh;
@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) NetworkModel *updateModel;
@property (nonatomic, strong) NSString *bookID;

- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray;

@end
