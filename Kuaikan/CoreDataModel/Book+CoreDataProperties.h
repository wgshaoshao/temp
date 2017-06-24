//
//  Book+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Book+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

+ (NSFetchRequest<Book *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSNumber *bookfrom;
@property (nullable, nonatomic, copy) NSString *bookid;
@property (nullable, nonatomic, copy) NSString *bookname;
@property (nullable, nonatomic, copy) NSNumber *bookstatus;
@property (nullable, nonatomic, copy) NSNumber *confirmStatus;
@property (nullable, nonatomic, copy) NSString *coverurl;
@property (nullable, nonatomic, copy) NSString *currentCatelogId;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSNumber *format;
@property (nullable, nonatomic, copy) NSNumber *hasRead;
@property (nullable, nonatomic, copy) NSNumber *isAddBook;
@property (nullable, nonatomic, copy) NSNumber *isdefautbook;
@property (nullable, nonatomic, copy) NSNumber *isEnd;
@property (nullable, nonatomic, copy) NSNumber *isparkCatalog;
@property (nullable, nonatomic, copy) NSNumber *isUpdate;
@property (nullable, nonatomic, copy) NSString *marketId;
@property (nullable, nonatomic, copy) NSNumber *marketStatus;
@property (nullable, nonatomic, copy) NSNumber *payRemind;
@property (nullable, nonatomic, copy) NSNumber *payStatus;
@property (nullable, nonatomic, copy) NSNumber *payWay;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSString *sourceFrom;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, retain) NSSet<Catelog *> *catelog;
@property (nullable, nonatomic, retain) NSSet<ParkCatalog *> *parkCatalog;

@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addCatelogObject:(Catelog *)value;
- (void)removeCatelogObject:(Catelog *)value;
- (void)addCatelog:(NSSet<Catelog *> *)values;
- (void)removeCatelog:(NSSet<Catelog *> *)values;

- (void)addParkCatalogObject:(ParkCatalog *)value;
- (void)removeParkCatalogObject:(ParkCatalog *)value;
- (void)addParkCatalog:(NSSet<ParkCatalog *> *)values;
- (void)removeParkCatalog:(NSSet<ParkCatalog *> *)values;

@end

NS_ASSUME_NONNULL_END
