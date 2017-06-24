//
//  Rack+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Rack+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Rack (CoreDataProperties)

+ (NSFetchRequest<Rack *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, retain) NSSet<BookRack *> *rookRack;

@end

@interface Rack (CoreDataGeneratedAccessors)

- (void)addRookRackObject:(BookRack *)value;
- (void)removeRookRackObject:(BookRack *)value;
- (void)addRookRack:(NSSet<BookRack *> *)values;
- (void)removeRookRack:(NSSet<BookRack *> *)values;

@end

NS_ASSUME_NONNULL_END
