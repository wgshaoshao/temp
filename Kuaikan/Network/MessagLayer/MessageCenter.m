//
//  MessageCenter.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "MessageProcess.h"
#import "MessageOperation.h"
#import "MessageCenter.h"


@interface MessageCenter ()<MessageProcessDelegate>
@property (nonatomic, strong) NSOperationQueue   *messageSendQueue;               // 消息发送队列
@property (nonatomic, strong) NSOperationQueue   *messageReceiveQueue;            // 消息接收队列
@end

@implementation MessageCenter
+(instancetype)defaultCenter
{
    static MessageCenter *messageCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter = [[self alloc]init];
    });
    return messageCenter;
}


#pragma - mark 初始化方法
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [[MessageProcess instance] setDelegate:self];
        _messagePool = [[NSMutableDictionary alloc]init];
        self.messageSendQueue = [[NSOperationQueue alloc]init];
        self.messageSendQueue.maxConcurrentOperationCount = 3;
        
        self.messageReceiveQueue = [[NSOperationQueue alloc]init];
        self.messageReceiveQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}


- (void)sendMessage:(Message *)message
{
    [self sendMessageToPool:message];
    MessageOperation *operation = [[MessageOperation alloc]initWithMessage:message];
    operation.responded = NO;
    [self.messageSendQueue addOperation:operation];
}

- (void)sendSyncMessage:(Message *)message
{
    [self sendMessage:message];
    
    while (!message.responded) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}


// 收到消息
- (void)receiveMessageWithRequestType:(RequestType)requestType resultCode:(NSInteger)resultCode call:(NSInteger)call responseObject:(id)responseObject
{
    int type = requestType;
    Message *message =  [_messagePool objectForKey:[NSString stringWithFormat:@"%d",(int)call]];;
    message.call = call;
    message.responseType = type;
    message.responseData = responseObject;
    message.resultCode = resultCode;
    message.responded = YES;
    if(message!=nil)
    {
       [self receiveMessage:message];
        [self.messagePool removeObjectForKey:[NSString stringWithFormat:@"%d",(int)call]];
    }
    
}


//收到消息赚到至model层
- (void)receiveMessage:(Message *)message
{
    if (![message isKindOfClass:[Message class]]) {
        return;
    }
    
    MessageOperation *operation = [[MessageOperation alloc] initWithMessage:message];
    operation.responded = YES;
    [self.messageReceiveQueue addOperation:operation];
}


//消息存放倒消息池
- (void)sendMessageToPool:(Message *)message
{
    [_messagePool setObject:message forKey:[NSString stringWithFormat:@"%d",(int)message.call]];
}
@end
