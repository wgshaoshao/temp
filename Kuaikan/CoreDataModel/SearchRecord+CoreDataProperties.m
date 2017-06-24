//
//  SearchRecord+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "SearchRecord+CoreDataProperties.h"

@implementation SearchRecord (CoreDataProperties)

+ (NSFetchRequest<SearchRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SearchRecord"];
}

@dynamic entityid;
@dynamic record;

@end
