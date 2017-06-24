//
//  MessageProcess.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Message.h"
#import <Foundation/Foundation.h>


@protocol MessageProcessDelegate <NSObject>
@optional
- (void)receiveMessageWithRequestType:(RequestType)requestType resultCode:(NSInteger)resultCode call:(NSInteger)call responseObject:(id)responseObject;
@end

@interface MessageProcess : NSObject
+(instancetype)instance;
@property (nonatomic,weak)id<MessageProcessDelegate>delegate;
//发送消息
- (void)sendMessage:(Message *)messsage;

//发送同步消息
- (void)sendSyncMessage:(Message *)message;

//向协议层发送消息
- (void)sendMessageToProtocol:(Message *)message;
//向Model层发送消息
- (void)sendMessageToModelLayer:(Message *)message;
@end
