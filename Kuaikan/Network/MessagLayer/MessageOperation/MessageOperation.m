//
//  MessageOperation.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "MessageProcess.h"
#import "MessageOperation.h"

@implementation MessageOperation
- (instancetype)initWithMessage:(Message *)message
{
    self = [super init];
    if(self)
    {
        self.message = message;
    }
    return self;
}

- (void)main
{
    if(!self.responded)
    {
        [[MessageProcess instance] sendMessageToProtocol:self.message];
    }else
    {
        [[MessageProcess instance] sendMessageToModelLayer:self.message];
    }
}

- (BOOL)isConcurrent
{
    return YES;
}
@end
