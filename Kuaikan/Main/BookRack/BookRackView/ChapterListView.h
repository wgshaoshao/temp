//
//  ChapterListView.h
//  Kuaikan
//
//  Created by 少少 on 16/11/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChapterListDelegate <NSObject>

- (void)clickParkChapter:(NSInteger)chaperIndex;
- (void)removeChapterListView;

@end

@interface ChapterListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) id<ChapterListDelegate>delegate;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
