//
//  ParkCatalog+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ParkCatalog+CoreDataProperties.h"

@implementation ParkCatalog (CoreDataProperties)

+ (NSFetchRequest<ParkCatalog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ParkCatalog"];
}

@dynamic bookid;
@dynamic endId;
@dynamic entityid;
@dynamic startId;
@dynamic tips;
@dynamic book;

@end
