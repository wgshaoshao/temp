//
//  ParkCatelogModel.m
//  Kuaikan
//
//  Created by CloudJson on 2017/3/17.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "ParkCatelogModel.h"

@implementation ParkCatelogModel
/// 使用WHC_Model库自动实现NSCoding协议

WHC_CodingImplementation


+ (NSString *)whc_SqliteVersion {
    return SQL_VERSION;
}

@end
