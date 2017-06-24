//
//  SearchMomentModel.m
//  Kuaikan
//
//  Created by 少少 on 16/4/15.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SearchMomentModel.h"

@implementation SearchMomentModel
- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData
{
    Message *message = [[Message alloc]init];
    message.call = call;
    message.requestData = requestData;
    message.requestType = RequestTypePortal;
    message.responder = self;
    [self sendMessage:message];
    
}

- (void)receiveMessage:(Message *)message
{
    [self.responder performSelectorOnMainThread:@selector(receiveMessage:) withObject:message waitUntilDone:NO];
}
@end
