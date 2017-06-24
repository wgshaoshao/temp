//
//  JYS_SqlManager.h
//  Kuaikan
//
//  Created by CloudJson on 2017/3/10.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInforModel.h"
#import "CatelogInforModel.h"
#import "SearchReacordModel.h"
#import "ParkCatelogModel.h"
@interface JYS_SqlManager : NSObject

/**
 单例
 @return 获取Manager单例
 */
+ (JYS_SqlManager *)shareManager;

/**
 单本书加入书架

 @param Book BookModel
 @return 是否插入成功
 */
- (BOOL)insertBookRackWithObject:(BookInforModel *)book;

/**
 批量加入书架

 @param Books BookModel集合
 @return 是否插入成功
 */
- (BOOL)insertBookRackWithBooks:(NSArray *)books;

/**
 插入单章目录信息

 @param catelog CatelogInforModel
 @return BOOL
 */
- (BOOL)insertCatelogWithObject:(CatelogInforModel *)catelog;

/**
 批量插入目录

 @param catelogs catelogs
 @return 是否插入成功
 */
- (BOOL)insertCatelogsWithArray:(NSArray *)catelogs;

/**
 插入搜索记录

 @param searchstr 搜索内容
 @return 是否成功
 */
- (BOOL)insertSearchReacordWithString:(NSString *)searchstr;

/**
 移除书架上的书

 @param Bookid 书籍id
 @return 是否成功
 */
- (BOOL)removeBookRackWithBook:(NSString *)bookid;

/**
 从书架上移除多本书

 @param Books 书籍id的集合
 @return 是否成功
 */
- (BOOL)removeBooksFromBookRack:(NSArray *)books;

/**
 移除书架上的所有书

 @return 是否成功
 */
- (BOOL)removeAllBookRack;

/**
 移除阅读记录

 @param bookid 单本书id
 @return 操作结果
 */
- (BOOL)removeReadRecordWithBookid:(NSString *)bookid;

/**
 批量移除阅读记录

 @param records 书籍集合
 @return 操作结果
 */
- (BOOL)removeReadRecordsFromArray:(NSArray *)records;

/**
 移除单本书的所有章节

 @param Bookid 书籍id
 @return 是否成功
 */
- (BOOL)removeCatelogsWithBookid:(NSString *)bookid;

/**
 单章删除

 @param catelogid 章节id
 @param Bookid 书籍id
 @return 是否成功
 */
- (BOOL)removeCatelogWithId:(NSString *)catelogid
                andFromBook:(NSString *)bookid;

/**
 删除所有目录

 @return 是否成功
 */
- (BOOL)removeAllCatelogs;

/**
 删除单条搜索记录

 @param searchstr 内容
 @return 是否成功
 */
- (BOOL)removeSearchRecordWithString:(NSString *)searchstr;

/**
 删除所有的搜索记录

 @return 是否成功
 */
- (BOOL)removeAllSearchRecord;

/**
 更新阅读记录
 
 @param Bookid 书籍id
 @param catelogid 当前章节id
 @param tips 当前内容
 @param position 阅读位置
 @return 是否成功
 */
- (BOOL)updateReadRecordWithBookid:(NSString *)bookid
                      andCaputerid:(NSString *)catelogid
                           andTips:(NSString *)tips
                       andPosition:(NSNumber *)position;

/**
 更新单章付费记录

 @param catelog 章节id
 @return 是否成功
 */
- (BOOL)updatePaymentRecordWithCatelog:(NSString *)catelog
                              fromBook:(NSString *)bookid;

/**
 批量更新付费状态

 @param catelogs 章节id集合
 @return 是否成功
 */
- (BOOL)updatePaymentRecordWithArray:(NSArray *)catelogs
                            fromBook:(NSString *)bookid;

/**
 查询书架上的所有书籍

 @return 书架上的书籍集合
 */
- (NSArray *)getBookRackBooks;

/**
 获取所有的阅读记录

 @return  获取所有的阅读记录
 */
- (NSArray *)getAllReadRecord;

/**
 获取单本书实例

 @param Bookid 书籍id
 @return 书籍实例
 */
- (BookInforModel *)getBookWithBookId:(NSString *)bookid;

/**
 查询目录

 @param Bookid 书籍id
 @return 章节目录
 */
- (NSArray *)getAllCatelogFromBook:(NSString *)bookid;

/**
 查询当前章节以后的未付费章节

 @param catelog 当前章节id
 @param count 查询数量
 @param Bookid 书籍id
 @return 未付费章节列表
 */
- (NSArray *)getPaymentStatusWithCurrentCatelog:(NSString *)catelog
                                         andCount:(NSInteger)count
                                         fromBook:(NSString *)bookid;

/**
 查询单章节信息

 @param catelogid 章节id
 @param Bookid 书籍id
 @return 章节模型
 */
- (CatelogInforModel *)getCatelogWithCatelogId:(NSString *)catelogid
                                     andFromBook:(NSString *)bookid;

/**
 查询当前章节是否已下载

 @param catelogid 章节id
 @param Bookid  书籍id
 @return 是否存在 yes存在  no不存在
 */
- (BOOL)getIsCurrentCatelogDownload:(NSString *)catelogid
                             fromBook:(NSString *)bookid;

/**
 查询所有的搜索记录

 @return 搜索记录
 */
- (NSArray *)getAllSearchRecord;


/**
 插入章节到数据库

 @param dict 章节信息
 */
- (void)insertChaperToDataBase:(NSDictionary *)dict;

/**
 插入书架书籍

 @param requestData 书籍信息
 */
- (BOOL)insertData:(NSDictionary *)requestData;

/**
 插入目录和目录分页到数据库

 @param dict 目录信息
 @param isEnd 是否更新章节
 */
- (void)insertCatelogAndParkToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd;

/**
 插入目录信息

 @param dict 目录信息
 @param isEnd 是否最后一批
 @param isBatch 是否是点击批量下载（数据来源）
 @param isCallDraw 是否是点击目录
 */
- (void)insertCatelogToDataBase:(NSDictionary *)dict
                       andIsEnd:(BOOL)isEnd
                     andIsBatch:(BOOL)isBatch
                  andIsCallDraw:(BOOL)isCallDraw;

/**
 插入搜索记录

 @param requestData 搜索数据
 */
- (void)insertSearchRecord:(NSDictionary *)requestData;
/** 插入wifi上传的书籍 */
- (void)insertBookWifi:(NSDictionary *)requestData;
/** 记录阅读记录 */
- (void)insertReadBook:(NSDictionary *)requestData;
/** 修改支付记录 */
- (void)amendPayRecord:(NSDictionary *)dict;

/** 修改自动购买 */
- (void)amendAutoBuy:(NSDictionary *)dict;
/** 一本书是否有更新章节 */
- (void)updateChapter:(NSDictionary *)dict;
/** 更新一本书是否是免费 */
- (void)updateBookIsFree:(NSDictionary *)dict;
/** 书籍章节价格 */
- (void)bookChapterPrice:(NSDictionary *)dict AndbookID:(NSString *)bookID;

/**
 修改章节付费情况

 @param dict 章节信息
 */
- (void)amendPayRecordBookDedail:(NSDictionary *)dict;
- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd;

@end
