//
//  BaseMessage.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//

#import "BaseMessage.h"

@implementation BaseMessage
- (instancetype)initWithResponder:(id)responder
{
    self = [super init];
    if(self)
    {
        self.responder = responder;
    }
    return self;
}
@end
