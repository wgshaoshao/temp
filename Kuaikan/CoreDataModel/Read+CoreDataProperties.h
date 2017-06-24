//
//  Read+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Read+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Read (CoreDataProperties)

+ (NSFetchRequest<Read *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, retain) NSSet<ReadRecord *> *readRecord;

@end

@interface Read (CoreDataGeneratedAccessors)

- (void)addReadRecordObject:(ReadRecord *)value;
- (void)removeReadRecordObject:(ReadRecord *)value;
- (void)addReadRecord:(NSSet<ReadRecord *> *)values;
- (void)removeReadRecord:(NSSet<ReadRecord *> *)values;

@end

NS_ASSUME_NONNULL_END
