//
//  Model.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "MessageProcess.h"
#import "Model.h"

@implementation Model
- (instancetype)initWithResponder:(id)responder
{
    self  = [super init];
    if(self)
    {
        self.responder = responder;
    }
    return self;
}


- (void)sendMessage:(Message *)message
{
    if(!message.responder)
    {
        message.responder = self;
    }
    if(message.sync)
    {
        [[MessageProcess instance] sendSyncMessage:message];
    }else
    {
        [[MessageProcess instance] sendMessage:message];
    }
}

// 收到消息
- (void)receiveMessage:(Message *)message
{
    
}
@end
