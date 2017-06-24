//
//  CentralManagement.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Function.h"
#import "HTTPProcess.h"
#import "CentralManagement.h"

@interface CentralManagement ()<HTTPProcessDelegate>

@end

@implementation CentralManagement
+(instancetype)centralManagement
{
    static CentralManagement *centralManagement;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        centralManagement = [[self alloc]init];
    });
    return centralManagement;
}

//  发送请求
- (void)sendRequestType:(NetworkType)networkType subType:(RequestType)requestType call:(NSInteger)call andData:(NSDictionary *)dictionary encrypt:(BOOL)encryp
{
 
    NSString *fullURL = nil;
//    if (call == 137) {
//        fullURL = [NSString stringWithFormat:@"%@%@?",SITE_URL137,subURl];
//    } else {
        fullURL = [NSString stringWithFormat:@"%@/asg/portal.do?",SITE_URL];
//    }

    [[HTTPProcess httpProcess] setDelegate:self];
    [[HTTPProcess httpProcess] sendPostHTTPWithURLString:fullURL call:call andData:dictionary requestType:requestType encrypt:encryp];
}


//  收到请求
- (void)requestFinished:(NSDictionary *)dictionary
{
    NSInteger resultCode = [dictionary integerForKey:@"status"];
    RequestType requestType = [dictionary intForKey:@"requestType"];
    NSInteger call = [dictionary integerForKey:@"call"];
    if(resultCode==0)
    {
        id responseDic = [dictionary objectForKey:@"pri"];
        if([self.delegate respondsToSelector:@selector(receiveMessageWithRequestType:resultCode:call:responseObject:)])
        {
            [self.delegate receiveMessageWithRequestType:requestType resultCode:resultCode call:call responseObject:responseDic];
        }
        
    } else {
        if([self.delegate respondsToSelector:@selector(receiveMessageWithRequestType:resultCode:call:responseObject:)])
        {
            [self.delegate receiveMessageWithRequestType:requestType resultCode:resultCode call:call responseObject:nil];
        }
    }
}
@end
