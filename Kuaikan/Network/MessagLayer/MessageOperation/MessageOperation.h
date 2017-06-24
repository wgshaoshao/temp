//
//  MessageOperation.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Message.h"
#import <Foundation/Foundation.h>

@interface MessageOperation : NSOperation
@property (nonatomic,assign)BOOL responded;
@property (nonatomic,strong)Message *message;
- (instancetype)initWithMessage:(Message *)message;
@end
