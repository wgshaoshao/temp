//
//  Read+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Read+CoreDataProperties.h"

@implementation Read (CoreDataProperties)

+ (NSFetchRequest<Read *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Read"];
}

@dynamic entityid;
@dynamic readRecord;

@end
