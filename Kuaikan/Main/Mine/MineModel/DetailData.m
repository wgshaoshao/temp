//
//  DetailData.m
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "DetailData.h"

@implementation DetailData

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
