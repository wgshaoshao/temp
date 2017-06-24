//
//  SearchRecord+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "SearchRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchRecord (CoreDataProperties)

+ (NSFetchRequest<SearchRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, retain) NSSet<Record *> *record;

@end

@interface SearchRecord (CoreDataGeneratedAccessors)

- (void)addRecordObject:(Record *)value;
- (void)removeRecordObject:(Record *)value;
- (void)addRecord:(NSSet<Record *> *)values;
- (void)removeRecord:(NSSet<Record *> *)values;

@end

NS_ASSUME_NONNULL_END
