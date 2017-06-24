//
//  Function.h
//  Read
//
//  Created by ccp on 16/3/19.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Logic.h"
#import <Foundation/Foundation.h>

@interface Function : NSObject
+(NSDictionary *)publicParam;
+(NSDictionary *)encryptParam:(NSString *)str;
+ (NSString *)getNetWorkType;
+(NSString *)devicePlatform;
+ (NSString *)getUserId;
+ (NSString *)getDeviceId;
+(NSString *)encryptStringWithDictionay:(NSDictionary *)dictionary;
+(NSString *)priWithDictionay:(NSDictionary *)dictionary;
+ (NSString *)md5:(NSString *)src;
@end
