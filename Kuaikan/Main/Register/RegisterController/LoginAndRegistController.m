
//
//  LoginAndRegistController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/10.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "LoginAndRegistController.h"
#import "LoginController.h"
#import "RegistController.h"
#import "LoginButton.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@interface LoginAndRegistController ()<WXDelegate,WeiBoDelegate,TencentSessionDelegate>

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSMutableArray *permissionArray;//权限列表
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, assign) NSInteger index;


@end

@implementation LoginAndRegistController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [_navigationBarView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self createNavigationBarView];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    [self setupLineRemaind];
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
    
    
    //快看账号登录
    //    [self setupAccountLogin];
}

- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"登录"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
    titleMainLabel.tag = 101;
    titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 100, 0, 100));
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton addTarget:self action:@selector(closeWindowClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBarView).with.offset(0.0f);
        make.left.equalTo(_navigationBarView).with.offset(0.0f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [closeButton setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
    
}

//返回
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)setupLineRemaind{
    
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.text = @"登录可永久保护阅读记录";
    remindLabel.textColor = TextColor;
    remindLabel.font = Font14;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.frame = CGRectMake(0, 0, ScreenWidth, 40);
    [self.view addSubview:remindLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_Login_icon"];
    CGFloat imageViewY = CGRectGetMaxY(remindLabel.frame) +  110 * KKuaikan;
    if (KKuaikan < 1) {
        imageViewY = CGRectGetMaxY(remindLabel.frame) +  105 * KKuaikan;
    }
    
    imageView.frame = CGRectMake((ScreenWidth - 71)/2, imageViewY, 71, 71);
    [self.view addSubview:imageView];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSArray *array = [userDefaults objectForKey:@"loginList"];
    
    
    NSString *firstKey = @"";
    NSString *secondKey = @"";
    NSString *threeKey = @"";
    
    if (array.count) {
        
        NSDictionary *dict = [NSDictionary dictionary];
        
        for (int i = 0; i < array.count; i ++) {
            dict = array[i];
            if (i == 0) {
                firstKey = dict[@"key"];
            } else if (i == 1) {
                secondKey = dict[@"key"];
            } else if (i == 2) {
                threeKey = dict[@"key"];
            }
        }
        
    } else {
        
        firstKey = @"WECHAT";
        secondKey = @"QQ";
        threeKey = @"SINA";
    }
    
    NSString *firstStr = @"";
    NSString *secondStr = @"";
    NSString *threeStr = @"";
    
    UIButton *firstBtn = [[UIButton alloc] init];
    firstBtn.backgroundColor = ADColor(22, 172, 57);
    CGFloat firstBtnY = CGRectGetMaxY(imageView.frame) + 40 * KKuaikan;
    firstBtn.frame = CGRectMake(20, firstBtnY, ScreenWidth - 40, 50 * KKuaikan);
    if ([firstKey isEqualToString:@"WECHAT"]) {
        firstStr = @"微信";
        firstBtn.tag = 1;
        firstBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (ScreenWidth - 40)/2 - 100 * KKuaikan, 0, 0);
    } else if ([firstKey isEqualToString:@"QQ"]) {
        firstStr = @"QQ";
        firstBtn.tag = 2;
        firstBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (ScreenWidth - 40)/2 - 110 * KKuaikan, 0, 0);
    } else if ([firstKey isEqualToString:@"SINA"]) {
        firstStr = @"微博";
        firstBtn.tag = 3;
        firstBtn.titleEdgeInsets = UIEdgeInsetsMake(0, (ScreenWidth - 40)/2 - 100 * KKuaikan, 0, 0);
    }
    
    [firstBtn setTitle:[NSString stringWithFormat:@"%@一键登录",firstStr] forState:UIControlStateNormal];
    firstBtn.titleLabel.font = Font18;
    
    
    firstBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [firstBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [firstBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_%@",firstStr]] forState:UIControlStateNormal];
    [self.view addSubview:firstBtn];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"登录—%@",firstStr]];
    iconImage.frame = CGRectMake((ScreenWidth - 40)/2 - 60, 13 * KKuaikan, 24 * KKuaikan, 24 * KKuaikan);
    [firstBtn addSubview:iconImage];
    
    CGFloat lineLeftY = CGRectGetMaxY(firstBtn.frame) + 100 * KKuaikan;
    if (KKuaikan < 1) {
        lineLeftY = CGRectGetMaxY(firstBtn.frame) + 85 * KKuaikan;
    }
    
    UILabel *lineLeft = [[UILabel alloc] init];
    UILabel *loginLabel = [[UILabel alloc] init];
    
    if (array.count > 1) {
        
        lineLeft.frame = CGRectMake(32, lineLeftY, (ScreenWidth - 64)/2 - 90, 0.5);
        lineLeft.backgroundColor = LineLabelColor;
        [self.view addSubview:lineLeft];
        
        loginLabel.text = @"或者使用以下登录方式";
        loginLabel.font = Font16;
        loginLabel.frame = CGRectMake((ScreenWidth - 180)/2, lineLeftY - 10,180, 20);
        loginLabel.textColor = LightTextColor;
        loginLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:loginLabel];
        
        UILabel *lineRight = [[UILabel alloc] init];
        lineRight.frame = CGRectMake((ScreenWidth)/2 + 90, lineLeftY, (ScreenWidth - 64)/2 - 90, 0.5);
        lineRight.backgroundColor = LineLabelColor;
        [self.view addSubview:lineRight];
    }
    
    
    
    
    CGFloat secondImageY = CGRectGetMaxY(loginLabel.frame) + 34;
    
    if (array.count > 1) {
        UIButton *secondBtn = [[UIButton alloc] init];
        
        if (array.count == 2) {
            secondBtn.frame = CGRectMake((ScreenWidth - 75)/2, secondImageY, 75, 65);
        } else {
            secondBtn.frame = CGRectMake((ScreenWidth - 210)/2, secondImageY, 75, 65);
        }
        
        
        if ([secondKey isEqualToString:@"WECHAT"]) {
            secondStr = @"微信";
            secondBtn.tag = 1;
        } else if ([secondKey isEqualToString:@"QQ"]) {
            secondStr = @"QQ";
            secondBtn.tag = 2;
        } else if ([secondKey isEqualToString:@"SINA"]) {
            secondStr = @"微博";
            secondBtn.tag = 3;
        }
        
        UIImageView *secondImage = [[UIImageView alloc] init];
        secondImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",secondStr]];
        if (array.count == 2) {
            secondImage.frame = CGRectMake((ScreenWidth - 35)/2, secondImageY, 35, 35);
        } else {
            secondImage.frame = CGRectMake((ScreenWidth - 170)/2, secondImageY, 35, 35);
        }
        
        [self.view addSubview:secondImage];
        
        UILabel *secondLabel = [[UILabel alloc] init];
        secondLabel.text = [NSString stringWithFormat:@"%@登录",secondStr];;
        secondLabel.textColor = LightTextColor;
        CGFloat secondLabelY = CGRectGetMaxY(secondImage.frame) + 8;
        if (array.count == 2) {
            secondLabel.frame = CGRectMake((ScreenWidth - 75)/2, secondLabelY, 75, 20);
        } else {
            secondLabel.frame = CGRectMake((ScreenWidth - 210)/2, secondLabelY, 75, 20);
        }
        
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.font = Font16;
        [self.view addSubview:secondLabel];
        
        
        [secondBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:secondBtn];
    }
    
    
    if (array.count > 2) {
        UIButton *threeBtn = [[UIButton alloc] init];
        threeBtn.frame = CGRectMake((ScreenWidth + 60)/2, secondImageY, 75, 65);
        
        if ([threeKey isEqualToString:@"WECHAT"]) {
            threeStr = @"微信";
            threeBtn.tag = 1;
        } else if ([threeKey isEqualToString:@"QQ"]) {
            threeStr = @"QQ";
            threeBtn.tag = 2;
        } else if ([threeKey isEqualToString:@"SINA"]) {
            threeStr = @"微博";
            threeBtn.tag = 3;
        }
        
        UIImageView *threeImage = [[UIImageView alloc] init];
        threeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",threeStr]];
        threeImage.frame = CGRectMake((ScreenWidth + 100)/2, secondImageY, 35, 35);
        [self.view addSubview:threeImage];
        
        UILabel *threeLabel = [[UILabel alloc] init];
        threeLabel.text = [NSString stringWithFormat:@"%@登录",threeStr];;
        threeLabel.textColor = LightTextColor;
        CGFloat threeLabelY = CGRectGetMaxY(threeImage.frame) + 8;
        threeLabel.frame = CGRectMake((ScreenWidth + 60)/2, threeLabelY, 75, 20);
        threeLabel.textAlignment = NSTextAlignmentCenter;
        threeLabel.font = Font16;
        [self.view addSubview:threeLabel];
        
        [threeBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:threeBtn];
    }
}


#pragma mark - 第三方登录
- (void)loginBtnClick:(UIButton *)button{
    
    if (button.tag == 1) {//微信登录
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = WXAppID;
            
            [AppDelegate sharedApplicationDelegate].wxDelegate = self;
            [WXApi sendReq:req];
        }
        else {
            [self.view showAlertTextWith:@"您未安装微信"];
        }
    } else if (button.tag == 2) {//QQ登录
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            //设置权限数据 ， 具体的权限名，在sdkdef.h 文件中查看。
            _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
            
            //登录操作
            [_tencentOAuth authorize:_permissionArray inSafari:NO];
        } else {
            [self.view showAlertTextWith:@"您未安装QQ"];
        }
        
        
        
    } else if (button.tag == 3) {//微博登录
        
        [AppDelegate sharedApplicationDelegate].weiboDelegate = self;
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        
        [WeiboSDK sendRequest:request];
    }
    
}

#pragma mark - 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    
    _index = 1;
    [self gotoLogin:code andIndex:@"1"];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    if (_tencentOAuth.accessToken) {
        
        _index = 2;
        [self gotoLogin:_tencentOAuth.accessToken andIndex:@"2"];
        
    }else{
        
        LRLog(@"accessToken 没有获取成功");
    }
    
}


#pragma mark - 微博登录代理回调
-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    
    NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
    
    _index = 3;
    [self gotoLogin:accessToken andIndex:@"3"];
    
}




#pragma mark - 微信、QQ、微博登录
- (void)gotoLogin:(NSString *)code andIndex:(NSString *)accountType{
    
    [SVProgressHUD showWithStatus:@"第三方登录中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *array = @"QQ\\,WECHAT\\,SINA";
    
    NSData *resData = [[NSData alloc] initWithData:[array dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *strs=[[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    
    NetworkModel *netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"type"] = @"1";
    requestData[@"bindId"] = code;
    requestData[@"accountType"] = accountType;
    requestData[@"appSign"] = @"254c47e546ce0a596119300a620d6ed2";
  //  requestData[@"supportLoginWay"] = strs;
    [netWorkModel registerAccountAndCall:219 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.call == 214) {
        LRLog(@"!!!!!%@",message.responseData);
        
        LRLog(@"!!!!!%ld",(long)message.resultCode);

        NSArray *array = message.responseData[@"bookIds"];
        
        if ([array isKindOfClass:[NSArray class]] && array.count) {
            LRLog(@"214---array ---%@",array);
            NSInteger ismore = [message.responseData[@"isMore"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:@(ismore) forKey:@"isMore"];

            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:array forKey:@"list"];
                        
            
            NetworkModel *getBookModel = [[NetworkModel alloc] initWithResponder:self];
            NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
            requestData[@"list"] = dict[@"list"];
            [getBookModel registerAccountAndCall:222 andRequestData:requestData];
            
        }
    } else if (message.call == 222) {
        
        LRLog(@"%@____%ld",message.responseData,(long)message.resultCode);
        if (message.resultCode == 0) {
            NSArray *list = message.responseData[@"list"];
            NSDictionary *dict = nil;
            NSDictionary *book = nil;
            NSArray *chapterList = nil;
            NSDictionary *dictChapter = nil;
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            NSDate *currentDate = [NSDate date];
            for (NSInteger i = 0; i < list.count; i ++) {
          //  for (NSInteger i = list.count - 1; i >= 0; i --) {
                dict = list[i];
                book = dict[@"book"];
                chapterList = dict[@"chapterList"];
                dictChapter = chapterList[0];
                BookInforModel *bookModel = [dataManager getBookWithBookId:book[@"bookId"]];
                if (bookModel == nil) {
                    bookModel = [BookInforModel new];
                    bookModel.bookid = [NSString stringWithFormat:@"%@",book[@"bookId"]];
                    bookModel.bookName = book[@"bookName"];
                    bookModel.coverurl = book[@"coverWap"];
                    bookModel.marketStatus = @([book[@"marketStatus"] intValue]);
                    bookModel.payWay = @([book[@"payWay"] intValue]);
                    bookModel.isAddBook = @(1);
                    
                    NSString *chapterID = dictChapter[@"chapterId"];
                    if (chapterID.length) {
                        bookModel.chapterId = chapterID;

                    }
                    bookModel.time = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
                    bookModel.dateTime = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
                    [dataManager insertBookRackWithObject:bookModel];
                } else {
                    bookModel.bookid = [NSString stringWithFormat:@"%@",book[@"bookId"]];
                    bookModel.bookName = book[@"bookName"];
                    bookModel.coverurl = book[@"coverWap"];
                    bookModel.marketStatus = @([book[@"marketStatus"] intValue]);
                    bookModel.payWay = @([book[@"payWay"] intValue]);
                    bookModel.isAddBook = @(1);
                    NSString *chapterID = dictChapter[@"chapterId"];
                    if (chapterID.length) {
                        bookModel.chapterId = chapterID;
                    }
                    bookModel.time = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
                    bookModel.dateTime = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
                    [WHC_ModelSqlite update:bookModel where:[NSString stringWithFormat:@"bookid = %@",bookModel.bookid]];
                }
                
            }
            if (list.count) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"refreshBookRack"];
                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isMoreYES"];
            }

        }

    } else if (message.call == 219) {
        
        if (message.resultCode == 0) {
            LRLog(@"message.responseData == %@",message.responseData);
            NSString *tips = message.responseData[@"tips"];
            [SVProgressHUD showSuccessWithStatus:tips];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *result = [NSString stringWithFormat:@"%@",message.responseData[@"result"]];
            
            if ([result isEqualToString:@"1"]) {//登录成功
                
                NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
                
                NSString *newUserID = [NSString stringWithFormat:@"%@",message.responseData[@"userId"]];
                
                [userDefaults setObject:@(YES) forKey:@"isLoginSuccess"];
                
                if ([userID isEqualToString:newUserID]) {//用户ID没变
                    [userDefaults setObject:@(NO) forKey:@"userIdIsUpdate"];
                } else {
                    [userDefaults setObject:@(YES) forKey:@"userIdIsUpdate"];
                }
                
                NSArray *account = message.responseData[@"account"];
                NSDictionary *dict = nil;
                
                NSString *key = @"";
                if (_index == 1) {//微信登录
                    key = @"WECHAT";
                } else if (_index == 2) {//QQ登录
                    key = @"QQ";
                } else if (_index == 3) {//微博登录
                    key = @"SINA";
                }
                
                NSString *keyStr = @"";
                for (int i = 0; i < account.count; i ++) {
                    dict = account[i];
                    
                    keyStr = [NSString stringWithFormat:@"%@",dict[@"key"]];
                    
                    if ([key isEqualToString:keyStr]) {
                        dict = account[i];
                        
                        break;
                    }
                }
                
                
                NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
                NSString *userId = [NSString stringWithFormat:@"%@",message.responseData[@"userId"]];
                
                NSString *coverWap = [NSString stringWithFormat:@"%@",dict[@"coverWap"]];
                
                [userDefaults setObject:userId forKey:@"userIDDefaults"];
                [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
                
                [userDefaults setObject:dict[@"nickname"] forKey:@"LoginNickname"];
                
                [userDefaults setObject:account forKey:@"AccountSafe"];
                
                if (coverWap.length) {
                    [userDefaults setObject:coverWap forKey:@"LoginCoverWap"];
                    
                    UIImageView *imageVew = [[UIImageView alloc] init];
                    
                    [imageVew sd_setImageWithURL:[NSURL URLWithString:dict[@"coverWap"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        NSData *data;
                        if (UIImageJPEGRepresentation(imageVew.image, 1)) {
                            data = UIImageJPEGRepresentation(imageVew.image, 1);
                        } else {
                            data = UIImagePNGRepresentation(imageVew.image);
                        }
                        [userDefaults setObject:data forKey:@"iconImage"];
                        
                    }];
                }
                
                [self requestOthrtBook214];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:self];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {//登录失败
                
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
    }
}


#pragma mark - 云书架同步
- (void)requestOthrtBook214{
    
    NSString *idStrsSecond = nil;

    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];

    NSArray *bookRackArray = [dataManager getBookRackBooks];

    if (bookRackArray.count) {
        //存放的是booKRack类型

        for (int i = 0; i < bookRackArray.count; i ++) {

            BookInforModel *bookRack = bookRackArray[i];
            if (idStrsSecond) {
                if (bookRack.bookid && bookRack.updateChapter) {
                    idStrsSecond = [NSString stringWithFormat:@"%@,%@",idStrsSecond,bookRack.bookid];
                }
            } else {
                if (bookRack.bookid && bookRack.updateChapter) {
                    idStrsSecond = [NSString stringWithFormat:@"%@",bookRack.bookid];
                }
            }
        }
    }


    NetworkModel *otherWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    if (idStrsSecond.length) {
        requestData[@"bookIds"] = idStrsSecond;
    } else {
        requestData[@"bookIds"] = @"";
    }
    
    
    [otherWorkModel registerAccountAndCall:214 andRequestData:requestData];
}


@end
