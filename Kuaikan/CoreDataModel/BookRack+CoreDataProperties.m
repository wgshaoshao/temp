//
//  BookRack+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "BookRack+CoreDataProperties.h"

@implementation BookRack (CoreDataProperties)

+ (NSFetchRequest<BookRack *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BookRack"];
}

@dynamic author;
@dynamic bookName;
@dynamic chapterId;
@dynamic coverImage;
@dynamic dateTime;
@dynamic entityid;
@dynamic introuce;
@dynamic isUpate;
@dynamic updateChapter;
@dynamic wifiBook;
@dynamic rack;

@end
