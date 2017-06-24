//
//  ReadRecord+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ReadRecord+CoreDataProperties.h"

@implementation ReadRecord (CoreDataProperties)

+ (NSFetchRequest<ReadRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ReadRecord"];
}

@dynamic author;
@dynamic bookIcon;
@dynamic bookID;
@dynamic bookName;
@dynamic chapterID;
@dynamic chapterIndex;
@dynamic currentPageIndex;
@dynamic entityid;
@dynamic introduce;
@dynamic readTime;
@dynamic read;

@end
