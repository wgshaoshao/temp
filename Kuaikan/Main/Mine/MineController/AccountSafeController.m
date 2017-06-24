//
//  AccountSafeController.m
//  Kuaikan
//
//  Created by 少少 on 17/3/17.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "AccountSafeController.h"
#import "AcountSafeView.h"
#import "LoginAndRegistController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@interface AccountSafeController ()<AcountSafeViewDelegate,WXDelegate,WeiBoDelegate,TencentSessionDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSMutableArray *permissionArray;//权限列表
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *myView;
@end

@implementation AccountSafeController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [_myView removeFromSuperview];
    [_navigationBarView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self createNavigationBarView];
    
    [self setupThreeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
    
    self.view.backgroundColor = BackViewColor;
    
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
    titleMainLabel.text = @"账户与安全";
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
    titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 50, 0, 50));
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

- (void)closeWindowClick{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupThreeView{
    
    _myView = [[UIView  alloc] init];
    
    [self.view addSubview:_myView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"绑定社交账号";
    titleLabel.font = Font14;
    titleLabel.textColor = TextColor;
    titleLabel.frame = CGRectMake(10, 0, 90, 40);
    [_myView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = Font12;
    textLabel.text = @"(暂不支持解绑)";
    textLabel.textColor = ADColor(153, 153, 153);
    textLabel.frame = CGRectMake(110, 0, 200, 40);
    [_myView addSubview:textLabel];
    
    NSArray *accountSafe = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountSafe"];
 
    
    AcountSafeView *firstAccount = [[AcountSafeView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 64)];
    if (accountSafe.count) {
        firstAccount.delegate = self;
        [firstAccount creatThreeView:accountSafe[0]];
        [_myView addSubview:firstAccount];
    }
    
    
    AcountSafeView *secondAccount = [[AcountSafeView alloc] initWithFrame:CGRectMake(0, 104, ScreenWidth, 64)];
    if (accountSafe.count > 1) {
        secondAccount.delegate = self;
        [secondAccount creatThreeView:accountSafe[1]];
        [_myView addSubview:secondAccount];
    }
    
    
    AcountSafeView *threeAccount = [[AcountSafeView alloc] initWithFrame:CGRectMake(0, 168, ScreenWidth, 64)];
    if (accountSafe.count > 2) {
        
        threeAccount.delegate = self;
        [threeAccount creatThreeView:accountSafe[2]];
        [_myView addSubview:threeAccount];
    }
    
    
    
    UIButton *switchUseBtn = [[UIButton alloc] init];
    
    CGFloat switchUseBtnY = 0;
    if (accountSafe.count == 1) {
        switchUseBtnY = CGRectGetMaxY(firstAccount.frame) + 30;
    } else if (accountSafe.count == 2) {
        switchUseBtnY = CGRectGetMaxY(secondAccount.frame) + 30;
    } else if (accountSafe.count == 3) {
        switchUseBtnY = CGRectGetMaxY(threeAccount.frame) + 30;

    }
    switchUseBtn.frame = CGRectMake(10, switchUseBtnY, ScreenWidth - 20, 40);
    [switchUseBtn setBackgroundImage:[UIImage imageNamed:@"button_user"] forState:UIControlStateNormal];
    [switchUseBtn setTitle:@"切换用户" forState:UIControlStateNormal];
    [switchUseBtn addTarget:self action:@selector(switchUseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    switchUseBtn.titleLabel.font = Font18;
    [_myView addSubview:switchUseBtn];
    
    CGFloat myViewY = CGRectGetMaxY(switchUseBtn.frame);
    _myView.frame = CGRectMake(0, 0, ScreenWidth, myViewY);
}

#pragma mark - 绑定按钮
- (void)accountThreeButton:(UIButton *)button{
    
//    LRLog(@"%ld",(long)button.tag);
    
    if (button.tag == 1) {//微信
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            
            [AppDelegate sharedApplicationDelegate].wxDelegate = self;
            [WXApi sendReq:req];
        } else {
            [self.view showAlertTextWith:@"您未安装微信"];
        }
    } else if (button.tag == 2) {//QQ
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            //设置权限数据 ， 具体的权限名，在sdkdef.h 文件中查看。
            _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
            
            //登录操作
            [_tencentOAuth authorize:_permissionArray inSafari:NO];
        } else {
            [self.view showAlertTextWith:@"您未安装QQ"];
        }
    } else if (button.tag == 3) {//微博
        [AppDelegate sharedApplicationDelegate].weiboDelegate = self;
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        
        [WeiboSDK sendRequest:request];
    }
}

#pragma mark - 微信登录回调
-(void)loginSuccessByCode:(NSString *)code{
    
    _index = 1;
    [self gotoLogin:code andIndex:@"1"];
}

#pragma mark - QQ登录成功回调
- (void)tencentDidLogin{
    
    if (_tencentOAuth.accessToken) {
        
        _index = 2;
        [self gotoLogin:_tencentOAuth.accessToken andIndex:@"2"];
        
    } else {
        
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
    
    [SVProgressHUD showWithStatus:@"绑定账号中..." maskType:SVProgressHUDMaskTypeClear];
    
    NetworkModel *netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"type"] = @"2";
    requestData[@"bindId"] = code;
    requestData[@"accountType"] = accountType;
    requestData[@"appSign"] = @"254c47e546ce0a596119300a620d6ed2";
    
    [netWorkModel registerAccountAndCall:219 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    
    if (message.resultCode == 0) {
        NSString *tips = message.responseData[@"tips"];
        [SVProgressHUD showImage:nil status:tips];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *result = [NSString stringWithFormat:@"%@",message.responseData[@"result"]];
        NSArray *account = message.responseData[@"account"];
        if ([result isEqualToString:@"1"]) {//登录成功
            LRLog(@"111111111111111111111111111111111111");
            [_myView removeFromSuperview];
            [self setupThreeView];
            [userDefaults setObject:account forKey:@"AccountSafe"];
        }
    } else {
    
        [SVProgressHUD showErrorWithStatus:@"绑定失败"];
    }
}

//切换用户
- (void)switchUseBtnClick{

    LoginAndRegistController *loginAndRegistVC = [[LoginAndRegistController alloc] init];
    [self.navigationController pushViewController:loginAndRegistVC animated:YES];
}

@end
