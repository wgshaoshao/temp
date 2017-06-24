//
//  JYS_SqlManager.m
//  Kuaikan
//
//  Created by CloudJson on 2017/3/10.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "JYS_SqlManager.h"
#import "WHC_ModelSqlite.h"

@implementation JYS_SqlManager

+(JYS_SqlManager *)shareManager
{
    static JYS_SqlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

-(BOOL)insertBookRackWithObject:(BookInforModel *)book{
    if (book) {
        return [WHC_ModelSqlite insert:book];
    }
    return NO;
}

-(BOOL)insertBookRackWithBooks:(NSArray *)books
{
    if (books&&books.count) {
        if ([books[0] isKindOfClass:[BookInforModel class]]) {
            return [WHC_ModelSqlite inserts:books];
        }
        return NO;
    }
    return NO;
}

-(BOOL)insertCatelogWithObject:(CatelogInforModel *)catelog
{
    if (catelog&&[catelog isKindOfClass:[CatelogInforModel class]]) {
        return [WHC_ModelSqlite insert:catelog];
    }
    return NO;
}

- (BOOL)insertCatelogsWithArray:(NSArray *)catelogs
{
    if (catelogs&&catelogs.count) {
        NSDate *date1 = [NSDate date];
        BOOL isSuccess = [WHC_ModelSqlite inserts:catelogs];
        NSDate *date2 = [NSDate date];
        LRLog(@"insersDate----%f",date2.timeIntervalSince1970-date1.timeIntervalSince1970);
        return isSuccess;
    }
    return NO;
}

- (BOOL)insertSearchReacordWithString:(NSString *)searchstr
{
    if (searchstr&&searchstr.length) {
        SearchReacordModel *model = [SearchReacordModel new];
        model.searchstr = searchstr;
        NSDate *currentDate = [NSDate date];
        NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
        model.recordTime = dateString;
        return [WHC_ModelSqlite insert:model];
    }
    return NO;
}

- (BOOL)removeAllBookRack
{
    NSArray *books = [WHC_ModelSqlite query:[BookInforModel class]];
    if (books.count) {
        for (int i = 0; i<books.count; i++) {
            BookInforModel *book = books[i];
            //有阅读记录，只是修改一下isAddBook的状态
            if (book.hasRead.intValue && book.currentCatelogId) {
                book.isAddBook = @0;
                BOOL isSuccess = [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
                if (!isSuccess) {
                    return NO;
                }
            }else{
                //没有阅读记录的话,删除这本书并且删除对应的目录
                [WHC_ModelSqlite delete:[BookInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
                [WHC_ModelSqlite delete:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
            }
        }
        return YES;
    }else{
        return YES;
    }
    return NO;
}

-(BOOL)removeAllCatelogs
{
    return [WHC_ModelSqlite delete:[CatelogInforModel class] where:nil];
}
#pragma mark - 单章删除
-(BOOL)removeCatelogWithId:(NSString *)catelogid andFromBook:(NSString *)bookid
{
    CatelogInforModel *model = [self getCatelogWithCatelogId:catelogid andFromBook:bookid];
    if (model) {
        return [WHC_ModelSqlite delete:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@ and chaterId = %@",bookid,catelogid]];
    }
    return NO;
}

#pragma mark - 删除搜索记录
-(BOOL)removeAllSearchRecord
{
    return [WHC_ModelSqlite delete:[SearchReacordModel class] where:nil];
}
#pragma mark -从书架上移除单本书
-(BOOL)removeBookRackWithBook:(NSString *)bookid
{
    BookInforModel *book = [self getBookWithBookId:bookid];
    if (book) {
        if (book.hasRead.intValue && book.currentCatelogId.length) {
            book.isAddBook = @0;
            return [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
        }else{
            //没有阅读记录的话,删除这本书并且删除对应的目录
            BOOL success1 = [WHC_ModelSqlite delete:[BookInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
            BOOL success2 = [WHC_ModelSqlite delete:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
            if (!(success1 && success2)) {
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

- (BookInforModel *)getBookWithBookId:(NSString *)bookid{
    NSArray *temp = (NSArray *)[WHC_ModelSqlite query:[BookInforModel class] where:[NSString stringWithFormat:@"bookid = %@",bookid]];
    return temp.count>0?temp[0]:nil;
}
#pragma mark - 从书架上批量移除书籍
-(BOOL)removeBooksFromBookRack:(NSArray *)books{
    if ([books[0] isKindOfClass:[BookInforModel class]]) {
        for (int i = 0; i<books.count; i++) {
            BookInforModel *book = books[i];
            //有阅读记录，只是修改一下isAddBook的状态
            [self removeBookRackWithBook:book.bookid];
        }
    }else if ([books[0] isKindOfClass:[NSString class]]){
        for (int i = 0; i<books.count; i++) {
            [self removeBookRackWithBook:books[i]];
        }
    }else{
        return NO;
    }
    return NO;
}
#pragma mark - 删除单本书的阅读记录
- (BOOL)removeReadRecordWithBookid:(NSString *)bookid{
    BookInforModel *book = [self getBookWithBookId:bookid];
    if (book) {
        if (book.isAddBook.intValue) {
            book.hasRead = @0;
            book.currentCatelogId = @"";
            return [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
        }else{
            //没有在书架上,删除这本书并且删除对应的目录
            BOOL success1 = [WHC_ModelSqlite delete:[BookInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
            BOOL success2 = [WHC_ModelSqlite delete:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@",book.bookid]];
            if (!(success1 && success2)) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - 删除多本书的阅读记录
- (BOOL)removeReadRecordsFromArray:(NSArray *)records{
    if ([records[0] isKindOfClass:[BookInforModel class]]) {
        for (int i = 0; i<records.count; i++) {
            BookInforModel *book = records[i];
            //有阅读记录，只是修改一下isAddBook的状态
            [self removeReadRecordWithBookid:book.bookid];
        }
        return YES;
    }else if ([records[0] isKindOfClass:[NSString class]]){
        for (int i = 0; i<records.count; i++) {
            [self removeReadRecordWithBookid:records[i]];
        }
        return YES;
    }
    return NO;
}

#pragma mark - 删除目录
- (BOOL)removeCatelogsWithBookid:(NSString *)bookid{
    return [WHC_ModelSqlite delete:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@",bookid]];
}

- (BOOL)removeSearchRecordWithString:(NSString *)searchstr
{
    LRLog(@"sqllocal---%@",[WHCSqlite localPathWithModel:[SearchReacordModel class]]);
    return [WHC_ModelSqlite delete:[SearchReacordModel class] where:[NSString stringWithFormat:@"searchstr = '%@'",searchstr]];
}

- (NSArray *)getBookRackBooks{
    NSArray *temp = [WHC_ModelSqlite query:[BookInforModel class] where:@"isAddBook = 1"];
    if([temp isKindOfClass:[NSArray class]]&&temp){
        return temp;
    }else{
        return [[NSArray alloc]init];
    }
}
#pragma mark -
- (NSArray *)getAllReadRecord{
    return [WHC_ModelSqlite query:[BookInforModel class] where:@"hasRead = 1" order:@"by time desc"];
}

- (NSArray *)getAllSearchRecord
{
    return [WHC_ModelSqlite query:[SearchReacordModel class] where:nil order:@"by recordTime desc"];
}

- (NSArray *)getAllCatelogFromBook:(NSString *)bookid
{
    NSDate *date1 = [NSDate date];
    NSArray *isSuccess = [WHC_ModelSqlite query:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@",bookid]];
    NSDate *date2 = [NSDate date];
    if (isSuccess&&isSuccess.count) {
        isSuccess = [isSuccess sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [((CatelogInforModel *)obj1).chaterId compare:((CatelogInforModel *)obj2).chaterId options:NSNumericSearch];
        }];
    }
    LRLog(@"qureydate----%f",date2.timeIntervalSince1970-date1.timeIntervalSince1970);
    return isSuccess;
}

- (CatelogInforModel *)getCatelogWithCatelogId:(NSString *)catelogid andFromBook:(NSString *)bookid
{
    NSArray *temp = (NSArray *)[WHC_ModelSqlite query:[CatelogInforModel class] where:[NSString stringWithFormat:@"entityid = %@%@",bookid,catelogid]];
    return temp.count>0?temp[0]:nil;
}

- (BOOL)getIsCurrentCatelogDownload:(NSString *)catelogid fromBook:(NSString *)bookid{
    NSArray *catelogs = [WHC_ModelSqlite query:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@ and chaterId = %@",bookid,catelogid]];
    CatelogInforModel *catelog = catelogs.count>0?catelogs[0]:nil;
    if (catelog && (catelog.isDownload.intValue==1)) {
        return YES;
    }
    return NO;
}

- (NSArray *)getPaymentStatusWithCurrentCatelog:(NSString *)catelog andCount:(NSInteger)count fromBook:(NSString *)bookid
{
    NSArray *tempArray = [WHC_ModelSqlite query:[CatelogInforModel class] where:[NSString stringWithFormat:@"bookid = %@ and isPay = 1",bookid] order:@"by chaterId asc"];
    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [((CatelogInforModel *)obj1).chaterId compare:((CatelogInforModel *)obj2).chaterId options:NSNumericSearch];
    }];

    if (count == 0) {
        count = 100;
    }
    NSMutableArray *results = [NSMutableArray new];
    if (tempArray.count) {
        for (CatelogInforModel *currenCatelog in tempArray) {
            if (currenCatelog.chaterId.integerValue >= catelog.integerValue) {
                [results addObject:currenCatelog];
                if (results.count == count) {
                    return results;
                }
            }
        }
    }
    return results;
}

#pragma mark - 查询书籍对应的分页信息
- (NSArray *)getParkCatelogsWithBookId:(NSString *)bookid{
    NSArray *tempArray = [WHC_ModelSqlite query:[ParkCatelogModel class] where:[NSString stringWithFormat:@"bookid = %@",bookid] order:@"by startId desc"];
    return tempArray;
}

- (BOOL)updatePaymentRecordWithArray:(NSArray *)catelogs fromBook:(NSString *)bookid
{
    for (int i = 0; i<catelogs.count; i++) {
        CatelogInforModel *catelog = catelogs[i];
        catelog.isAlreadyPay = @1;
        catelog.isPay = @0;
        [WHC_ModelSqlite update:catelog where:[NSString stringWithFormat:@"entityid = %@",catelog.entityid]];
    }
    return YES;
}

- (BOOL)updatePaymentRecordWithCatelog:(NSString *)catelogId fromBook:(NSString *)bookid{
    CatelogInforModel *catelog = [self getCatelogWithCatelogId:catelogId andFromBook:bookid];
    if (catelog) {
        catelog.isAlreadyPay = @0;
        return [WHC_ModelSqlite update:catelog where:[NSString stringWithFormat:@"bookid = %@ and chaterId = %@",bookid,catelogId]];
    }
    return NO;
}

- (BOOL)updateReadRecordWithBookid:(NSString *)bookid andCaputerid:(NSString *)catelogid andTips:(NSString *)tips andPosition:(NSNumber *)position{
    BookInforModel *model = [self getBookWithBookId:bookid];
    if (model) {
        if (catelogid) {
            model.currentCatelogId = catelogid;
        }
        model.hasRead = @1;
        return [WHC_ModelSqlite update:model where:[NSString stringWithFormat:@"bookid = %@",bookid]];
    }
    return NO;
}
#pragma mark - 插入章节
- (void)insertChaperToDataBase:(NSDictionary *)dict{
    NSDictionary *dictionary = dict.mutableCopy;
    NSArray *capInfoArray = (NSArray *)[dictionary arrayForKey:@"capInfo"];
    
    NSString *ChaperId = @"";
    if (capInfoArray.count) {
        NSDictionary *capInfoDict = capInfoArray[0];
        ChaperId = [capInfoDict stringForKey:@"chapterId"];
    }
    
    NSString *bookId = [dictionary stringForKey:@"bookId"];
    
    CatelogInforModel *chapter = [self getCatelogWithCatelogId:ChaperId andFromBook:bookId  ];
    if(chapter ==nil)
    {
        chapter = [CatelogInforModel new];
        chapter.chaterId = ChaperId;
        chapter.url = [dictionary stringForKey:@"url"];
        chapter.entityid = [NSString stringWithFormat:@"%@%@",bookId,ChaperId];
        chapter.isDownload = @1;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self insertCatelogWithObject:chapter];
        });
        return ;
    }else{
        chapter.chaterId = ChaperId;
        chapter.url = [dictionary stringForKey:@"url"];
        chapter.entityid = [NSString stringWithFormat:@"%@%@",bookId,ChaperId];
        chapter.isDownload = @1;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite update:chapter where:[NSString stringWithFormat:@"entityid = %@",chapter.entityid]];
        });
    }
}
#pragma mark- 插入书架
- (BOOL)insertData:(NSDictionary *)requestData{
    NSDictionary *dict = requestData[@"book"];
    
    NSString *bookRackId = dict[@"bookId"];
    NSDictionary *lastChap = requestData[@"lastChapterInfo"];
    NSArray *array = requestData[@"chapterList"];
    
    NSDictionary *chapterListDict = nil;
    if (array.count) {
        chapterListDict = array[0];
    }
    
    BookInforModel *bookRack = [self getBookWithBookId:bookRackId];
    if(bookRack == nil)
    {
        bookRack = [BookInforModel new];
        bookRack.bookid = bookRackId;
        bookRack.entityid = bookRackId;
        bookRack.coverurl = dict[@"coverWap"];
        bookRack.bookName = dict[@"bookName"];
        bookRack.updateChapter = lastChap[@"chapterId"];
        bookRack.author = dict[@"author"];
        bookRack.time = requestData[@"dateTime"];
        bookRack.dateTime = requestData[@"dateTime"];
        bookRack.chapterId = chapterListDict[@"chapterId"];
        bookRack.introuce = dict[@"introduction"];
        bookRack.marketStatus = @([dict[@"marketStatus"] integerValue]);
        bookRack.isAddBook = @1;
      //  dispatch_async(dispatch_get_global_queue(0, 0), ^{
          return [self insertBookRackWithObject:bookRack];
      //  });
    }else{
        bookRack.coverurl = dict[@"coverWap"];
        bookRack.bookName = dict[@"bookName"];
        bookRack.updateChapter = lastChap[@"chapterId"];
        bookRack.author = dict[@"author"];
        bookRack.time = requestData[@"dateTime"];
        bookRack.dateTime = requestData[@"dateTime"];
        bookRack.chapterId = chapterListDict[@"chapterId"];
        bookRack.introuce = dict[@"introduction"];
        bookRack.marketStatus = @([dict[@"marketStatus"] integerValue]);
        bookRack.isAddBook = @1;
      //  dispatch_async(dispatch_get_global_queue(0, 0), ^{
           return  [WHC_ModelSqlite update:bookRack where:[NSString stringWithFormat:@"bookid = %@",bookRack.bookid]];
       // });
    }
}
#pragma mark- 插入目录和分页信息
- (void)insertCatelogAndParkToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd{
    NSDictionary *dictionary = dict;
    
    NSString *bookId = dictionary[@"bookId"];
    
    NSString *parkCatalodID = @"";
    NSArray *blockList = dict[@"blockList"];
    NSDictionary *blockListDict = [NSDictionary dictionary];
    
    NSMutableArray * tempArray = [NSMutableArray new];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if (book == nil) {
        book = [BookInforModel new];
        book.bookid = bookId;
        book.entityid = bookId;
        [WHC_ModelSqlite insert:book];
    }
    if (blockList.count>0) {
        //如果YOU分页信息
        for (int i = 0; i < blockList.count; i ++) {
            blockListDict = blockList[i];
            parkCatalodID = blockListDict[@"startId"];
            ParkCatelogModel *parkCatalog = [ParkCatelogModel new];
            parkCatalog.endId = [NSString stringWithFormat:@"%@",blockListDict[@"endId"]];
            parkCatalog.startId = [NSString stringWithFormat:@"%@",blockListDict[@"startId"]];
            parkCatalog.tips = [NSString stringWithFormat:@"%@",blockListDict[@"tips"]];
            parkCatalog.bookid = bookId;
            [tempArray addObject:parkCatalog];
        }
        book.parkCatalog = tempArray;
    }
    book.bookid = bookId;
    //<--以上重置书籍的分页信息--->
    NSString *catelogID = @"";
    NSString *catelogName = @"";
    NSString *isPay = @"";
    NSArray *chapterIdListArray = dictionary[@"chapterIdList"];
    NSArray *chapterNameList = dictionary[@"chapterNameList"];
    NSString *isChargeList = [NSString stringWithFormat:@"%@",dictionary[@"isChargeList"]];
    //章节排重
    NSArray *allCatelogs = [self getAllCatelogFromBook:bookId];
    NSMutableDictionary *cacheMunie = [NSMutableDictionary new];
    for (CatelogInforModel *catelog in allCatelogs) {
        [cacheMunie setObject:catelog forKey:catelog.entityid];
    }
    
    NSMutableArray *catelogs = [NSMutableArray new];
    for (int i = 0; i < chapterIdListArray.count; i ++) {
        //目录的ID
        catelogID = chapterIdListArray[i];
        //目录的名字
        catelogName = chapterNameList[i];
        isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
        
        NSString *entityid = [NSString stringWithFormat:@"%@%@",bookId,catelogID];
        CatelogInforModel *catelog = [cacheMunie objectForKey:entityid];
        if (catelog == nil) {
            catelog = [CatelogInforModel new];
            catelog.chaterId = catelogID;
            catelog.bookid = bookId;
            catelog.entityid = entityid;
            catelog.isPay = [NSNumber numberWithFloat:isPay.floatValue];
            catelog.catelogName = catelogName;
            [catelogs addObject:catelog];
        }
    }
    [self insertCatelogsWithArray:catelogs];
    //<--以上存储目录信息-->
    
    if (isEnd) {
        book.isparkCatalog = @(1);
        book.isUpate = @(0);
    } else {
        book.isparkCatalog = @(0);
        book.isUpate = @(0);
    }
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
}


- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd andIsBatch:(BOOL)isBatch andIsCallDraw:(BOOL)isCallDraw{
    
    NSDictionary *dictionary = dict;
    
    NSString *bookId = dictionary[@"bookId"];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if (book == nil) {
        book = [BookInforModel new];
        book.bookid = bookId;
        [WHC_ModelSqlite insert:book];
    }
    book.bookid = bookId;
//<--以上重置书籍的分页信息--->
    NSString *catelogID = @"";
    NSString *catelogName = @"";
    NSString *isPay = @"";
    NSArray *chapterIdListArray = dictionary[@"chapterIdList"];
    NSArray *chapterNameList = dictionary[@"chapterNameList"];
    NSString *isChargeList = [NSString stringWithFormat:@"%@",dictionary[@"isChargeList"]];
    //章节排重
    if(chapterIdListArray.count>100){
        [self removeCatelogsWithBookid:bookId];
        NSMutableArray *catelogs = [NSMutableArray new];

        for (int i = 0; i < chapterIdListArray.count; i ++) {
            //目录的ID
            catelogID = chapterIdListArray[i];
            //目录的名字
            catelogName = chapterNameList[i];
            isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
            
            NSString *entityid = [NSString stringWithFormat:@"%@%@",bookId,catelogID];
            CatelogInforModel *catelog = [CatelogInforModel new];
            catelog.chaterId = catelogID;
            catelog.bookid = bookId;
            catelog.entityid = entityid;
            catelog.isPay = [NSNumber numberWithFloat:isPay.floatValue];
            catelog.catelogName = catelogName;
            [catelogs addObject:catelog];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self insertCatelogsWithArray:catelogs];
        });
    }else{
        NSArray *allCatelogs = [self getAllCatelogFromBook:bookId];
        NSMutableDictionary *cacheMunie = [NSMutableDictionary new];
        for (CatelogInforModel *catelog in allCatelogs) {
            [cacheMunie setObject:catelog forKey:catelog.entityid];
        }
        
        NSMutableArray *catelogs = [NSMutableArray new];
        for (int i = 0; i < chapterIdListArray.count; i ++) {
            //目录的ID
            catelogID = chapterIdListArray[i];
            //目录的名字
            catelogName = chapterNameList[i];
            isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
            
            NSString *entityid = [NSString stringWithFormat:@"%@%@",bookId,catelogID];
            CatelogInforModel *catelog = [cacheMunie objectForKey:entityid];
            if (catelog == nil) {
                catelog = [CatelogInforModel new];
                catelog.chaterId = catelogID;
                catelog.bookid = bookId;
                catelog.entityid = entityid;
                catelog.isPay = [NSNumber numberWithFloat:isPay.floatValue];
                catelog.catelogName = catelogName;
                [catelogs addObject:catelog];
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self insertCatelogsWithArray:catelogs];
        });
    }
    //<--以上存储目录信息-->
    
    if (isEnd) {
        book.isUpate = @(0);
    } else {
        book.isUpate = @(0);
    }
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
}

- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd{
    [self insertCatelogToDataBase:dict andIsEnd:isEnd andIsBatch:nil andIsCallDraw:nil];
}
#pragma mark - 插入阅读记录
- (void)insertReadBook:(NSDictionary *)requestData
{
    NSDictionary *dictionary = requestData;
    NSString *bookid = dictionary[@"bookID"];

    BookInforModel *readRecord = [self getBookWithBookId:bookid];
    if (readRecord) {
        readRecord.currentPageIndex = dictionary[@"currentPageIndex"];
        readRecord.chapterIndex = dictionary[@"chapterIndex"];
        readRecord.coverurl = dictionary[@"bookIcon"];
        readRecord.bookName = dictionary[@"bookName"];
        readRecord.introuce = dictionary[@"introduce"];
        readRecord.time = dictionary[@"dateString"];
        readRecord.dateTime = dictionary[@"dateString"];
        readRecord.currentCatelogId = dictionary[@"chapterID"];
        readRecord.currentName = dictionary[@"chapterName"];
        readRecord.hasRead = @1;
       // dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite update:readRecord where:[NSString stringWithFormat:@"bookID = %@",bookid]];
       // });
    }else{
        readRecord = [BookInforModel new];
        readRecord.currentPageIndex = dictionary[@"currentPageIndex"];
        readRecord.chapterIndex = dictionary[@"chapterIndex"];
        readRecord.bookid = dictionary[@"bookID"];
        readRecord.author = dictionary[@"author"];
        readRecord.coverurl = dictionary[@"bookIcon"];
        readRecord.bookName = dictionary[@"bookName"];
        readRecord.introuce = dictionary[@"introduce"];
        readRecord.time = dictionary[@"dateString"];
        readRecord.dateTime = dictionary[@"dateString"];
        readRecord.currentName = dictionary[@"chapterName"];
        readRecord.hasRead = @1;
        readRecord.currentCatelogId = dictionary[@"chapterID"];
      //  dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite insert:readRecord];
       // });
    }

}

#pragma mark - 插入一条搜索记录
- (void)insertSearchRecord:(NSDictionary *)requestData{
    NSString *keyWord = requestData[@"keyWord"];
    SearchReacordModel *record = [self getSearchModelWithKeyWord:keyWord];
    if (record == nil) {
        record = [SearchReacordModel new];
        record.searchstr = requestData[@"keyWord"];
        record.recordTime = requestData[@"recordTime"];
        [self insertSearchReacordWithString:keyWord];
    }else{
        record.searchstr = requestData[@"keyWord"];
        record.recordTime = requestData[@"recordTime"];
        [WHC_ModelSqlite update:record where:[NSString stringWithFormat:@"keyword = %@",keyWord]];
    }
}
- (SearchReacordModel *)getSearchModelWithKeyWord:(NSString *)keyWord{
    NSArray *temp = [WHC_ModelSqlite query:[SearchReacordModel class] where:[NSString stringWithFormat:@"searchstr = '%@'",keyWord]];
    
    return temp.count>0?(SearchReacordModel *)temp[0]:nil;
}

#pragma mark - 修改支付情况
-(void)amendPayRecord:(NSDictionary *)dict{
    NSDictionary *dictionary = dict;
    NSString *bookId = dictionary[@"bookID"];
    
    NSInteger afterNum = [dictionary[@"afterNum"] integerValue];
    NSString *catelogID = dictionary[@"consumeChapterID"];
    NSString *chaputerName = dictionary[@"consumeChapterName"];
    if (afterNum == 1) {
        CatelogInforModel *catelog = [self getCatelogWithCatelogId:catelogID andFromBook:bookId];
        
        if (catelog == nil) {
            catelog = [CatelogInforModel new];
            catelog.chaterId = catelogID;
            catelog.catelogName = chaputerName.length>0?chaputerName:@"";
            catelog.isPay = @0;
            catelog.isAlreadyPay = @1;
            catelog.entityid = [NSString stringWithFormat:@"%@%@",bookId,catelogID];
            [WHC_ModelSqlite insert:catelog];
        }else{
            catelog.catelogName = chaputerName.length>0?chaputerName:@"";
            catelog.isPay = @0;
            catelog.isAlreadyPay = @1;
            [WHC_ModelSqlite update:catelog where:[NSString stringWithFormat:@"entityid = %@%@",bookId,catelogID]];
        }
    } else {
        NSArray *catelogs = [self getPaymentStatusWithCurrentCatelog:catelogID andCount:afterNum fromBook:bookId];
        [self updatePaymentRecordWithArray:catelogs fromBook:bookId];
    }
}
#pragma mark - 更新自动购买状态
-(void)amendAutoBuy:(NSDictionary *)dict{
    NSDictionary *dictionary = dict;
    int isAutoBuy = [dictionary[@"isAutoBuy"] intValue];
    NSString *bookId = dictionary[@"bookID"];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if(book == nil)
    {
        book = [BookInforModel new];
        book.entityid = bookId;
        book.bookid = bookId;
        [WHC_ModelSqlite insert:book];
    }
    if (isAutoBuy == 1) {
        book.confirmStatus = @(1);//不弹
    } else {
        book.confirmStatus = @(0);
    }
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
}

-(void)updateChapter:(NSDictionary *)dict{
    NSDictionary *dictionary = dict;
    int isUpdate = [dictionary[@"isUpdate"] intValue];
    NSString *bookId = dictionary[@"bookID"];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if(book == nil)
    {
        book = [BookInforModel new];
        book.entityid = bookId;
        book.bookid = bookId;
    }
    if (isUpdate == 1) {
        book.isUpdate = @(1);
    } else {
        book.isUpdate = @(0);
    }
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
}
#pragma mark - 更新书籍付费状态
- (void)updateBookIsFree:(NSDictionary *)dict{
    NSDictionary *dictionary = dict;
    NSString *bookId = [dictionary stringForKey:@"bookId"];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if(book == nil)
    {
        book = [BookInforModel new];
        book.entityid = bookId;
        book.bookid = bookId;
    }
    
    NSInteger markrtStatus = [dictionary[@"marketStatus"] integerValue];
    
    book.marketStatus = @(markrtStatus);
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
}
#pragma mark - 更新书籍的价格
-(void)bookChapterPrice:(NSDictionary *)dict AndbookID:(NSString *)bookID{
    BookInforModel *book = [self getBookWithBookId:bookID];
    if(book == nil)
    {
        book = [BookInforModel new];
        book.entityid = bookID;
        book.bookid = bookID;
    }
    book.price = [NSString stringWithFormat:@"%@",dict[@"discountPrice"]];
    book.sourceFrom = [NSString stringWithFormat:@"%@",dict[@"totalPrice"]];
    book.marketId = [NSString stringWithFormat:@"%@",dict[@"discountRate"]];
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookID]];
}

#pragma mark- 修改章节付费信息
-(void)amendPayRecordBookDedail:(NSDictionary *)dict{
    NSString *bookId = dict[@"bookID"];
    BookInforModel *book = [self getBookWithBookId:bookId];
    if(book == nil)
    {
        book = [BookInforModel new];
        book.entityid = bookId;
        book.bookid = bookId;
    }
    
    book.isUpate = @(0);
    
    NSString *chapterID = dict[@"consumeChapterID"];
    
    CatelogInforModel *catelog = [self getCatelogWithCatelogId:chapterID andFromBook:bookId];
    
    if (catelog == nil) {
        catelog = [CatelogInforModel new];
        catelog.entityid = [NSString stringWithFormat:@"%@%@",bookId,chapterID];
        catelog.chaterId = chapterID;
    }
    
    catelog.isPay = @0;
    catelog.catelogName = dict[@"chapterName"];
    [WHC_ModelSqlite update:book where:[NSString stringWithFormat:@"bookid = %@",bookId]];
    [WHC_ModelSqlite update:catelog where:[NSString stringWithFormat:@"entityid = %@",[NSString stringWithFormat:@"%@%@",bookId,chapterID]]];
}

/** 插入wifi上传的书籍 */
- (void)insertBookWifi:(NSDictionary *)requestData{
    
}

@end
