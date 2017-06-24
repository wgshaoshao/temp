//
//  Message.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//

#import "BaseMessage.h"

@interface Message : BaseMessage

@property (nonatomic,assign)NetworkType        netWorkType;      //借口类型
@property (nonatomic,assign)RequestType        requestType;      //请求类型

@property (nonatomic,strong)NSMutableDictionary *requestData;    //请求参数

@property (nonatomic,assign)NSInteger          resultCode;       //返回码

@property (nonatomic,assign)ResponseType       responseType;     //返回类型


@property (nonatomic,strong)id  responseData;  //返回数据

@property (nonatomic,assign)BOOL responded; //请求是否返回

@property (nonatomic,assign)BOOL isEncrypt;
@end
