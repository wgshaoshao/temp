//
//  ParkCatalog+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ParkCatalog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ParkCatalog (CoreDataProperties)

+ (NSFetchRequest<ParkCatalog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bookid;
@property (nullable, nonatomic, copy) NSString *endId;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSString *startId;
@property (nullable, nonatomic, copy) NSString *tips;
@property (nullable, nonatomic, retain) Book *book;

@end

NS_ASSUME_NONNULL_END
