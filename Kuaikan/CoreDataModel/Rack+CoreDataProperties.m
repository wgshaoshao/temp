//
//  Rack+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Rack+CoreDataProperties.h"

@implementation Rack (CoreDataProperties)

+ (NSFetchRequest<Rack *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Rack"];
}

@dynamic entityid;
@dynamic rookRack;

@end
