//
//  ParkCatelogModel.h
//  Kuaikan
//
//  Created by CloudJson on 2017/3/17.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

@interface ParkCatelogModel : NSObject<NSCoding>

@property ( nonatomic, copy) NSString *entityid;
@property ( nonatomic, copy) NSString *bookid;
@property ( nonatomic, copy) NSString *tips;
@property ( nonatomic, copy) NSString *endId;
@property ( nonatomic, copy) NSString *startId;

+ (NSString *)whc_SqliteVersion;

@end
