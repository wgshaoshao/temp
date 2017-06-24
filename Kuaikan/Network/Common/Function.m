//
//  Function.m
//  Read
//
//  Created by ccp on 16/3/19.
//  Copyright © 2016年 com.read. All rights reserved.
//
#include <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#import "Function.h"
#import "Help.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Function


//公共上行参数
+(NSDictionary *)publicParam;
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    //屏幕分辨率
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *screen = [NSString stringWithFormat:@"%0.0f*%0.0f",rect.size.width*scale,rect.size.height*scale];
    [param setObject:screen forKey:@"screen"];
    
    //设备唯一标识
    NSString *uuid = [Function getDeviceId];
    [param setObject:uuid forKey:@"deviceId"];
    
    //appCode代表产品线
    [param setObject:@"i001" forKey:@"appCode"];
  
    //userId
    NSString *useID = [Function getUserId];
    [param setObject:useID forKey:@"userId"];
    
    //apiVersion
    NSString *apiVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [param setObject:apiVersion forKey:@"apiVersion"];
    
    //应用包表示
    NSString *appIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    [param setObject:appIdentifier forKey:@"pname"];
    
    //用户网络类型
    NSString *apn = [Function getNetWorkType];
    [param setObject:apn forKey:@"apn"];
    
    //客户端哈希值 client hash
    NSString *clientHash = @"YzBhNzBjYWE2MDFiNDM0NGQ2ODIyODg1Y2ViZmE1NWY=";
    [param setObject:clientHash forKey:@"clientHash"];
    
    //渠道号channelCode

    [param setObject:ChannelCode forKey:@"channelCode"];
    
    //系统版本
    NSString *os = [UIDevice currentDevice].systemName;
    os = [os stringByAppendingFormat:@" %@", [UIDevice currentDevice].systemVersion];
    [param setObject:os forKey:@"os"];
    
    //结算渠道号

    [param setObject:ChannelCode forKey:@"channelFee"];

    [param setObject:@"1" forKey:@"v"];
    // 机型
    NSString *model = [Function devicePlatform];
    [param setObject:model forKey:@"model"];
    
    //是否支持自有支付
    NSString *payment = @"2";
    [param setObject:payment forKey:@"dzPaySupport"];

    return param;
}


#pragma mark - 获取设备唯一标识
+ (NSString *)getDeviceId{
    //从钥匙串读取UUID：
    NSString *deviceUUID = [YFKeychainTool readKeychainValue:@"UUID"];
    
    if ([deviceUUID isEqualToString:@"(null)"] || deviceUUID == nil || [deviceUUID isEqualToString:@""]){
        
        NSUUID *currentDeviceUUID = [UIDevice currentDevice].identifierForVendor;
        deviceUUID = currentDeviceUUID.UUIDString;
        deviceUUID = [deviceUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        deviceUUID = [deviceUUID lowercaseString];
        [YFKeychainTool saveKeychainValue:deviceUUID key:BundleID];
    }
    
    return deviceUUID;

}

#pragma mark - 获取用户唯一ID
+ (NSString *)getUserId{
    
    //从钥匙串读取用户ID：
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    if (userID == nil) {
        userID = @"";
    }

    return userID;
}


+ (NSDictionary *)encryptParam:(NSString *)str
{
    NSMutableDictionary *encryptParams = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    //屏幕分辨率
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *screen = [NSString stringWithFormat:@"%0.0f*%0.0f",rect.size.width*scale,rect.size.height*scale];
    [param setObject:screen forKey:@"screen"];
    [encryptParams setObject:screen forKey:@"screen"];
  
    
    //应用名
    //    NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];
//    [param setObject:@"ishugui" forKey:@"appCode"];
//    [encryptParams setObject:@"ishugui" forKey:@"appCode"];
    
    //设备唯一标识
    NSString *uuid = [Function getDeviceId];
    [param setObject:uuid forKey:@"deviceId"];
    [encryptParams setObject:uuid forKey:@"deviceId"];

    
    //appCode代表产品线
    [param setObject:AppCode forKey:@"appCode"];
    [encryptParams setObject:AppCode forKey:@"appCode"];
 
    //userID
    NSString *useID = [Function getUserId];
    [param setObject:useID forKey:@"userId"];
    [encryptParams setObject:useID forKey:@"userId"];
    LRLog(@"useID----%@",useID);
    
    //apiVersion
    NSString *apiVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [param setObject:apiVersion forKey:@"apiVersion"];
    [encryptParams setObject:apiVersion forKey:@"apiVersion"];
    
    //应用包表示
    NSString *appIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    [param setObject:appIdentifier forKey:@"pname"];
    [encryptParams setObject:appIdentifier forKey:@"pname"];
    
    //用户网络类型
    NSString *apn = [Function getNetWorkType];
    [param setObject:apn forKey:@"apn"];
    [encryptParams setObject:apn forKey:@"apn"];
    //客户端哈希值 client hash
    NSString *clientHash = @"YzBhNzBjYWE2MDFiNDM0NGQ2ODIyODg1Y2ViZmE1NWY=";
    [param setObject:clientHash forKey:@"clientHash"];
    [encryptParams setObject:clientHash forKey:@"clientHash"];
    
    //渠道号channelCode
    [param setObject:ChannelCode forKey:@"channelCode"];
    [encryptParams setObject:ChannelCode forKey:@"channelCode"];
    
    //系统版本
    NSString *os = [UIDevice currentDevice].systemName;
    os = [os stringByAppendingFormat:@" %@", [UIDevice currentDevice].systemVersion];
    [param setObject:os forKey:@"os"];
    [encryptParams setObject:os forKey:@"os"];
    
    //结算渠道号
    [param setObject:ChannelFee forKey:@"channelFee"];
    [encryptParams setObject:ChannelFee forKey:@"channelFee"];
    
    [param setObject:@"" forKey:@"imsi"];
    [encryptParams setObject:@"" forKey:@"imsi"];
    
    [param setObject:@"" forKey:@"imei"];
    [encryptParams setObject:@"" forKey:@"imei"];

    [param setObject:@"1" forKey:@"v"];
    [encryptParams setObject:@"1" forKey:@"v"];
   
    //机型
    NSString *model = [Function devicePlatform];
    [param setObject:model forKey:@"model"];
    [encryptParams setObject:model forKey:@"model"];
    //是否支持自有支付
    NSString *payment = @"2";
    [param setObject:payment forKey:@"dzPaySupport"];
    [encryptParams setObject:payment forKey:@"dzPaySupport"];
    
    
    if (str.length) {
        NSString *signPub = [self getSign];
        
        NSString *sign = [NSString stringWithFormat:@"%@%@",signPub,str];
        if ([str hasPrefix:@"list"]) {
            NSString *listStr = [self stirngToArrayStr:str];
            sign = [NSString stringWithFormat:@"%@%@",signPub,listStr];
        }
        
//        LRLog(@"sign == %@",sign);
        [param setObject:[self md5:sign] forKey:@"sign"];
    } else {
    
        NSString *sign = [self encryptStringWithDictionay:encryptParams];
        [param setObject:sign forKey:@"sign"];
    }
    

    return param;
}

+ (NSString *)stirngToArrayStr:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"list" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"=" withString:@""];
    NSArray *tempArray = [str componentsSeparatedByString:@","];
    NSString *result = [NSString stringWithFormat:@"list=%@",[self objArrayToJSON:tempArray]];
    return result;
}

+ (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSMutableString *ids = [NSMutableString stringWithString:@"["];
    for (NSString *consulDoctor in array) {
        [ids appendFormat:@"\"%@\",",consulDoctor];
    }
    NSString *idStr = [NSString stringWithFormat:@"%@]",[ids substringWithRange:NSMakeRange(0, [ids length]-1)]];
    return idStr;
}

+ (NSString *)getSign{

    NSMutableDictionary *encryptParams = [[NSMutableDictionary alloc]init];
    //屏幕分辨率
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *screen = [NSString stringWithFormat:@"%0.0f*%0.0f",rect.size.width*scale,rect.size.height*scale];

    [encryptParams setObject:screen forKey:@"screen"];
    
    
    //应用名
    //    NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];

//    [encryptParams setObject:@"ishugui" forKey:@"appCode"];
    
    //设备唯一标识
    NSString *uuid = [Function getDeviceId];

    [encryptParams setObject:uuid forKey:@"deviceId"];
    
    
    //appCode代表产品线

    [encryptParams setObject:AppCode forKey:@"appCode"];
    
    //userID
    NSString *useID = [Function getUserId];

    [encryptParams setObject:useID forKey:@"userId"];
    
    //apiVersion
    NSString *apiVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];

    [encryptParams setObject:apiVersion forKey:@"apiVersion"];
    
    //应用包表示
    NSString *appIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    [encryptParams setObject:appIdentifier forKey:@"pname"];
    
    //用户网络类型
    NSString *apn = [Function getNetWorkType];
    [encryptParams setObject:apn forKey:@"apn"];
    //客户端哈希值 client hash
    NSString *clientHash = @"YzBhNzBjYWE2MDFiNDM0NGQ2ODIyODg1Y2ViZmE1NWY=";
    [encryptParams setObject:clientHash forKey:@"clientHash"];
    
    //渠道号channelCode
    [encryptParams setObject:ChannelCode forKey:@"channelCode"];
    
    //系统版本
    NSString *os = [UIDevice currentDevice].systemName;
    os = [os stringByAppendingFormat:@" %@", [UIDevice currentDevice].systemVersion];
    [encryptParams setObject:os forKey:@"os"];
    
    //结算渠道号
    [encryptParams setObject:ChannelFee forKey:@"channelFee"];
    [encryptParams setObject:@"" forKey:@"imsi"];
    
    [encryptParams setObject:@"" forKey:@"imei"];
    
    [encryptParams setObject:@"1" forKey:@"v"];
    
    //机型
    NSString *model = [Function devicePlatform];
    [encryptParams setObject:model forKey:@"model"];
    //是否支持自有支付
    NSString *payment = @"2";
    [encryptParams setObject:payment forKey:@"dzPaySupport"];
    
    NSString *sign = [self encryptStringWithDictionay:encryptParams];
    
    
    return sign;
}

+ (NSString *)getNetWorkType
{
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0
        )
    {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
    return strNetworkType;
}


+(NSString *)devicePlatform {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6SPlus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air ";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+(NSString *)priWithDictionay:(NSDictionary *)dictionary
{
    NSArray *keyArray = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2 options:NSLiteralSearch];
    }];
    NSString *result = nil;
    for(NSString *key in keyArray)
    {
        if(result==nil)
        {
            result = [NSString stringWithFormat:@"%@=%@",key,[dictionary objectForKey:key]];
        }else
        {
            result = [NSString stringWithFormat:@"%@&%@=%@",result,key,[dictionary objectForKey:key]];
        }
    }

    return  result;
}

+(NSString *)encryptStringWithDictionay:(NSDictionary *)dictionary
{
    NSArray *keyArray = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = obj1;
        NSString *string2 = obj2;
        return [string1 compare:string2 options:NSLiteralSearch];
    }];
    NSString *result = nil;
    for(NSString *key in keyArray)
    {
        if(result==nil)
        {
            result = [NSString stringWithFormat:@"%@=%@",key,[dictionary objectForKey:key]];
        }else
        {
            result = [NSString stringWithFormat:@"%@&%@=%@",result,key,[dictionary objectForKey:key]];
        }
    }

    result = [NSString stringWithFormat:@"%@&key=%@",result,@"ddbc9169242b479da867eb24efb735d1"];
    return  [self md5:result];
}

+ (NSString *)md5:(NSString *)src
{
    if (src && src.length > 0) {
        const char *cStr = [src UTF8String];
        unsigned char result[16];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    return nil;
}
@end
