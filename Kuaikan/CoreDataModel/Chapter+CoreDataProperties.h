//
//  Chapter+CoreDataProperties.h
//  Kuaikan
//
//  Created by CloudJson on 2017/4/5.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "Chapter+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Chapter (CoreDataProperties)

+ (NSFetchRequest<Chapter *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bookid;
@property (nullable, nonatomic, copy) NSString *catelogid;
@property (nullable, nonatomic, copy) NSString *chapterPath;
@property (nullable, nonatomic, copy) NSString *entityid;
@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, retain) Catelog *catelog;

@end

NS_ASSUME_NONNULL_END
