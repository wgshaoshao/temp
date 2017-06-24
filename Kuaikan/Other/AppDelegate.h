//
//  AppDelegate.h
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabBarController.h"
#import "Reachability.h"
#import "WeiboSDK.h"

@protocol WXDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;

@end

@protocol WeiBoDelegate <NSObject>

//登录的代理
- (void)weiboLoginByResponse:(WBBaseResponse *)response;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *nightView;
@property (strong, nonatomic) Reachability *reach;  
@property (nonatomic, strong) RootTabBarController *mainTabBarController;
@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (nonatomic, weak) id<WXDelegate> wxDelegate;
@property (weak  , nonatomic) id<WeiBoDelegate> weiboDelegate;

+ (AppDelegate *)sharedApplicationDelegate;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (NSDictionary *)mypublicParam;

@end

