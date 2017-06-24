//
//  E_ScrollViewController.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface E_ScrollViewController : BaseViewController
/** 书本ID */
@property (nonatomic, strong) NSString *bookID;
/** 起始章节 */
@property (nonatomic, strong) NSString *chapterID;
/** 全部目录中的某一章节 */
@property (nonatomic, strong) NSString *allChapterOne;
/** 全部目录中的某一章节在哪个位置 */
@property (nonatomic, assign) NSInteger allChapterIndex;
/** 书本名 */
@property (nonatomic, strong) NSString *bookName;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 书的封面 */
@property (nonatomic, strong) NSString *bookIcon;
/** 书的介绍 */
@property (nonatomic, strong) NSString *introude;
/** 设置总章节数(非及时) */
@property (nonatomic, assign) NSInteger totalChapter;
/** 设置总章节的标题 */
@property (nonatomic, strong) NSArray *totalTitlArray;
/** 设置章节列表数组 */
@property (nonatomic, strong) NSArray *chapterIdListArray;
/** 记录这本书的章节数(及时) */
@property (nonatomic, assign) NSInteger lastChapterCount;
/** 记录这本书的最后一个章节 */
@property (nonatomic, strong) NSString *lastChapterID;
/** 记录这本书有无更新 */
@property (nonatomic, assign) BOOL NoUpdateChapter;
@property (nonatomic, assign) BOOL NewUpdate;
/** 这本书是不是加入到书架了 */
@property (nonatomic, assign) BOOL haveBookRack;


@end
