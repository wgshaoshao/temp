//
//  bookInforModel.h
//  Kuaikan
//
//  Created by CloudJson on 2017/3/7.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkCatelogModel.h"
@interface BookInforModel : NSObject

/**
 书的id
 */
@property ( nonatomic, copy) NSString *bookid;

/**
 书皮
 */
@property ( nonatomic, copy) NSString *coverurl;

/**
 作者
 */
@property ( nonatomic, copy) NSString *author;//

/**
 书的来源
 */
@property (nonatomic, copy) NSString *bookfrom;//

/**
 书名
 */
@property ( nonatomic, copy) NSString *bookName;

/**
 当前阅读的章节（用于阅读记录查询）
 */
@property ( nonatomic, copy) NSString *currentCatelogId;

@property ( nonatomic, copy) NSString *currentName;

/**
 最后的操作时间（用于排序）
 */
@property (nonatomic, copy) NSString *time;//

/**
 价格
 */
@property (nonatomic, copy) NSString *price;//

/**
 市场id
 */
@property (nonatomic, copy) NSString *marketId;

/**
 市场状态
 */
@property (nonatomic, copy) NSNumber *marketStatus;

/**
 是否在书架上
 */
@property (nonatomic, copy) NSNumber *isAddBook;
/**
 是否弹过书籍进度同步弹框
 */
@property (nonatomic, copy) NSNumber *isRedSyn;

@property (nonatomic, copy) NSNumber *isAddCloudBook;
/**
 是否已读
 */
@property (nonatomic, copy) NSNumber *hasRead;//

/**
 是否是默认书
 */
@property (nonatomic, copy) NSNumber *isdefautBook;

/**
 是否完结
 */
@property (nonatomic, copy) NSNumber *isEnd;

/**
 是否有更新 0没更新   1有更新
 */
@property (nonatomic, copy) NSNumber *isUpdate;


@property (nonatomic, copy) NSArray *parkCatalog;

/**
 当前阅读章节的页数
 */
@property ( nonatomic, copy) NSString *currentPageIndex;

/**
 当前阅读第几章
 */
@property ( nonatomic, copy) NSString *chapterIndex;


@property (nonatomic,copy) NSString *updateChapter;

@property ( nonatomic, copy) NSString *chapterId;
@property ( nonatomic, copy) NSString *dateTime;

@property ( nonatomic, copy) NSNumber *isUpate;
@property ( nonatomic, copy) NSNumber *isWifiBook;
@property ( nonatomic, copy) NSString *introuce;

@property ( nonatomic, copy) NSNumber *bookstatus;
@property ( nonatomic, copy) NSNumber *confirmStatus;
@property ( nonatomic, copy) NSString *entityid;
@property ( nonatomic, copy) NSNumber *format;
@property ( nonatomic, copy) NSNumber *payRemind;
@property ( nonatomic, copy) NSNumber *payStatus;
@property ( nonatomic, copy) NSNumber *payWay;
@property ( nonatomic, copy) NSString *sourceFrom;
@property ( nonatomic, copy) NSNumber *isparkCatalog;

/**
 数据库的版本号，用于数据库动态升级

 @return 当前版本号
 */
+(NSString *)whc_SqliteVersion;


@end
