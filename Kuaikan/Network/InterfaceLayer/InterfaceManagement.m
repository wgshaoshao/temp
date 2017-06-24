//
//  InterfaceManagement.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "CentralManagement.h"
#import "InterfaceManagement.h"

@interface InterfaceManagement ()<CentralManagementDelegate>

@end
@implementation InterfaceManagement
+(instancetype)getInstance
{
    static InterfaceManagement *management = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        management = [[self alloc]init];
    });
    return management;
}

//发送消息
- (void)sendRequestType:(NetworkType)networkType subType:(RequestType)requestType call:(NSInteger)call andData:(NSDictionary *)dictionary encrypt:(BOOL)encrypt
{
    [[CentralManagement centralManagement] setDelegate:self];
    [[CentralManagement centralManagement] sendRequestType:networkType subType:requestType call:call andData:dictionary encrypt:encrypt];
}


//收到消息
- (void)receiveMessageWithRequestType:(RequestType)requestType resultCode:(NSInteger)resultCode call:(NSInteger)call responseObject:(id)responseObject
{
    if([self.delegate respondsToSelector:@selector(receiveMessageWithRequestType:resultCode:call:responseObject:)])
    {
        [self.delegate receiveMessageWithRequestType:requestType resultCode:resultCode call:call responseObject:responseObject];
    }
}
@end
