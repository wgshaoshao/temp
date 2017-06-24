//
//  Book+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Book+CoreDataProperties.h"

@implementation Book (CoreDataProperties)

+ (NSFetchRequest<Book *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Book"];
}

@dynamic author;
@dynamic bookfrom;
@dynamic bookid;
@dynamic bookname;
@dynamic bookstatus;
@dynamic confirmStatus;
@dynamic coverurl;
@dynamic currentCatelogId;
@dynamic entityid;
@dynamic format;
@dynamic hasRead;
@dynamic isAddBook;
@dynamic isdefautbook;
@dynamic isEnd;
@dynamic isparkCatalog;
@dynamic isUpdate;
@dynamic marketId;
@dynamic marketStatus;
@dynamic payRemind;
@dynamic payStatus;
@dynamic payWay;
@dynamic price;
@dynamic sourceFrom;
@dynamic time;
@dynamic catelog;
@dynamic parkCatalog;

@end
