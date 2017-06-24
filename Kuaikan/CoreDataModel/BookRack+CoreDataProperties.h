//
//  BookRack+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "BookRack+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BookRack (CoreDataProperties)

+ (NSFetchRequest<BookRack *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *bookName;
@property (nullable, nonatomic, copy) NSString *chapterId;
@property (nullable, nonatomic, copy) NSString *coverImage;
@property (nullable, nonatomic, copy) NSString *dateTime;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSString *introuce;
@property (nullable, nonatomic, copy) NSNumber *isUpate;
@property (nullable, nonatomic, copy) NSString *updateChapter;
@property (nullable, nonatomic, copy) NSString *wifiBook;
@property (nullable, nonatomic, retain) Rack *rack;

@end

NS_ASSUME_NONNULL_END
