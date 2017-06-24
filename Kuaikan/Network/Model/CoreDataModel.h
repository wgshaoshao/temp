//
//  CoreDataModel.h
//  Kuaikan
//
//  Created by 少少 on 16/3/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "Model.h"

@interface CoreDataModel : Model

/** 插入章节到数据库 */
- (void)insertChaperToDataBase:(NSDictionary *)dict;
/** 获取书本内容并存储 */
- (void)getBookAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData;
/** 获取章节内容并存储 */
- (void)getChapterAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData;
/** 获取目录并存储 */
- (void)getCatelogAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData andIsEnd:(BOOL)isEnd;
/** 插入书架书籍 */
- (void)insertData:(NSDictionary *)requestData;
/** 插入目录和目录分页到数据库 */
- (void)insertCatelogAndParkToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd;

- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd andIsBatch:(BOOL)isBatch andIsCallDraw:(BOOL)isCallDraw;
/** 插入搜索记录 */
- (void)insertSearchRecord:(NSDictionary *)requestData;
/** 插入wifi上传的书籍 */
- (void)insertBookWifi:(NSDictionary *)requestData;
/** 记录阅读记录 */
- (void)insertReadBook:(NSDictionary *)requestData;
/** 修改支付记录 */
- (void)amendPayRecord:(NSDictionary *)dict;
/**修改支付记录，，同步*/
- (void)amendPayRecordSnyc:(NSDictionary *)dict;
/** 修改自动购买 */
- (void)amendAutoBuy:(NSDictionary *)dict;
/** 一本书是否有更新章节 */
- (void)updateChapter:(NSDictionary *)dict;
/** 更新一本书是否是免费 */
- (void)updateBookIsFree:(NSDictionary *)dict;
/** 书籍章节价格 */
- (void)bookChapterPrice:(NSDictionary *)dict AndbookID:(NSString *)bookID;
- (void)amendPayRecordBookDedail:(NSDictionary *)dict;
- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd;

@end
