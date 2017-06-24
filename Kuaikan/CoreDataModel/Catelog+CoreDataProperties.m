//
//  Catelog+CoreDataProperties.m
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Catelog+CoreDataProperties.h"

@implementation Catelog (CoreDataProperties)

+ (NSFetchRequest<Catelog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Catelog"];
}

@dynamic bookid;
@dynamic catelogfrom;
@dynamic catelogid;
@dynamic catelogname;
@dynamic cmBookAttribute;
@dynamic cmConsumePrice;
@dynamic cmIsVip;
@dynamic cmMarketPrice;
@dynamic cmOrderRelationShip;
@dynamic currentPos;
@dynamic dlTime;
@dynamic entityid;
@dynamic errType;
@dynamic isalreadypay;
@dynamic isdownload;
@dynamic isNewPayUrl;
@dynamic ispay;
@dynamic ispayupload;
@dynamic isread;
@dynamic isupload;
@dynamic newUrl;
@dynamic next;
@dynamic nextPayUrl;
@dynamic path;
@dynamic payTime;
@dynamic payUrl;
@dynamic preIsdownload;
@dynamic prePayUrl;
@dynamic previous;
@dynamic book;
@dynamic chapter;

@end
