//
//  ReadRecord+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ReadRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ReadRecord (CoreDataProperties)

+ (NSFetchRequest<ReadRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *bookIcon;
@property (nullable, nonatomic, copy) NSString *bookID;
@property (nullable, nonatomic, copy) NSString *bookName;
@property (nullable, nonatomic, copy) NSString *chapterID;
@property (nullable, nonatomic, copy) NSNumber *chapterIndex;
@property (nullable, nonatomic, copy) NSNumber *currentPageIndex;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSString *introduce;
@property (nullable, nonatomic, copy) NSString *readTime;
@property (nullable, nonatomic, retain) Read *read;

@end

NS_ASSUME_NONNULL_END
