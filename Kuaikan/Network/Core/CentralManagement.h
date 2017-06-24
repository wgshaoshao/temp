//
//  CentralManagement.h
//  Read
//
//  Created by ccp on 16/3/18.
//  Copyright © 2016年 com.read. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CentralManagementDelegate <NSObject>
@optional
- (void)receiveMessageWithRequestType:(RequestType)requestType resultCode:(NSInteger)resultCode call:(NSInteger)call responseObject:(id)responseObject;
@end

@interface CentralManagement : NSObject

@property (nonatomic,weak)id<CentralManagementDelegate>delegate;
+(instancetype)centralManagement;
- (void)sendRequestType:(NetworkType)networkType subType:(RequestType)requestType call:(NSInteger)call andData:(NSDictionary *)dictionary encrypt:(BOOL)encrypt;
@end
