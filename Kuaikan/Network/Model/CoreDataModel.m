//
//  CoreDataModel.m
//  Kuaikan
//
//  Created by 少少 on 16/3/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CoreDataModel.h"
#import "Catelog+CoreDataClass.h"
#import "BookRack+CoreDataClass.h"
#import "Rack+CoreDataClass.h"
#import "SearchRecord+CoreDataClass.h"
#import "Read+CoreDataClass.h"
#import "ReadRecord+CoreDataClass.h"
#import "Record+CoreDataClass.h"
#import "ParkCatalog+CoreDataClass.h"

@interface CoreDataModel ()

@property (nonatomic, assign) BOOL isEnd;


@end

@implementation CoreDataModel

- (void)getBookAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData{
    Message  *message = [[Message alloc]init];
    message.requestData = requestData;
    message.call = call;
    [self sendMessage:message];
}

- (void)getChapterAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData{
    
    Message  *message = [[Message alloc]init];
    message.requestData = requestData;
    message.call = call;
    [self sendMessage:message];
}

- (void)getCatelogAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData andIsEnd:(BOOL)isEnd{
    
    Message *message = [[Message alloc] init];
    message.call = call;
    message.requestData = requestData;
    message.requestType = RequestTypePortal;
    message.responder = self;
    message.isEncrypt = YES;
    _isEnd = isEnd;
    [self sendMessage:message];
    
}

//更新一本书是否是免费
- (void)updateBookIsFree:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("readReco54rd", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            
            
            NSString *bookId = [dictionary stringForKey:@"bookId"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            NSInteger markrtStatus = [dictionary[@"marketStatus"] integerValue];
            
            book.marketStatus = @(markrtStatus);
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
        
//    });
}

//插入章节到数据库
- (void)insertChaperToDataBase:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("r15eadRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSArray *capInfoArray = (NSArray *)[dictionary arrayForKey:@"capInfo"];
            
            NSString *ChaperId = @"";
            if (capInfoArray.count) {
                NSDictionary *capInfoDict = capInfoArray[0];
                ChaperId = [capInfoDict stringForKey:@"chapterId"];
            }
            
            NSString *bookId = [dictionary stringForKey:@"bookId"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book ==nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            
            Chapter *chapter = [dataManager asyncFetchEntitysWithName:@"Chapter" entityId:ChaperId];
            if(chapter ==nil)
            {
                chapter = [dataManager asyncInsertEntityWithName:@"Chapter"];
                chapter.entityid = ChaperId;
            }
            chapter.path = [dictionary stringForKey:@"url"];
            chapter.entityid = ChaperId;
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
//    });
    
}

//插入目录和目录分页到数据库
- (void)insertCatelogAndParkToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd{
//    dispatch_queue_t queue = dispatch_queue_create("readRecor1534d", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSString *bookId = dictionary[@"bookId"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil){
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            NSString *parkCatalodID = @"";
            NSArray *blockList = dict[@"blockList"];
            NSDictionary *blockListDict = [NSDictionary dictionary];
            
            
            for (int i = 0; i < blockList.count; i ++) {
                blockListDict = blockList[i];
                parkCatalodID = blockListDict[@"startId"];
                ParkCatalog *parkCatalog = [dataManager FetchEntitysWithName:@"ParkCatalog" entityId:parkCatalodID];
                if (parkCatalog == nil) {
                    parkCatalog = [dataManager asyncInsertEntityWithName:@"ParkCatalog"];
                    parkCatalog.entityid = parkCatalodID;
                    
                }
                parkCatalog.endId = [NSString stringWithFormat:@"%@",blockListDict[@"endId"]];
                parkCatalog.startId = [NSString stringWithFormat:@"%@",blockListDict[@"startId"]];
                parkCatalog.tips = [NSString stringWithFormat:@"%@",blockListDict[@"tips"]];
                parkCatalog.book = book;
            }
            
            NSString *catelogID = @"";
            NSString *catelogName = @"";
            NSString *isPay = @"";
            NSArray *chapterIdListArray = dictionary[@"chapterIdList"];
            
            NSArray *chapterNameList = dictionary[@"chapterNameList"];
            NSString *isChargeList = [NSString stringWithFormat:@"%@",dictionary[@"isChargeList"]];
            
            for (int i = 0; i < chapterIdListArray.count; i ++) {
                //目录的ID
                catelogID = chapterIdListArray[i];
                //目录的名字
                catelogName = chapterNameList[i];
                isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
                
                Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:catelogID];
                //            currentPos
                if (catelog == nil) {
                    catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                    catelog.entityid = catelogID;
                }
                //            catelog.currentPos = @(i + 1);
                catelog.book = book;
                catelog.ispay = isPay;
                catelog.catelogname = catelogName;
            }
            
            if (isEnd) {
                book.isparkCatalog = @(1);
                book.isEnd = @(1);
            } else {
                book.isparkCatalog = @(0);
                book.isEnd = @(0);
            }
            [dataManager asyncSave];
            
        } completion:^{
            [SVProgressHUD dismiss];
            
        }];
        
//    });
    
    
}

//插入目录到数据库
- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd{
//    dispatch_queue_t queue = dispatch_queue_create("readRecor154d", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSString *bookId = dictionary[@"bookId"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil){
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            NSString *catelogID = @"";
            NSString *catelogName = @"";
            NSString *isPay = @"";
            NSArray *chapterIdListArray = dictionary[@"chapterIdList"];
            
            NSArray *chapterNameList = dictionary[@"chapterNameList"];
            NSString *isChargeList = [NSString stringWithFormat:@"%@",dictionary[@"isChargeList"]];
            
            for (int i = 0; i < chapterIdListArray.count; i ++) {
                //目录的ID
                catelogID = chapterIdListArray[i];
                //目录的名字
                catelogName = chapterNameList[i];
                isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
                
                Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:catelogID];
                
                if (catelog == nil) {
                    catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                    catelog.entityid = catelogID;
                }
                //            catelog.currentPos = @(i + 1);
                catelog.book = book;
                catelog.ispay = isPay;
                catelog.catelogname = catelogName;
            }
            
            if (isEnd) {
                book.isEnd = @(1);
            } else {
                book.isEnd = @(0);
            }
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
        
//    });

}


//插入目录到数据库
- (void)insertCatelogToDataBase:(NSDictionary *)dict andIsEnd:(BOOL)isEnd andIsBatch:(BOOL)isBatch andIsCallDraw:(BOOL)isCallDraw{
//    dispatch_queue_t queue = dispatch_queue_create("readReco1543rd", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSString *bookId = dictionary[@"bookId"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil){
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            NSString *catelogID = @"";
            NSString *catelogName = @"";
            NSString *isPay = @"";
            NSArray *chapterIdListArray = dictionary[@"chapterIdList"];
            
            NSArray *chapterNameList = dictionary[@"chapterNameList"];
            NSString *isChargeList = [NSString stringWithFormat:@"%@",dictionary[@"isChargeList"]];
            
            for (int i = 0; i < chapterIdListArray.count; i ++) {
                //目录的ID
                catelogID = chapterIdListArray[i];
                //目录的名字
                catelogName = chapterNameList[i];
                isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
                
                Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:catelogID];
                
                if (catelog == nil) {
                    catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                    catelog.entityid = catelogID;
                }
                //            catelog.currentPos = @(i + 1);
                catelog.book = book;
                catelog.ispay = isPay;
                catelog.catelogname = catelogName;
            }
            
            if (isEnd) {
                book.isEnd = @(1);
            } else {
                book.isEnd = @(0);
            }
            [dataManager asyncSave];
            
        } completion:^{
            [SVProgressHUD dismiss];
        }];
//    });
    
}


//修改章节支付情况
- (void)amendPayRecordBookDedail:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("rea654dRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSString *bookId = dictionary[@"bookID"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            book.isEnd = @(1);
            
            NSString *chapterID = dictionary[@"consumeChapterID"];
            
            
            
            Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:chapterID];
            
            if (catelog == nil) {
                catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                catelog.entityid = chapterID;
            }
            
            catelog.ispay = @"0";
            catelog.book = book;
            catelog.catelogname = dictionary[@"chapterName"];
            [dataManager asyncSave];
        } completion:^{
            
        }];
//    });
    
    
}


//修改章节支付情况
- (void)amendPayRecord:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("rea1543dRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            NSString *bookId = dictionary[@"bookID"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            
            int afterNum = [dictionary[@"afterNum"] intValue];
            NSString *chapterID = dictionary[@"consumeChapterID"];
            NSString *catelogID = @"";
            NSString *chaputerName = dictionary[@"consumeChapterName"];
            
            if (afterNum == 1) {
                Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:chapterID];
                
                if (catelog == nil) {
                    catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                    catelog.entityid = chapterID;
                }
                catelog.catelogname = chaputerName.length>0?chaputerName:@"";
                catelog.ispay = @"0";
                catelog.book = book;
            } else {
                int chapterIndex = [dictionary[@"consumeChapterIndex"] intValue];
                NSArray *chapterIdListArray = dictionary[@"chapterIdListArray"];
                
                for (int i = chapterIndex; i < chapterIndex + afterNum; i ++) {
                    if (chapterIdListArray.count > i) {
                        catelogID = chapterIdListArray[i];
                        Catelog *catelog = [dataManager asyncFetchEntitysWithName:@"Catelog" entityId:catelogID];
                        if (catelog == nil) {
                            catelog = [dataManager asyncInsertEntityWithName:@"Catelog"];
                            catelog.entityid = chapterID;
                        }
                        catelog.ispay = @"0";
                        catelog.book = book;

                    }
                }
            }
            [dataManager asyncSave];

            
        } completion:^{
            
        }];
//    });
}
- (void)amendPayRecordSnyc:(NSDictionary *)dict{
    //    dispatch_queue_t queue = dispatch_queue_create("rea1543dRecord", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_barrier_async(queue, ^{
    __block NSDictionary *dictionary = dict;
    DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
    NSString *bookId = dictionary[@"bookID"];
    Book *book = [dataManager FetchEntitysWithName:@"Book" entityId:bookId];
    if(book == nil)
    {
        book = [dataManager insertEntityWithName:@"Book"];
        book.entityid = bookId;
    }
    
    NSString *chapterID = dictionary[@"consumeChapterID"];
    NSString *chaputerName = dictionary[@"consumeChapterName"];
    
    Catelog *catelog = [dataManager FetchEntitysWithName:@"Catelog" entityId:chapterID];
    
    if (catelog == nil) {
        catelog = [dataManager insertEntityWithName:@"Catelog"];
        catelog.entityid = chapterID;
    }
    catelog.catelogname = chaputerName.length>0?chaputerName:@"";
    catelog.ispay = @"0";
    catelog.book = book;
    [dataManager save];
}


//插入一本书到书架
- (void)insertData:(NSDictionary *)requestData{
//    dispatch_queue_t queue = dispatch_queue_create("rea26234dRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = requestData;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            Rack *rack = [dataManager asyncFetchEntitysWithName:@"Rack" entityId:RackOnlyID];
            if(rack == nil)
            {
                rack = [dataManager asyncInsertEntityWithName:@"Rack"];
                rack.entityid = RackOnlyID;
            }
            
            NSDictionary *dict = dictionary[@"book"];
            
            NSString *bookRackId = dict[@"bookId"];
            NSDictionary *lastChap = dictionary[@"lastChapterInfo"];
            NSArray *array = dictionary[@"chapterList"];
            
            NSDictionary *chapterListDict = nil;
            if (array.count) {
                chapterListDict = array[0];
            }
            
            BookRack *bookRack = [dataManager asyncFetchEntitysWithName:@"BookRack" entityId:bookRackId];
            if(bookRack == nil)
            {
                bookRack = [dataManager asyncInsertEntityWithName:@"BookRack"];
                bookRack.entityid = bookRackId;
            }
            
            bookRack.rack = rack;
            bookRack.coverImage = dict[@"coverWap"];
            bookRack.bookName = dict[@"bookName"];
            bookRack.updateChapter = lastChap[@"chapterId"];
            bookRack.entityid = bookRackId;
            bookRack.author = dict[@"author"];
            bookRack.dateTime = dictionary[@"dateTime"];
            bookRack.chapterId = chapterListDict[@"chapterId"];
            bookRack.introuce = dict[@"introduction"];
            
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
        
//    });

}

//插入一条搜索记录
- (void)insertSearchRecord:(NSDictionary *)requestData{
//    dispatch_queue_t queue = dispatch_queue_create("read654Record", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = requestData;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            SearchRecord *seaRecord = [dataManager asyncFetchEntitysWithName:@"SearchRecord" entityId:SearchRecordOnlyID];
            
            if(seaRecord == nil)
            {
                seaRecord = [dataManager asyncInsertEntityWithName:@"SearchRecord"];
                seaRecord.entityid = SearchRecordOnlyID;
            }
            
            Record *record = [dataManager asyncFetchEntitysWithName:@"Record" entityId:dictionary[@"keyWord"]];
            if(record == nil)
            {
                record = [dataManager asyncInsertEntityWithName:@"Record"];
                record.entityid = dictionary[@"keyWord"];
            }
            
            record.searchRecord = seaRecord;
            record.keyword = dictionary[@"keyWord"];
            record.recordTime = dictionary[@"recordTime"];
            
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
        
//    });
    
}


//插入wifi上传成功的书籍
- (void)insertBookWifi:(NSDictionary *)requestData{
    
//    dispatch_queue_t queue = dispatch_queue_create("rea534dRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            Rack *rack = [dataManager asyncFetchEntitysWithName:@"Rack" entityId:RackOnlyID];
            if(rack == nil)
            {
                rack = [dataManager asyncInsertEntityWithName:@"Rack"];
                rack.entityid = RackOnlyID;
            }
            
            NSString *bookRackId = requestData[@"dateTime"];
            BookRack *bookRack = [dataManager asyncFetchEntitysWithName:@"BookRack" entityId:bookRackId];
            if(bookRack == nil)
            {
                bookRack = [dataManager asyncInsertEntityWithName:@"BookRack"];
                bookRack.entityid = bookRackId;
            }
            
            bookRack.rack = rack;
            bookRack.bookName = requestData[@"bookName"];
            bookRack.entityid = bookRackId;
            bookRack.wifiBook = @"wifiBook";
            bookRack.dateTime = bookRackId;
            
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
//    });
    
}



//插入阅读记录
- (void)insertReadBook:(NSDictionary *)requestData{
//    dispatch_queue_t queue = dispatch_queue_create("readR324ecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = requestData;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            Read *read = [dataManager asyncFetchEntitysWithName:@"Read" entityId:ReadOnlyID];
            if(read == nil)
            {
                read = [dataManager asyncInsertEntityWithName:@"Read"];
                read.entityid = ReadOnlyID;
            }
            
            ReadRecord *readRecord = [dataManager asyncFetchEntitysWithName:@"ReadRecord" entityId:dictionary[@"bookID"]];
            if(readRecord == nil)
            {
                readRecord = [dataManager asyncInsertEntityWithName:@"ReadRecord"];
                readRecord.entityid = dictionary[@"bookID"];
            }
            
//            LRLog(@"%@",readRecord);
            
            readRecord.read = read;
            readRecord.currentPageIndex = dictionary[@"currentPageIndex"];
            readRecord.chapterIndex = dictionary[@"chapterIndex"];
            readRecord.bookID = dictionary[@"bookID"];
            readRecord.author = dictionary[@"author"];
            readRecord.bookIcon = dictionary[@"bookIcon"];
            readRecord.bookName = dictionary[@"bookName"];
            readRecord.introduce = dictionary[@"introduce"];
            readRecord.readTime = dictionary[@"dateString"];
            readRecord.chapterID = dictionary[@"chapterID"];
            [dataManager asyncSave];
            
        } completion:^{
            
        }];
//    });
}


//自动购买
- (void)amendAutoBuy:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("r213eadRecord", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            
            int isAutoBuy = [dictionary[@"isAutoBuy"] intValue];
            NSString *bookId = dictionary[@"bookID"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            if (isAutoBuy == 1) {
                book.confirmStatus = @(1);//不弹
            } else {
                book.confirmStatus = @(0);
            }
            
            [dataManager asyncSave];
        } completion:^{
            
        }];
        
//    });
    
}

//是否有更新章节
- (void)updateChapter:(NSDictionary *)dict{
//    dispatch_queue_t queue = dispatch_queue_create("readReco321rd", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            int isUpdate = [dictionary[@"isUpdate"] intValue];
            NSString *bookId = dictionary[@"bookID"];
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookId];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookId;
            }
            if (isUpdate == 1) {
                book.isUpdate = @(1);
            } else {
                book.isUpdate = @(0);
            }
            
            [dataManager asyncSave];
        } completion:^{
            
        }];
        
//    });
    
}

//记录一本书章节的价格
- (void)bookChapterPrice:(NSDictionary *)dict AndbookID:(NSString *)bookID{
//    dispatch_queue_t queue = dispatch_queue_create("readRecord23", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_barrier_async(queue, ^{
        __block NSDictionary *dictionary = dict;
        DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
        [dataManager asyncExcuteWithBlock:^{
            Book *book = [dataManager asyncFetchEntitysWithName:@"Book" entityId:bookID];
            if(book == nil)
            {
                book = [dataManager asyncInsertEntityWithName:@"Book"];
                book.entityid = bookID;
            }
            book.price = [NSString stringWithFormat:@"%@",dictionary[@"discountPrice"]];
            book.sourceFrom = [NSString stringWithFormat:@"%@",dictionary[@"totalPrice"]];
            book.marketId = [NSString stringWithFormat:@"%@",dictionary[@"discountRate"]];
            [dataManager asyncSave];
        } completion:^{
            
        }];
        
//    });

}

- (void)receiveMessage:(Message *)message{
    
    
    if([self.responder respondsToSelector:@selector(receiveMessage:)])
    {
        [self.responder performSelectorOnMainThread:@selector(receiveMessage:) withObject:message waitUntilDone:NO];
    }
}



@end
