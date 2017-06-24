//
//  BaseMessage.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMessage : NSObject

@property (nonatomic,strong)id responder;    // Message的唯一标识

@property (nonatomic,assign)BOOL succeed;    // 是否成功

@property (nonatomic,assign)BOOL sync;       // 是否同步

@property (nonatomic,assign)NSInteger call;  // 调用call参数
@end
