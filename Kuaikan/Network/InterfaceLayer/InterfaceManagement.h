//
//  InterfaceManagement.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Logic.h"
#import <Foundation/Foundation.h>


@protocol InterfaceManagementDelegate <NSObject>
@optional
- (void)receiveMessageWithRequestType:(RequestType)requestType resultCode:(NSInteger)resultCode call:(NSInteger)call responseObject:(id)responseObject;
@end

@interface InterfaceManagement : NSObject
@property (nonatomic,weak)id<InterfaceManagementDelegate>delegate;
+(instancetype)getInstance;
- (void)sendRequestType:(NetworkType)networkType subType:(RequestType)requestType call:(NSInteger)call andData:(NSDictionary *)dictionary encrypt:(BOOL)encrypt;
@end
