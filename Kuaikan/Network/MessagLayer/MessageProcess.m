//
//  MessageProcess.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Model.h"
#import "InterfaceManagement.h"
#import "MessageCenter.h"
#import "MessageProcess.h"

@interface MessageProcess ()<InterfaceManagementDelegate>

@end

@implementation MessageProcess
+(instancetype)instance
{
    static MessageProcess *process = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
         process = [[self alloc]init];
    });
    return process;
}

//发送消息
- (void)sendMessage:(Message *)messsage
{
    [[MessageCenter defaultCenter] sendMessage:messsage];
}


//发送同步消息
- (void)sendSyncMessage:(Message *)message
{
    [[MessageCenter defaultCenter] sendSyncMessage:message];
}

//向Model层发送消息
- (void)sendMessageToModelLayer:(Message *)message
{
    Model *model = message.responder;
    if ([model isKindOfClass:[Model class]]) {
        [model receiveMessage:message];
    } else if ([model respondsToSelector:@selector(receiveMessage:)]) {
        [model performSelector:@selector(receiveMessage:) withObject:message];
    }
}

//向协议层发送消息
- (void)sendMessageToProtocol:(Message *)message
{
    [[InterfaceManagement getInstance]setDelegate:self];
    [[InterfaceManagement getInstance] sendRequestType:message.netWorkType subType:message.requestType call:message.call andData:message.requestData encrypt:message.isEncrypt];
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
