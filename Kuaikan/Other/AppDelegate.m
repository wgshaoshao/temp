//
//  AppDelegate.m
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BookCityHomeController.h"
#import "BookRackHomeController.h"
#import "MineHomeController.h"
#import "WheelPictureController.h"
#import "Help.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "BaseNavgationViewController.h"
#import "Function.h"
#import "ReYunTrack.h"
#import <CommonCrypto/CommonCrypto.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "ReadRecord+CoreDataClass.h"

@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>

@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) NetworkModel *loadingModel;
@property (nonatomic, strong) NetworkModel *channelModel;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, assign) BOOL isDataManager;


@end

@implementation AppDelegate

+ (AppDelegate *)sharedApplicationDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)umengTrack {
    
    [MobClick setLogEnabled:NO];
    UMConfigInstance.appKey = YMAppKey;
    UMConfigInstance.channelId = ChannelCode;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setCrashReportEnabled:YES];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];

}

- (void)commentCount{

    NSInteger commentCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"commentCount"] integerValue];
    
    NSString *versionNew = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionNative = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionString"];
    
    if ([versionNew compare:versionNative] == 1) {//有更新或者卸载
        
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"commentCount"];
        [[NSUserDefaults standardUserDefaults] setObject:versionNew forKey:@"versionString"];
    }
    if (commentCount < 4) {
        commentCount = commentCount + 1;
        [[NSUserDefaults standardUserDefaults] setObject:@(commentCount) forKey:@"commentCount"];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //本地控制投诉开关的弹出
    [self commentCount];
    BOOL isBuiltBook = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isBuiltBook"] boolValue];
    NSString *appIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];

    NSString *changeDBBase = [YFKeychainTool readKeychainValue:[NSString stringWithFormat:@"changeDBBase%@",appIdentifier]];
    //[YFKeychainTool saveKeychainValue:@"NO" key:[NSString stringWithFormat:@"changeDBBase%@",appIdentifier]];

    if (isBuiltBook && ![changeDBBase isEqualToString:@"YES"]) {
        [self changeDBBase];
        [YFKeychainTool saveKeychainValue:@"YES" key:[NSString stringWithFormat:@"changeDBBase%@",appIdentifier]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"aginGotoApp"];
    
    NSString *Version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:Version];
    
    //注册微信
    [WXApi registerApp:WXAppID];
    //注册微博
    [WeiboSDK registerApp:WBAppID];
    
    //从钥匙串读取用户ID
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    
    if (userID.length && (![userID isEqualToString:@"(null)"])) {
        _isDataManager = YES;
        
        BOOL isBuiltBook = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isBuiltBook"] boolValue];
        
        BOOL newBuiltBook = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newBuiltBook"] boolValue];
        if (!isBuiltBook || !newBuiltBook) {
            [self builtBook];
        }
    }
    
    [self requestRegistUser101];
    
    [NSThread sleepForTimeInterval:0.5];//设置启动页面时间
    //配置友盟
    [self umengTrack];
    //初始化热云sdk
    [ReYunChannel initWithappKey:ReYunTruck withChannelId:@"_default_"];
    
    //异常处理、程序的崩溃路径捕捉
    NSSetUncaughtExceptionHandler(&getException);

    [self requestLoading103];

//    [self requestChannelCode137];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainVC) name:@"enterMain" object:nil];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = WhiteColor;
    
    self.nightView = [[UIView alloc] init];
    self.nightView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    BOOL isGotoWheelPicturVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGotoWheelPicturVC"] boolValue];
    if (!isGotoWheelPicturVC) {
        [self gotoWheelPictur];

    } else {
        
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlStr"];
        if (urlStr.length) {
            [self gotoViewController];
        } else {
            [self changeMainVC];
        }
    }
#ifdef DEBUG
    [ReYunChannel setPrintLog:YES];
#endif
    return YES;
}
#pragma mark - 倒数据库
- (void)changeDBBase{
    NSString  * userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    if (userID && userID.length) {
        DVCoreDataManager*dataManager = [DVCoreDataManager sharedManager];
        [dataManager initDataBaseWithUserID:userID];
        Rack *rack = [dataManager FetchEntitysWithName:@"Rack" entityId:RackOnlyID];
        
        JYS_SqlManager *sqlManager = [JYS_SqlManager shareManager];
        //存放的是booKRack类型
        //        self.addBookRackArray = nil;
        NSArray *bookRackArray = rack.rookRack.allObjects;
        for (int i= 0; i<bookRackArray.count; i++) {
            BookRack *bookRack = bookRackArray[i];
            Book *book = [dataManager FetchEntitysWithName:@"Book" entityId:bookRack.entityid];
            ReadRecord *readRecord = [dataManager FetchEntitysWithName:@"ReadRecord" entityId:bookRack.entityid];
            if (bookRack.entityid) {
                BookInforModel *bookInfor = [BookInforModel new];
                bookInfor.bookid = bookRack.entityid;
                bookInfor.entityid = bookRack.entityid;
                bookInfor.coverurl = bookRack.coverImage.length?bookRack.coverImage:@"";
                bookInfor.author = bookRack.author.length?bookRack.author:@"";
                bookInfor.introuce = bookRack.introuce.length?bookRack.introuce:@"";
                bookInfor.confirmStatus = book.confirmStatus?book.confirmStatus:@(0);
                
                bookInfor.chapterIndex = readRecord.chapterIndex.stringValue.length?readRecord.chapterIndex.stringValue:@"0";
                bookInfor.currentPageIndex = readRecord.currentPageIndex.stringValue.length?readRecord.currentPageIndex.stringValue:@"0";
                bookInfor.time = book.time.length?book.time:readRecord.readTime.length?readRecord.readTime:bookRack.dateTime;
                if (readRecord) {
                    bookInfor.hasRead = @1;
                }else{
                    bookInfor.hasRead = @0;
                }
                bookInfor.price = book.price.length?book.price:@"";
                bookInfor.bookName = bookRack.bookName.length?bookRack.bookName:@"";
                bookInfor.currentCatelogId = bookRack.chapterId.length?bookRack.chapterId:book.currentCatelogId.length?book.currentCatelogId:@"";
                LRLog(@"bookname-----%@",bookRack.bookName);
                bookInfor.isAddBook = @1;
                [sqlManager insertBookRackWithBooks:@[bookInfor]];
            }
            if (book.catelog.count) {
                NSArray *catelogs = book.catelog.allObjects;
                NSMutableArray *catelogInfor = [NSMutableArray new];
                for (int i=0; i<catelogs.count; i++) {
                    Catelog *catelog = catelogs[i];
                    CatelogInforModel *cateInfor = [CatelogInforModel new];
                    cateInfor.chaterId =  catelog.entityid.length?catelog.entityid:@"";
                    cateInfor.entityid =  [NSString stringWithFormat:@"%@%@",bookRack.entityid,catelog.entityid];
                    cateInfor.catelogName = catelog.catelogname.length?catelog.catelogname:@"";
                    cateInfor.path = catelog.chapter.path.length?catelog.chapter.path:@"";
                    cateInfor.isPay = catelog.ispay.integerValue?@(catelog.ispay.integerValue):@0;
                    cateInfor.bookid = bookRack.entityid;
                    [catelogInfor addObject:cateInfor];
                }
                [sqlManager insertCatelogsWithArray:catelogInfor];
            }
        }
    }
}

#pragma mark - 异常处理、程序的崩溃路径捕捉
void getException(NSException *exception){
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    //机型
    NSString *model = [Function devicePlatform];
 
    //将捕获的异常数据发送到友盟
    if (model.length && exception.reason.length) {
        NSDictionary *dict = @{@"reason" : exception.reason,@"callStackSymbols" : exception.callStackSymbols,@"model" : model,@"dateTime" : dateTime};
        [MobClick event:@"CollapseLog" attributes:dict];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"ErrorLog"];

        BOOL isYes;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isYes]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",dateTime]];
        [dict writeToFile:path atomically:YES];
 
    }
}


- (void)gotoViewController{

    ViewController *viewVC = [[ViewController alloc] init];
    BaseNavgationViewController *nav  =[[BaseNavgationViewController alloc]initWithRootViewController:viewVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)gotoWheelPictur{
    
    WheelPictureController *animation = [[WheelPictureController alloc] init];
    self.window.rootViewController = animation;
    [self.window makeKeyAndVisible];
}


- (void)changeMainVC{

    RootTabBarController *rootTab = [[RootTabBarController alloc] init];
    self.window.rootViewController = rootTab;
    [self.window makeKeyAndVisible];
    self.mainTabBarController = rootTab;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGFloat nightAlpha = [[userDefaults objectForKey:@"NightAlpha"] floatValue];

    self.nightView.backgroundColor = [UIColor blackColor];
    self.nightView.alpha = nightAlpha;
    self.nightView.userInteractionEnabled = NO;
    [self.window addSubview:self.nightView];
}

#pragma mark - 设置访问地址
- (void)requestChannelCode137{

    self.channelModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"channelNo"] = ChannelCode;
    [self.channelModel registerAccountAndCall:137 andRequestData:requestData];
}

#pragma mark - 配置loading
- (void)requestLoading103{

    //生成appSign
//    LRLog(@"%@",[self md5:@"com.dianzhong.kuaikan"]);
    
    NSArray *array = [NSArray arrayWithObjects:@"WECHAT",@"SINA",@"QQ", nil];

    self.loadingModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"5";
    requestData[@"appSign"] = @"254c47e546ce0a596119300a620d6ed2";
    
    requestData[@"lastModify"] = @"";
    requestData[@"paramtime"] = @"";
    requestData[@"supportLoginWay"] = array;
    [self.loadingModel registerAccountAndCall:103 andRequestData:requestData];
}

#pragma mark - 注册
- (void)requestRegistUser101{
    
    self.netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    NSString *UUID = [self getDeviceId];
    requestData[@"apkversion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    requestData[@"deviceId"] = UUID;
    requestData[@"channelCode"] = ChannelCode;
    [self.netWorkModel registerAccountAndCall:101 andRequestData:requestData];
}


#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{

    
    if (message.call == 101) {
        if (message.resultCode == 0) {//resultCode==0 成功
            
            LRLog(@"%@",message.responseData);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [NSString stringWithFormat:@"%@",message.responseData[@"userId"]];
            
            //热云登录统计
            [ReYunChannel setLoginWithAccountID:userId];
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
            if (!(remainSum == nil || [remainSum isEqualToString:@""] || [remainSum isEqualToString:@"(null)"])) {
                [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            }
            
            NSInteger mustUpdate = [message.responseData[@"mustUpdate"] integerValue];
            [userDefaults setObject:@(mustUpdate) forKey:@"mustUpdate"];
            [userDefaults setObject:message.responseData[@"rversion"] forKey:@"rversion"];
            [userDefaults setObject:message.responseData[@"introduction"] forKey:@"introduction"];
          
            //从钥匙串读取用户ID
            if (userId != nil && (![userId isEqualToString:@""]) && (![userId isEqualToString:@"(null)"])){
                [userDefaults setObject:userId forKey:@"userIDDefaults"];
                [YFKeychainTool saveKeychainValue:userId key:BundleIDUserID];
            }
            
            if ((![userId isEqualToString:@"(null)"]) && (![userId isEqualToString:@""])) {
//                DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
//                [dataManager initDataBaseWithUserID:userId];
                BOOL isBuiltBook = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isBuiltBook"] boolValue];
                
                BOOL newBuiltBook = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newBuiltBook"] boolValue];
                if (!isBuiltBook || !newBuiltBook) {
                    [self builtBook];
                }
            }
        } else {
            
        }
    } else if (message.call == 103) {
        LRLog(@"%@",message.responseData);
        NSDictionary *dict = message.responseData[@"action"];
        NSInteger type = [dict[@"type"] integerValue];
        NSString *url = dict[@"url"];
        NSString *title = dict[@"title"];
        NSString *bookID = dict[@"id"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *urlStr = message.responseData[@"url"];
        [userDefaults setObject:urlStr forKey:@"urlStr"];
        [userDefaults setObject:@(type) forKey:@"type"];
        [userDefaults setObject:url forKey:@"url"];
        [userDefaults setObject:title forKey:@"title"];
        [userDefaults setObject:bookID forKey:@"id"];
        
        NSArray *array = message.responseData[@"loginList"];
        
        [userDefaults setObject:array forKey:@"loginList"];
        
        
    } else if (message.call == 137) {
        
    }
}

#pragma mark - 获取设备唯一标识
- (NSString *)getDeviceId{
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
 

}

// 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    
    return  result || [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    if ([urlStr isEqualToString:@"wx2d567f33ab16a8b8://platformId=wechat"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url];
    }

    return  [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];

    return result || [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    //微信发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWX" object:self];
    
    //支付宝发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateZFB" object:self];

    //短信发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRDO" object:self];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL updateVersion =[[userDefaults objectForKey:@"updateVersion"] boolValue];
    if (updateVersion) {
        //更新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVersion" object:self];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {


    
}

#pragma mark - 添加内置图书
- (void)builtBook{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"isBuiltBook"];
    [userDefaults setObject:@(YES) forKey:@"newBuiltBook"];

    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"booklist" ofType:@"properties"];
    
    NSString *strArray = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [[NSArray alloc] init];
    array = [strArray componentsSeparatedByString:@","];
    JYS_SqlManager *coreModel = [JYS_SqlManager shareManager];
    for (int i = 0; i < array.count-1; i ++) {
        NSString *resourceStr = array[i];
        
        NSString *tntFile = [[NSBundle mainBundle] pathForResource:resourceStr ofType:@"txt"];
        NSString *str = [NSString stringWithContentsOfFile:tntFile encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dictTxt = [str jsonValue];
        
        //获取当前时间，日期
        NSDate *currentDate = [NSDate date];
        NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
        
        NSMutableDictionary *dicta = [[NSMutableDictionary alloc] init];
     
        [dicta setObject:array[i] forKey:@"bookId"];
        [dicta setObject:dictTxt[@"coverWap"] forKey:@"coverWap"];
        [dicta setObject:dictTxt[@"author"] forKey:@"author"];
        [dicta setObject:@"" forKey:@"introduction"];
        [dicta setObject:dictTxt[@"bookName"] forKey:@"bookName"];
        
        NSString *chapterID = dictTxt[@"chapterId"];
        NSMutableDictionary *chapterListDict = [[NSMutableDictionary alloc] init];
        [chapterListDict setObject:chapterID forKey:@"chapterId"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:chapterListDict];
        
        NSMutableDictionary *lastChapter = [[NSMutableDictionary alloc] init];
        [lastChapter setObject:@"" forKey:@"chapterId"];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
        [mutableDict setObject:dateString forKey:@"dateTime"];
        [mutableDict setObject:dicta forKey:@"book"];
        [mutableDict setObject:array forKey:@"chapterList"];
        [mutableDict setObject:lastChapter forKey:@"lastChapterInfo"];
        [coreModel insertData:mutableDict];
    }

}

//根据字数计算高度或者长度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//公共上行参数
+ (NSDictionary *)mypublicParam{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    //设备唯一标识
    NSString *uuid = [Function getDeviceId];
    [param setObject:uuid forKey:@"deviceId"];
    
    //appCode代表产品线
    [param setObject:@"i001" forKey:@"appCode"];
    
    //渠道号channelCode
    [param setObject:ChannelCode forKey:@"channelCode"];

    
    //userId
    NSString *useID = [Function getUserId];
    [param setObject:useID forKey:@"userId"];
    
    //apiVersion
    NSString *apiVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [param setObject:apiVersion forKey:@"apiVersion"];
    
    //应用包表示
    NSString *appIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    [param setObject:appIdentifier forKey:@"pname"];
    
    //系统版本
    NSString *os = [UIDevice currentDevice].systemName;
    os = [os stringByAppendingFormat:@" %@", [UIDevice currentDevice].systemVersion];
    [param setObject:os forKey:@"os"];
    
    // 机型
    NSString *model = [Function devicePlatform];
    [param setObject:model forKey:@"model"];
    
    //用户网络类型
    NSString *apn = [Function getNetWorkType];
    [param setObject:apn forKey:@"apn"];
    
    [param setObject:@"" forKey:@"macAddr"];
    
    NSString *tntFile = [[NSBundle mainBundle] pathForResource:@"svn_info" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:tntFile encoding:NSUTF8StringEncoding error:nil];
    [param setObject:str forKey:@"clientAgent"];
    
    return param;
}



- (void)onResp:(BaseResp *)resp{


    if ([resp isKindOfClass:[SendAuthResp class]]) {
 
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_wxDelegate loginSuccessByCode:resp2.code];
            }
        }  else{ //失败
            LRLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}


/**
 
 微博登录，成功与否都会走这个方法。 用户根据自己的业务进行处理。
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //微博登录的回调
    {
        if ([_weiboDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_weiboDelegate weiboLoginByResponse:response];
        }
    }
   
}



@end
