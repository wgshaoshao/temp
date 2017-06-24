//
//  DetailData.h
//  Kuaikan
//
//  Created by 少少 on 16/4/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailData : NSObject

@property (nonatomic, copy) NSString *content;

+ (instancetype)friendWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
