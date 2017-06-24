//
//  Model.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Message.h"
#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic,weak)id responder;

- (instancetype)initWithResponder:(id)responder;
- (void)sendMessage:(Message *)message;
- (void)receiveMessage:(Message *)message;
@end
