//
//  HTTPProcess.m
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//
#import "Function.h"
#import "HTTPProcess.h"
#import "AFNetworking.h"

@interface HTTPProcess ()<NSURLSessionDelegate,NSURLSessionDataDelegate>
@property (nonatomic,strong)NSURLSession *session;
@property (nonatomic,strong)NSMutableDictionary *dictionary;
@end

@implementation HTTPProcess
+ (instancetype)httpProcess
{
    static HTTPProcess *process;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        process = [[self alloc]init];
    });
    
    return process;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        self.dictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}


- (void)sendPostHTTPWithURLString:(NSString *)urlString call:(NSInteger)call andData:(NSDictionary *)dictionary requestType:(RequestType)requestType encrypt:(BOOL)encrypt
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableDictionary *jsonDiction = [[NSMutableDictionary alloc]init];
    
    //获得私有参数排序过后的

    if(encrypt)
    {
        if (call > 210) {
            [jsonDiction setObject:[Function encryptParam:[Function priWithDictionay:dictionary]] forKey:@"pub"];
        } else {
            [jsonDiction setObject:[Function encryptParam:@""] forKey:@"pub"];
        }
        
    }else{
        [jsonDiction setObject:[Function publicParam] forKey:@"pub"];
    }
    [jsonDiction setObject:dictionary forKey:@"pri"];

    NSString *jsonString = [jsonDiction jsonString];
    LRLog(@"%@%@",urlString,[NSString stringWithFormat:@"json=%@&call=%d",jsonString,call]);
    
    NSString *param = [NSString stringWithFormat:@"json=%@&call=%d",(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)jsonString, NULL, CFSTR(":/?#[]@!$&'()*+,;%="), kCFStringEncodingUTF8),call];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
 
    request.timeoutInterval = 30;
    
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    dataTask.taskDescription = [NSString stringWithFormat:@"%d",call];
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSMutableData *recieveData = [self.dictionary objectForKey:dataTask.taskDescription];
    if(recieveData==nil)
    {
        [self.dictionary setObject:[[NSMutableData alloc] init] forKey:dataTask.taskDescription];
    }
    NSMutableData *tempData = [self.dictionary objectForKey:dataTask.taskDescription];
    [tempData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if(error)
    {
       [self processError:error.code withCall:[[task taskDescription] integerValue]];

        
        //用户网络类型
        NSString *apn = [Function getNetWorkType];
        //友盟统计网络请求出错
        if (!apn.length) {
            apn = @"";
        }
        NSDictionary *dict = @{@"error" : error.localizedDescription,@"URL" : [task taskDescription],@"APN" : apn};
  
        
        [MobClick event:@"NetworkError" attributes:dict];
    } else {
        NSMutableData *recieveData = [self.dictionary objectForKey:task.taskDescription];
        NSDictionary *dic = [recieveData jsonValue];
        if(dic != nil)
        {
            [self processDictionary:dic withCall:[[task  taskDescription] integerValue]];
        } else {
        
        }
        
    }
   [self.dictionary removeObjectForKey:task.taskDescription];
}

#pragma - mark 请求成功
- (void)processDictionary:(NSDictionary *)dictionary withCall:(NSInteger)call
{
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc]init];
    [responseDictionary setObject:@(call) forKey:@"call"];
    NSInteger resultCode = [[dictionary dictionaryForKey:@"pub"] integerForKey:@"status"];
    if(resultCode == 0)
    {
        [responseDictionary setObject:[dictionary objectForKey:@"pri"] forKey:@"pri"];
    }
    [responseDictionary setObject:@(resultCode) forKey:@"status"];
    if([self.delegate respondsToSelector:@selector(requestFinished:)])
    {
        [self.delegate requestFinished:responseDictionary];
    }
}

#pragma - mark 失败
- (void)processError:(NSInteger)errorCode withCall:(NSInteger)call
{
    
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc]init];
    [responseDictionary setObject:@(call) forKey:@"call"];
    [responseDictionary setObject:@(errorCode) forKey:@"status"];
    if([self.delegate respondsToSelector:@selector(requestFinished:)])
    {
        [self.delegate requestFinished:responseDictionary];
    }
}

@end
