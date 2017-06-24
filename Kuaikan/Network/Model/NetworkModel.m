//
//  NetworkModel.m
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "NetworkModel.h"

@implementation NetworkModel
- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData
{
    Message *message = [[Message alloc] init];
    message.call = call;
    message.requestData = requestData;
    message.requestType = RequestTypePortal;
    message.responder = self;
    message.isEncrypt = YES;
    [self sendMessage:message];
}
//同步请求数据
- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData Snyc:(BOOL)sync
{
    Message *message = [[Message alloc] init];
    message.call = call;
    message.requestData = requestData;
    message.requestType = RequestTypePortal;
    message.responder = self;
    message.isEncrypt = YES;
    message.sync = sync;
    [self sendMessage:message];
}

- (void)receiveMessage:(Message *)message
{
    [self.responder performSelectorOnMainThread:@selector(receiveMessage:) withObject:message waitUntilDone:NO];
}
@end
