//
//  Chapter+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Chapter+CoreDataProperties.h"

@implementation Chapter (CoreDataProperties)

+ (NSFetchRequest<Chapter *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Chapter"];
}

@dynamic bookid;
@dynamic catelogid;
@dynamic chapterPath;
@dynamic entityid;
@dynamic path;
@dynamic catelog;

@end
