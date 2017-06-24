//
//  MessageCenter.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Message.h"
#import <Foundation/Foundation.h>

@interface MessageCenter : NSObject
+(instancetype)defaultCenter;

@property (nonatomic,strong)NSMutableDictionary *messagePool; //消息池；



- (void)sendMessage:(Message *)message;

- (void)sendSyncMessage:(Message *)message;

//将消息存到消息池
- (void)sendMessageToPool:(Message *)message;
@end
