//
//  WheelPictureController.m
//  Kuaikan
//
//  Created by 少少 on 16/8/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "WheelPictureController.h"
#import "Function.h"

@interface WheelPictureController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *temButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@end

@implementation WheelPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, ScreenHeight)];
    scrollView.pagingEnabled = YES ;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight-64.f-45.f-49.f);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageView.image = [UIImage imageNamed:@"icon_wheelOne.jpg"];
    imageView.userInteractionEnabled = YES;
    [scrollView addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    imageView2.image = [UIImage imageNamed:@"icon_wheelTwo.jpg"];
    imageView2.userInteractionEnabled = YES;
    [scrollView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
    imageView3.image = [UIImage imageNamed:@"icon_wheelThree.jpg"];
    imageView3.userInteractionEnabled = YES;
    [scrollView addSubview:imageView3];
    
    
    self.temButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.temButton.frame = CGRectMake(((ScreenWidth - 271 * KKuaikan) / 2) , ScreenHeight - 90 * KKuaikan, 271 * KKuaikan , 62 * KKuaikan);
    [self.temButton setBackgroundImage:[UIImage imageNamed:@"icon_gotoMain"] forState:UIControlStateNormal];
    
    [self.temButton addTarget:self action:@selector(temButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [imageView3 addSubview:_temButton];
    
    //倒数据库
    
}

- (void)temButtonTouch{
    //从钥匙串读取用户ID
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    if (userID.length && (![userID isEqualToString:@"(null)"])) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(YES) forKey:@"isGotoWheelPicturVC"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enterMain" object:self];
    } else {
    
        self.netWorkModel = [[NetworkModel alloc] initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        NSString *UUID = [self getDeviceId];
        requestData[@"apkversion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        requestData[@"deviceId"] = UUID;
        [self.netWorkModel registerAccountAndCall:101 andRequestData:requestData];
        
    }
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    
    if (message.call == 101) {
       
        if (message.resultCode == 0) {//resultCode==0 成功
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = message.responseData[@"userId"];
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
        
            [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
            [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            
//            DVCoreDataManager *dataManager = [DVCoreDataManager sharedManager];
//            [dataManager initDataBaseWithUserID:userId];
            
            //从钥匙串读取用户ID
            
            if (userId != nil && (![userId isEqualToString:@""]) && (![userId isEqualToString:@"(null)"])){
                [userDefaults setObject:userId forKey:@"userIDDefaults"];
                [YFKeychainTool saveKeychainValue:userId key:BundleIDUserID];
            }
            
            [self builtBook];
                
        } else {
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"网络设置" message:@"检查到您的网络出现问题，请前往设置" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往",nil];
            alvertView.delegate = self;
            [alvertView show];
        }
    } 
}


#pragma mark - 添加内置图书
- (void)builtBook{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"isBuiltBook"];
    
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"booklist" ofType:@"properties"];
    NSString *strArray = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [[NSArray alloc] init];
    array = [strArray componentsSeparatedByString:@","];
    
    
    for (int i = 0; i < array.count; i ++) {
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
        
        JYS_SqlManager *coreModel = [JYS_SqlManager shareManager];
        [coreModel insertData:mutableDict];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
            
        }
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


@end
