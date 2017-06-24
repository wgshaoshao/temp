//
//  HTTPProcess.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "JSONAdapter.h"
#import <Foundation/Foundation.h>

@protocol HTTPProcessDelegate <NSObject>
@optional
- (void)requestFinished:(NSDictionary *)dictionary;
@end


@interface HTTPProcess : NSObject

+ (instancetype)httpProcess;

@property (nonatomic,weak)id<HTTPProcessDelegate>delegate;
- (void)sendPostHTTPWithURLString:(NSString *)urlString call:(NSInteger)call andData:(NSDictionary *)dictionary requestType:(RequestType)requestType encrypt:(BOOL)encrypt;
@end
