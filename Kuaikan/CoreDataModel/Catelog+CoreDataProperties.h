//
//  Catelog+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Catelog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Catelog (CoreDataProperties)

+ (NSFetchRequest<Catelog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bookid;
@property (nullable, nonatomic, copy) NSString *catelogfrom;
@property (nullable, nonatomic, copy) NSString *catelogid;
@property (nullable, nonatomic, copy) NSString *catelogname;
@property (nullable, nonatomic, copy) NSString *cmBookAttribute;
@property (nullable, nonatomic, copy) NSString *cmConsumePrice;
@property (nullable, nonatomic, copy) NSString *cmIsVip;
@property (nullable, nonatomic, copy) NSString *cmMarketPrice;
@property (nullable, nonatomic, copy) NSString *cmOrderRelationShip;
@property (nullable, nonatomic, copy) NSNumber *currentPos;
@property (nullable, nonatomic, copy) NSString *dlTime;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSString *errType;
@property (nullable, nonatomic, copy) NSString *isalreadypay;
@property (nullable, nonatomic, copy) NSString *isdownload;
@property (nullable, nonatomic, copy) NSString *isNewPayUrl;
@property (nullable, nonatomic, copy) NSString *ispay;
@property (nullable, nonatomic, copy) NSString *ispayupload;
@property (nullable, nonatomic, copy) NSString *isread;
@property (nullable, nonatomic, copy) NSString *isupload;
@property (nullable, nonatomic, copy) NSString *newUrl;
@property (nullable, nonatomic, copy) NSString *next;
@property (nullable, nonatomic, copy) NSString *nextPayUrl;
@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, copy) NSString *payTime;
@property (nullable, nonatomic, copy) NSString *payUrl;
@property (nullable, nonatomic, copy) NSString *preIsdownload;
@property (nullable, nonatomic, copy) NSString *prePayUrl;
@property (nullable, nonatomic, copy) NSString *previous;
@property (nullable, nonatomic, retain) Book *book;
@property (nullable, nonatomic, retain) Chapter *chapter;

@end

NS_ASSUME_NONNULL_END
