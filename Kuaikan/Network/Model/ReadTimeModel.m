//
//  ReadTimeModel.m
//  Kuaikan
//
//  Created by 少少 on 16/5/5.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ReadTimeModel.h"


@implementation ReadTimeModel


//更新阅读时间（书架时间排序）
//- (void)insertReadTime:(NSDictionary *)requestData andUpdate:(BOOL)updateChapter{
//    
//    
//    
////    dispatch_queue_t queue = dispatch_queue_create("readRecord", DISPATCH_QUEUE_CONCURRENT);
////    dispatch_barrier_async(queue, ^{
//        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
//        
//        Rack *rack = [dataManager asyncFetchEntitysWithName:@"Rack" entityId:RackOnlyID];
//        if(rack == nil)
//        {
//            rack = [dataManager asyncInsertEntityWithName:@"Rack"];
//            rack.entityid = RackOnlyID;
//        }
//        
//        NSString *bookId = requestData[@"bookID"];
//        BookRack *bookRack = [dataManager asyncFetchEntitysWithName:@"BookRack" entityId:bookId];
//        if(bookRack == nil)
//        {
//            bookRack = [dataManager asyncInsertEntityWithName:@"BookRack"];
//            
//            bookRack.entityid = bookId;
//        }
//        
//        if (!updateChapter) {
//            bookRack.updateChapter = requestData[@"updateChapter"];
//        }
//        
//        
//        bookRack.rack = rack;
//        bookRack.entityid = bookId;
//        bookRack.dateTime = requestData[@"dateTime"];    
//        [dataManager asyncSave];
//        
////    });
//}

@end
