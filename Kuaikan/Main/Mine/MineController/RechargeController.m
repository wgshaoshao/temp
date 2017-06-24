//
//  RechargeController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RechargeController.h"
#import "BalanceView.h"
#import "MoneyButton.h"
#import "RechargeView.h"
#import <StoreKit/StoreKit.h>
#import "ZFBViewController.h"
#import "PromptView.h"
#import "WXApi.h"
#import "ReYunTrack.h"
#import "Function.h"

@interface RechargeController ()<RechargeViewDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIWebViewDelegate,PromptViewDelegate,BalanceViewDelegate>

@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) RechargeView *chargeView ;
@property (nonatomic, strong) RechargeView *chargeTwoView;
@property (nonatomic, strong) RechargeView *chargeThreeView;
@property (nonatomic, strong) RechargeView *chargeFourView;
@property (nonatomic, strong) BalanceView *balanceView;

@property (nonatomic, strong) UIScrollView *searchTable;
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) NetworkModel *orderModel;
@property (nonatomic, strong) NetworkModel *notificationModel;
@property (nonatomic, strong) NetworkModel *notificationRDOModel;
@property (nonatomic, strong) NetworkModel *notificationZFBModel;
@property (nonatomic, assign) BOOL isAppStore;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *orderNumWX;
@property (nonatomic, strong) NSString *orderNumRDO;
@property (nonatomic, strong) SKPaymentTransaction *myTran;
@property (nonatomic, assign) NSInteger payStatus;
@property (nonatomic, strong) NSString *userPhoneStr;
@property (nonatomic, assign) BOOL isFirstView;
@property (nonatomic, assign) BOOL isSecondView;
@property (nonatomic, assign) BOOL isThirdView;
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSString *contentPayType;
@property (nonatomic, strong) NSString *contentMoney;
@end

@implementation RechargeController

static BOOL isNeedVerifyProductId = NO;    // 是否需要向苹果服务器验证商品id

- (void)dealloc {
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [_navigationBarView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWX) name:@"updateWX" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRDO) name:@"updateRDO" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateZFB) name:@"updateZFB" object:nil];
    [self updateZFBYesOrNo];
    [self createNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ADColor(244, 244, 244);
    
    _contentPayType = @"";
    _contentMoney = @"0";

    _searchTable = [[UIScrollView alloc] init];
    if (_isRechare) {
        _searchTable.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    } else {
        _searchTable.frame = CGRectMake(0, -64, ScreenWidth, ScreenHeight + 64);
    }
    
    _searchTable.alwaysBounceVertical = YES;
    _searchTable.delegate = self;
    [self.view addSubview:_searchTable];
    
    
    _isAppStore = NO;
    
    [MobClick event:@"ClickRecharge" attributes:nil];
    
    [self setupBalanceView];

    [self requestPayList191];
}

-(void)handleKeyShow:(NSNotification *)notification{
    
//    
    CGFloat time = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat keyBordH = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
        
    
    CGFloat pointH = 0;
    
    CGFloat kkuaikan = (ScreenHeight / 667);
    if (kkuaikan == 1) {
        
        if (keyBordH != 216) {
            keyBordH = keyBordH - (keyBordH - 216) * 2;
        }
        pointH = ScreenHeight - 110 - keyBordH + 330;
    } else if (kkuaikan > 1) {
    
        if (keyBordH != 226) {
            keyBordH = keyBordH - (keyBordH - 226) * 2;
        }
        pointH = ScreenHeight - 230 - keyBordH + 330;
    } else if (kkuaikan < 1) {
       
        if (keyBordH != 216) {
            keyBordH = keyBordH - (keyBordH - 216) * 2;
        }
        pointH = ScreenHeight - keyBordH + 85 + 330;
    }

    [UIView animateWithDuration:time animations:^{
        
        _searchTable.contentOffset = CGPointMake(0, pointH);
//        _searchTable.height = ScreenHeight - keyBordH * KKuaikan;
    }];
}


-(void)handleHiden:(NSNotification *)notification{
    
    CGFloat time = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:time animations:^{
        
//        _searchTable.contentOffset = CGPointMake(0, 0);
        _searchTable.height = ScreenHeight;
    }];
}

//滑动撤销键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.chargeView.textField) {
        [self.chargeView.textField resignFirstResponder];
    } else if (self.chargeTwoView.textField) {
        [self.chargeTwoView.textField resignFirstResponder];
    } else if (self.chargeThreeView.textField) {
        [self.chargeThreeView.textField resignFirstResponder];
    } else if (self.chargeFourView.textField) {
        [self.chargeFourView.textField resignFirstResponder];
    }
}

#pragma mark - 充值列表
- (void)requestPayList191{
    
    [self.view showLoadingView];
    
    self.netWorkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"IOS_IAP_PAY"];
    
    if ([WXApi isWXAppInstalled]) {
        [array addObject:@"WECHAT_WAP_PAY"];
    }
    
    
    [array addObject:@"ALIPAY_WEB_PAY"];
    [array addObject:@"RDO_WAP_SDK"];
    requestData[@"supportList"] = array;
    requestData[@"phoneNum"] = @"";
    requestData[@"iosVersion"] = IOSVersion;
    [self.netWorkModel registerAccountAndCall:191 andRequestData:requestData];
}

#pragma mark - 下订单接口
- (void)requestOrder192:(NSInteger)index andListArray:(NSArray *)array{
    
    NSDictionary *dict = array[index];


    _contentMoney = dict[@"name"];
    
    self.orderModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"id"] = dict[@"id"];
    requestData[@"phoneNum"] = @"";
    [self.orderModel registerAccountAndCall:192 andRequestData:requestData];
}

- (void)updateZFBYesOrNo{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *payStatus = [userDefaults objectForKey:@"payStatus"];
    
    BOOL isFirstZFB = [[userDefaults objectForKey:@"ZFB"] boolValue];
    if (isFirstZFB) {
        if ([payStatus isEqualToString:@"2"]) {//支付宝充值
            
            [SVProgressHUD showWithStatus:@"加载充值是否成功"];
            self.notificationZFBModel = [[NetworkModel alloc] initWithResponder:self];
            NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"" forKey:@"resultInfo"];
            
            
            NSString *orderNumZFBstr = [userDefaults objectForKey:@"orderNumZFB"];
            if (orderNumZFBstr.length) {
                [dic setObject:orderNumZFBstr forKey:@"orderNum"];
            }
            
            [dic setObject:@"0" forKey:@"result"];
            
            [array addObject:dic];
            
            requestData[@"list"] = array;
            requestData[@"type"] = @"ALIPAY_WEB_PAY";
            requestData[@"action"] = @"2";
            [self.notificationZFBModel registerAccountAndCall:193 andRequestData:requestData];
        }
    }

}

#pragma mark - 支付宝订单通知
- (void)updateZFB{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *payStatus = [userDefaults objectForKey:@"payStatus"];
    
//    BOOL isFirstZFB = [[userDefaults objectForKey:@"ZFB"] boolValue];
//    if (isFirstZFB) {
        if ([payStatus isEqualToString:@"2"]) {//支付宝充值
            
            [SVProgressHUD showWithStatus:@"加载充值是否成功"];
            self.notificationZFBModel = [[NetworkModel alloc] initWithResponder:self];
            NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"" forKey:@"resultInfo"];
            
            
            NSString *orderNumZFBstr = [userDefaults objectForKey:@"orderNumZFB"];
            if (orderNumZFBstr.length) {
                [dic setObject:orderNumZFBstr forKey:@"orderNum"];
            }
            
            [dic setObject:@"0" forKey:@"result"];
            
            [array addObject:dic];
            
            requestData[@"list"] = array;
            requestData[@"type"] = @"ALIPAY_WEB_PAY";
            requestData[@"action"] = @"2";
            [self.notificationZFBModel registerAccountAndCall:193 andRequestData:requestData];
        }
//    }
}

#pragma mark - 短信订单通知
- (void)updateRDO{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *payStatus = [userDefaults objectForKey:@"payStatus"];
    if ([payStatus isEqualToString:@"3"]) {//短信充值
        [SVProgressHUD showWithStatus:@"加载充值是否成功"];
        self.notificationRDOModel = [[NetworkModel alloc] initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (_dataDict.count) {
            [dic setObject:_dataDict forKey:@"resultInfo"];
        } else {
            NSDictionary *dataDict = [userDefaults objectForKey:@"dataDict"];
            if (dataDict.count) {
                [dic setObject:dataDict forKey:@"resultInfo"];
            }
        }
        
        
        if (_orderNumRDO.length) {
            [dic setObject:_orderNumRDO forKey:@"orderNum"];
        } else {
            
            NSString *orderNumWXstr = [userDefaults objectForKey:@"orderNumRDO"];
            if (orderNumWXstr.length) {
                [dic setObject:[userDefaults objectForKey:@"orderNumRDO"] forKey:@"orderNum"];
            }
        }
        
        [dic setObject:@"0" forKey:@"result"];
        
        [array addObject:dic];
        
        requestData[@"list"] = array;
        requestData[@"type"] = @"RDO_WAP_SDK";
        requestData[@"action"] = @"2";
        requestData[@"v"] = @"1";
        [self.notificationRDOModel registerAccountAndCall:193 andRequestData:requestData];
    }
}

#pragma mark - 微信订单通知
- (void)updateWX{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *payStatus = [userDefaults objectForKey:@"payStatus"];
    if ([payStatus isEqualToString:@"0"]) {//微信充值
        [SVProgressHUD showWithStatus:@"加载充值是否成功"];

        self.notificationModel = [[NetworkModel alloc]initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"" forKey:@"resultInfo"];
        
        if (_orderNumWX.length) {
            [dic setObject:_orderNumWX forKey:@"orderNum"];
        } else {
            
            NSString *orderNumWXstr = [userDefaults objectForKey:@"orderNumWX"];
            if (orderNumWXstr.length) {
                [dic setObject:[userDefaults objectForKey:@"orderNumWX"] forKey:@"orderNum"];
            }
        }
        
        [dic setObject:@"0" forKey:@"result"];
        
        [array addObject:dic];
        
        requestData[@"list"] = array;
        requestData[@"type"] = @"WECHAT_WAP_PAY";
        requestData[@"action"] = @"2";
        [self.notificationModel registerAccountAndCall:193 andRequestData:requestData];
    }
}

#pragma mark - 苹果内付订单通知
- (void)requestNotification193:(NSString *)str{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"resultInfo"] = str;
    dic[@"result"] = @"1";
    if (_orderNum.length) {
        dic[@"orderNum"] = _orderNum;
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *orderNumStr = [userDefaults objectForKey:@"orderNum"];
        if (orderNumStr.length) {
            dic[@"orderNum"] = [userDefaults objectForKey:@"orderNum"];
        }
    }

    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dic];
    
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"list"] = array;
    requestData[@"type"] = @"IOS_IAP_PAY";
 
    self.notificationModel = [[NetworkModel alloc] initWithResponder:self];
    [self.notificationModel registerAccountAndCall:193 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.call == 191) {
      
        if (message.resultCode == 0) {
            
            LRLog(@"%@",message.responseData);
            NSArray *array = message.responseData[@"typeList"];
            if (array.count == 1) {
                
                _isFirstView = YES;
                _isSecondView = NO;
                _isThirdView = NO;
          
                NSDictionary *dict = array[0];
 
                [self.view hideLoadingImmediately];
                
                [self setupOneView:dict[@"name"] andListArray:dict[@"priList"]];
                
            } else if (array.count == 2) {
                
                _isFirstView = NO;
                _isSecondView = YES;
                _isThirdView = NO;
                NSDictionary *oneDict = array[0];
                NSDictionary *twoDict = array[1];
                
                [self.view hideLoadingImmediately];
                
                [self setupOneView:oneDict[@"name"] andListArray:oneDict[@"priList"]];
                
                [self setupSecondView:twoDict[@"name"] andListArray:twoDict[@"priList"]];
                
            } else if (array.count == 3) {
                _isFirstView = NO;
                _isSecondView = NO;
                _isThirdView = YES;
                NSDictionary *oneDict = array[0];
                NSDictionary *twoDict = array[1];
                NSDictionary *threeDict = array[2];
                
                [self.view hideLoadingImmediately];
                
                [self setupOneView:oneDict[@"name"] andListArray:oneDict[@"priList"]];
                [self setupSecondView:twoDict[@"name"] andListArray:twoDict[@"priList"]];
                [self setupThreeView:threeDict[@"name"] andListArray:threeDict[@"priList"]];
            } else if (array.count == 4) {
                _isFirstView = NO;
                _isSecondView = NO;
                _isThirdView = NO;
                NSDictionary *oneDict = array[0];
                NSDictionary *twoDict = array[1];
                NSDictionary *threeDict = array[2];
                NSDictionary *fourDict = array[3];
                
                [self.view hideLoadingImmediately];
                
                [self setupOneView:oneDict[@"name"] andListArray:oneDict[@"priList"]];
                [self setupSecondView:twoDict[@"name"] andListArray:twoDict[@"priList"]];
                [self setupThreeView:threeDict[@"name"] andListArray:threeDict[@"priList"]];
                [self setupFourView:fourDict[@"name"] andListArray:fourDict[@"priList"]];
            }
            
        } else {
            [self.view hideLoadingImmediately];
            [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
        }
        
    } else if (message.call == 101) {
        if (message.resultCode == 0) {
            [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
            
            NSString *remainSumBen = [[NSUserDefaults standardUserDefaults] objectForKey:@"remainSumDefaults"];
            
            if (!(remainSum == nil || [remainSum isEqualToString:@""] || [remainSum isEqualToString:@"(null)"])) {
                [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            } else {
                
                
                if ([remainSumBen isEqualToString:@"(null)"]) {
                    remainSumBen = [YFKeychainTool readKeychainValue:BundleIDRemainSum];
                }
                if ([remainSumBen isEqualToString:@"(null)"]) {
                    remainSumBen = @"0";
                }
                
                remainSum = remainSumBen;
            }
            _balanceView.numberLabel.text = [NSString stringWithFormat:@"%@看点",remainSum];
         
        } else {
        
            [SVProgressHUD showSuccessWithStatus:@"请检查您的网络"];
        }
    } else if (message.call == 192) {
        
        if (message.resultCode == 0) {
            if (_payStatus == 0) {//微信支付
                [SVProgressHUD dismiss];
                
                
                NSDictionary *dict = message.responseData[@"data"];

                NSURL *url = [NSURL URLWithString:dict[@"deep_link"]];
                _orderNumWX = [NSString stringWithFormat:@"%@",message.responseData[@"orderNum"]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_orderNumWX forKey:@"orderNumWX"];
                
                [[UIApplication sharedApplication] openURL:url];
       
            } else if (_payStatus == 1) {//苹果支付
                
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

                NSDictionary *dict = message.responseData[@"data"];
                
                _orderNum = [NSString stringWithFormat:@"%@",message.responseData[@"orderNum"]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_orderNum forKey:@"orderNum"];
                
                NSArray *product = [[NSArray alloc] initWithObjects:dict[@"product_id"], nil];
                
                // 是否验证productId
                if (isNeedVerifyProductId) {
                    [self requestProductData:product];
                }else {
                    SKPayment *payment = [SKPayment paymentWithProductIdentifier:product[0]];
                    [[SKPaymentQueue defaultQueue] addPayment:payment];
                }

            } else if (_payStatus == 2) {//支付宝支付
                
                [SVProgressHUD dismiss];
                NSDictionary *dict = message.responseData[@"data"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *orderNumZFB = [NSString stringWithFormat:@"%@",message.responseData[@"orderNum"]];
   
                [userDefaults setObject:orderNumZFB forKey:@"orderNumZFB"];
                
                UIWebView *webView = [[UIWebView alloc] init];
                webView.delegate = self ;
                webView.scrollView.delegate = self;
                [self.view addSubview:webView];
                
                [webView loadHTMLString:dict[@"link"] baseURL:nil];
//
                
            } else if (_payStatus == 3) {//短信支付
                [SVProgressHUD dismiss];
                NSDictionary *dict = message.responseData[@"data"];
                _dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                
                [_dataDict removeObjectForKey:@"payUrl"];
                _orderNumRDO = [NSString stringWithFormat:@"%@",dict[@"rdoOrderNum"]];
           
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_orderNumRDO forKey:@"orderNumRDO"];
                [userDefaults setObject:_dataDict forKey:@"dataDict"];
           

                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"payUrl"],_userPhoneStr]];
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            [SVProgressHUD dismiss];
        }
        
    } else if (message.call == 193) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (message.resultCode == 0) {
            if (_payStatus == 0) {//微信支付

                
                _contentPayType = @"微信支付";
                
                
                NSString *result = [NSString stringWithFormat:@"%@",message.responseData[@"result"]];
                
                if ([result isEqualToString:@"1"]) {//充值成功
                    [SVProgressHUD dismiss];
                    [self requestData:message.responseData];
                } else {//充值失败
                
                    BOOL isFirstWX = [[userDefaults objectForKey:@"WX"] boolValue];
                    if (!isFirstWX) {//第一次请求失败
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            [self updateWX];
                            [userDefaults setObject:@(YES) forKey:@"WX"];
                        });
                    } else {//第二次请求失败
                        [SVProgressHUD dismiss];
                        [self requestData:message.responseData];
                    }
                }
                
            } else if (_payStatus == 1) {//苹果支付
                NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
                _balanceView.numberLabel.text = [NSString stringWithFormat:@"%@看点",remainSum];
                [userDefaults setObject:@"10" forKey:@"payStatus"];
                _contentPayType = @"苹果支付";
                
                [[SKPaymentQueue defaultQueue] finishTransaction:_myTran];
                
            } else if (_payStatus == 2) {//支付宝支付
                LRLog(@"支付宝支付==%@",message.responseData);
                _contentPayType = @"支付宝支付";
                
                NSString *result = [NSString stringWithFormat:@"%@",message.responseData[@"result"]];
                
                if ([result isEqualToString:@"1"]) {//充值成功
                    [SVProgressHUD dismiss];
                    [userDefaults setObject:@(NO) forKey:@"ZFB"];
                    [self requestData:message.responseData];
                } else {//充值失败
                    
                    BOOL isFirstZFB = [[userDefaults objectForKey:@"ZFB"] boolValue];
                    if (isFirstZFB) {//第一次请求失败
                
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            [self updateZFBYesOrNo];
                            [userDefaults setObject:@(NO) forKey:@"ZFB"];
                        });
                    } else {//第二次请求失败
                        [SVProgressHUD dismiss];
                        [self requestData:message.responseData];
                    }
                }
            } else if (_payStatus == 3) {//短信支付
                
                [SVProgressHUD dismiss];
                _contentPayType = @"短信支付";
                [self requestData:message.responseData];
            }
            [userDefaults setObject:_contentPayType forKey:@"contentPayType"];
        } else {
            
            if (_payStatus == 2) {
                
                BOOL isFirstZFB = [[userDefaults objectForKey:@"ZFB"] boolValue];
                if (isFirstZFB) {//第一次请求失败
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self updateZFBYesOrNo];
                        [userDefaults setObject:@(NO) forKey:@"ZFB"];
                    });
                } else {//第二次请求失败
                    [SVProgressHUD dismiss];
                    [self resumainStr:@"" andSucctssOrFalse:NO];
                }
                
            } else {
                [SVProgressHUD dismiss];
                [self resumainStr:@"" andSucctssOrFalse:NO];
            }
        }
    }
}

#pragma mark - 充值结果
- (void)requestData:(NSDictionary *)dict{
//    LRLog(@"requestData----cgage   %@",dict);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *remainSum = [NSString stringWithFormat:@"%@",dict[@"remainSum"]];
    NSString *result = [NSString stringWithFormat:@"%@",dict[@"result"]];
    [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
    [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
    _balanceView.numberLabel.text = [NSString stringWithFormat:@"%@看点",remainSum];
    [userDefaults setObject:@"10" forKey:@"payStatus"];
    
    if ([result isEqualToString:@"1"]) {//充值成功
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        float remainSecond =[[_contentMoney stringByTrimmingCharactersInSet:nonDigits] floatValue];
        if (!(_contentPayType.length>0)) {
            _contentPayType = [defaults objectForKey:@"contentPayType"];
        }
        NSString *currentOrderNum = @"12345678901234";
        if ([_contentPayType isEqualToString:@"微信支付"]) {
            currentOrderNum = [defaults objectForKey:@"orderNumWX"];
        }else if ([_contentPayType isEqualToString:@"苹果支付"]){
            currentOrderNum = [defaults objectForKey:@"orderNum"];
        }else if ([_contentPayType isEqualToString:@"支付宝支付"]){
            currentOrderNum = [defaults objectForKey:@"orderNumZFB"];
        }else if ([_contentPayType isEqualToString:@"短信支付"]){
            currentOrderNum = [defaults objectForKey:@"orderNumRDO"];
        }
        if (currentOrderNum.length) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:_contentPayType forKey:@"payType"];
            [dict setValue:[NSNumber numberWithFloat:remainSecond] forKey:@"Money"];
            [MobClick event:@"RechargeInfor" attributes:dict];
        }
        [ReYunChannel setPayment:currentOrderNum paymentType:_contentPayType currentType:@"CNY" currencyAmount:remainSecond];
        [self resumainStr:remainSum andSucctssOrFalse:YES];
    } else {
        [self resumainStr:@"" andSucctssOrFalse:NO];
    }
}

#pragma mark - 视图框我知道了按钮
- (void)ensureBtn:(BOOL)successOrFalse{

    if (successOrFalse) {
        if (_isRechare) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 支付成功与否弹出视图框
- (void)resumainStr:(NSString *)resumainStr andSucctssOrFalse:(BOOL)successOrFalse{

    PromptView *promptView = [[PromptView alloc] init];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    promptView.delegate = self;
    promptView.successOrFalse = successOrFalse;
    promptView.resumainStr = resumainStr;
    promptView.userIDStr = userID;
    [promptView creatView];
}

- (void)createNavigationBarView{
    
    if (_isRechare) {
        _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _navigationBarView.backgroundColor = NavigationColor;
        [_searchTable addSubview:_navigationBarView];
    } else {
        _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [self.navigationController.navigationBar addSubview:_navigationBarView];
    }
   
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"充值"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
    titleMainLabel.tag = 101;
    titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    if (_isRechare) {
        [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 100, 0, 100));
        }];
    } else {
        [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 100, 0, 100));
        }];
    }
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton addTarget:self action:@selector(closeWindowClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:closeButton];
    if (_isRechare) {
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_navigationBarView).with.offset(19.0f);
            make.left.equalTo(_navigationBarView).with.offset(0.0f);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    } else {
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_navigationBarView).with.offset(0.0f);
            make.left.equalTo(_navigationBarView).with.offset(0.0f);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    
    [closeButton setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
}

- (void)closeWindowClick{
    
    if (_isRechare) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 创建个人余额界面
- (void)setupBalanceView{
    
    NSString *remainSum = [[NSUserDefaults standardUserDefaults] objectForKey:@"remainSumDefaults"];
    if ([remainSum isEqualToString:@"(null)"]) {
        remainSum = [YFKeychainTool readKeychainValue:BundleIDRemainSum];
    }
    
    _balanceView = [[BalanceView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 60)];
    _balanceView.delegate = self;
    [_balanceView creatView];
    if ([remainSum isEqualToString:@"null"]) {
        remainSum = @"0";
    }
    _balanceView.numberLabel.text = [NSString stringWithFormat:@"%@看点",remainSum];
    _balanceView.backgroundColor = WhiteColor;
    [_searchTable addSubview:_balanceView];
}

#pragma mark - 刷新按钮
- (void)balanceViewRefreshBtn{
    
    [SVProgressHUD showWithStatus:@"刷新余额中..." maskType:SVProgressHUDMaskTypeClear];
        
    NetworkModel *netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    NSString *UUID = [Function getDeviceId];
    requestData[@"apkversion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    requestData[@"deviceId"] = UUID;
    [netWorkModel registerAccountAndCall:101 andRequestData:requestData];

}


#pragma mark - 创建6个金额按钮
- (void)setupOneView:(NSString *)nameStr andListArray:(NSArray *)array{
    
    CGFloat sectLabelY = 0;
    
    UIView *firstView = [[UIView alloc] init];
    firstView.frame = CGRectMake(0, 0, ScreenWidth, 0);
    [_searchTable addSubview:firstView];
    
    if (_isRechare) {
        UILabel *bookLabel = [[UILabel alloc] init];
        bookLabel.frame = CGRectMake(10,  64 + 60 + 10, ScreenWidth - 20, 25);
        bookLabel.font = Font16;
        bookLabel.text = [NSString stringWithFormat:@"书名：%@",_bookName];
        bookLabel.textColor = TextColor;
        [_searchTable addSubview:bookLabel];
        
        UILabel *chapterLabel = [[UILabel alloc] init];
        if ([_priceUnit isEqualToString:@"本"]) {
            chapterLabel.text = @"整本书出售";

        } else {
            chapterLabel.text = [NSString stringWithFormat:@"章节：%@",_chapterName];
        }
        chapterLabel.font = Font16;
        CGFloat chapterLabY = CGRectGetMaxY(bookLabel.frame);
        chapterLabel.frame = CGRectMake(10, chapterLabY, ScreenWidth - 20, 25);
        chapterLabel.textColor = TextColor;
        if (_chapterName.length) {
            [_searchTable addSubview:chapterLabel];
        }
        
        UILabel *priceLabel = [[UILabel alloc] init];
        
        if (!_priceUnit.length) {
            _priceUnit = @"章";
        }
        
        if (_priceStr.length) {
            priceLabel.text = [NSString stringWithFormat:@"价格：%@看点/%@",_priceStr,_priceUnit];

        } else {
            priceLabel.text = @"价格：12看点/章";
        }
        
        priceLabel.font = Font16;
        priceLabel.textColor = TextColor;
        CGFloat priceLabelY = 0;
        if (_chapterName.length) {
            priceLabelY = CGRectGetMaxY(chapterLabel.frame);
        } else {
            priceLabelY = CGRectGetMaxY(bookLabel.frame);
        }
        
        priceLabel.frame = CGRectMake(10, priceLabelY, ScreenWidth - 20, 25);
        [_searchTable addSubview:priceLabel];
        
        sectLabelY = CGRectGetMaxY(priceLabel.frame) + 20;

    } else {
        sectLabelY = 64 + 60 + 10;
    }
    
    
    RechargeView *chargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, sectLabelY, ScreenWidth, 300)];
    chargeView.listArray = array;
    chargeView.sectStr = nameStr;
    if ([nameStr isEqualToString:@"微信"]) {
        chargeView.rechargeStatus = RechargeStatusWX;
    } else if ([nameStr isEqualToString:@"苹果内购"]) {
        chargeView.rechargeStatus = RechargeStatusAPPLE;
    } else if ([nameStr isEqualToString:@"支付宝"]) {
        chargeView.rechargeStatus = RechargeStatusZFB;
    } else if ([nameStr isEqualToString:@"短信"] || [nameStr isEqualToString:@"话费"]) {
        chargeView.rechargeStatus = RechargeStatusRDO;
    }
    
    chargeView.delegate = self;
    [chargeView creatView];
    [_searchTable addSubview:chargeView];
    CGFloat promptBtnY = CGRectGetMaxY(chargeView.promptBtn.frame) + 5;
    chargeView.frame = CGRectMake(0, sectLabelY, ScreenWidth, promptBtnY);
    self.chargeView = chargeView;

    if (_isFirstView) {
        [self bottomView];
    }
}

- (void)setupSecondView:(NSString *)nameStr andListArray:(NSArray *)array{
    
    CGFloat chargeTwoViewY = CGRectGetMaxY(self.chargeView.frame) + 15;
    RechargeView *chargeTwoView = [[RechargeView alloc] initWithFrame:CGRectMake(0, chargeTwoViewY, ScreenWidth, 300)];
    chargeTwoView.listArray = array;
    if ([nameStr isEqualToString:@"微信"]) {
        chargeTwoView.rechargeStatus = RechargeStatusWX;
    } else if ([nameStr isEqualToString:@"苹果内购"]) {
        chargeTwoView.rechargeStatus = RechargeStatusAPPLE;
    } else if ([nameStr isEqualToString:@"支付宝"]) {
        chargeTwoView.rechargeStatus = RechargeStatusZFB;
    } else if ([nameStr isEqualToString:@"短信"] || [nameStr isEqualToString:@"话费"]) {
        chargeTwoView.rechargeStatus = RechargeStatusRDO;
    }
    chargeTwoView.sectStr = nameStr;
    chargeTwoView.delegate = self;
    [chargeTwoView creatView];
    [_searchTable addSubview:chargeTwoView];
    CGFloat promptBtnY = CGRectGetMaxY(chargeTwoView.promptBtn.frame) + 5;
    chargeTwoView.frame = CGRectMake(0, chargeTwoViewY, ScreenWidth, promptBtnY);
    self.chargeTwoView = chargeTwoView;
    if (_isSecondView) {
        [self bottomView];
    }
}

- (void)setupThreeView:(NSString *)nameStr andListArray:(NSArray *)array{
    
    CGFloat chargeTwoViewY = CGRectGetMaxY(self.chargeTwoView.frame) + 15;
    RechargeView *chargeThreeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, chargeTwoViewY, ScreenWidth, 300)];
    chargeThreeView.listArray = array;
    if ([nameStr isEqualToString:@"微信"]) {
        chargeThreeView.rechargeStatus = RechargeStatusWX;
    } else if ([nameStr isEqualToString:@"苹果内购"]) {
        chargeThreeView.rechargeStatus = RechargeStatusAPPLE;
    } else if ([nameStr isEqualToString:@"支付宝"]) {
        chargeThreeView.rechargeStatus = RechargeStatusZFB;
    } else if ([nameStr isEqualToString:@"短信"] || [nameStr isEqualToString:@"话费"]) {
        chargeThreeView.rechargeStatus = RechargeStatusRDO;
    }
    chargeThreeView.sectStr = nameStr;
    chargeThreeView.delegate = self;
    [chargeThreeView creatView];
    [_searchTable addSubview:chargeThreeView];
    CGFloat promptBtnY = CGRectGetMaxY(chargeThreeView.promptBtn.frame) + 5;
    chargeThreeView.frame = CGRectMake(0, chargeTwoViewY, ScreenWidth, promptBtnY);
    self.chargeThreeView = chargeThreeView;
    
    if (_isThirdView) {
        [self bottomView];
    }
}

- (void)setupFourView:(NSString *)nameStr andListArray:(NSArray *)array{
    
    CGFloat chargeThreeViewY = CGRectGetMaxY(self.chargeThreeView.frame) + 15;
    RechargeView *chargeFourView = [[RechargeView alloc] initWithFrame:CGRectMake(0, chargeThreeViewY, ScreenWidth, 300)];
    chargeFourView.listArray = array;
    if ([nameStr isEqualToString:@"微信"]) {
        chargeFourView.rechargeStatus = RechargeStatusWX;
    } else if ([nameStr isEqualToString:@"苹果内购"]) {
        chargeFourView.rechargeStatus = RechargeStatusAPPLE;
    } else if ([nameStr isEqualToString:@"支付宝"]) {
        chargeFourView.rechargeStatus = RechargeStatusZFB;
    } else if ([nameStr isEqualToString:@"短信"] || [nameStr isEqualToString:@"话费"]) {
        chargeFourView.rechargeStatus = RechargeStatusRDO;
    }
    chargeFourView.sectStr = nameStr;
    chargeFourView.delegate = self;
    [chargeFourView creatView];
    [_searchTable addSubview:chargeFourView];
    CGFloat promptBtnY = CGRectGetMaxY(chargeFourView.promptBtn.frame) + 5;
    chargeFourView.frame = CGRectMake(0, chargeThreeViewY, ScreenWidth, promptBtnY);
    self.chargeFourView = chargeFourView;
    
    [self bottomView];
}



- (void)bottomView{

    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"温馨提示";
    promptLabel.font = Font16;
    promptLabel.textColor = TextColor;
    CGFloat promptLabelY = 0;
    if (_isFirstView) {
        promptLabelY = CGRectGetMaxY(self.chargeView.frame) + 20;
        
    } else if (_isSecondView){
        promptLabelY = CGRectGetMaxY(self.chargeTwoView.frame) + 20;
    } else if (_isThirdView) {
        promptLabelY = CGRectGetMaxY(self.chargeThreeView.frame) + 20;
    } else {
        promptLabelY = CGRectGetMaxY(self.chargeFourView.frame) + 20;
    }

    promptLabel.frame = CGRectMake(10, promptLabelY, 100, 20);
    [_searchTable addSubview:promptLabel];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    _phoneStr = @"4001180066";
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.text = [NSString stringWithFormat:@"1、充值后的阅读权限仅限本书城使用。\n2、充值书券暂不支持退费。\n3、若是充值后账户余额长时间无变化，请记录你的用户：%@后致电客服。\n4、客服电话：%@",userID,_phoneStr];
    oneLabel.textColor = LightTextColor;
    NSString *oneLabelStr = oneLabel.text;
    NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
    [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(25, 158, 215) range:NSMakeRange(oneLabel.text.length - _phoneStr.length, _phoneStr.length)];
    [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(25, 158, 215) range:NSMakeRange(oneLabel.text.length - _phoneStr.length - userID.length - 14, userID.length)];
    oneLabel.attributedText = oneLabelStrs;
    oneLabel.numberOfLines = 0;
    oneLabel.font = Font14;
    oneLabel.userInteractionEnabled = YES;
    CGFloat oneLabelY = CGRectGetMaxY(promptLabel.frame);
    oneLabel.frame = CGRectMake(10, oneLabelY, ScreenWidth - 20, 100);
    [_searchTable addSubview:oneLabel];
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    phoneBtn.frame = CGRectMake(80, 70, 120, 30);
    [phoneBtn addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [oneLabel addSubview:phoneBtn];
    self.oneLabel = oneLabel;
    _searchTable.contentSize = CGSizeMake(ScreenWidth, oneLabelY + 100 + 64);
}

#pragma mark - 拨打客服电话
- (void)phoneBtnClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:_phoneStr otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", _phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

#pragma mark - 立即充值
- (void)rechargeViewPromptBtnClick:(NSInteger)indexBtn andListArray:(NSArray *)array andRecharStatus:(RechargeStatus)rechargeStatus andRDOPhoneStr:(NSString *)phoneStr{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [SVProgressHUD showWithStatus:@"购买中，请耐心等待..." maskType:SVProgressHUDMaskTypeBlack];
    if (rechargeStatus == RechargeStatusAPPLE) {//苹果支付
        if ([SKPaymentQueue canMakePayments]) {
            
            _payStatus = 1;
            
            [userDefaults setObject:@"1" forKey:@"payStatus"];
            
            [self requestOrder192:indexBtn andListArray:array];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"不允许程序内支付"];
        }
    } else if (rechargeStatus == RechargeStatusWX) {//微信支付
        
        _payStatus = 0;
        [userDefaults setObject:@"0" forKey:@"payStatus"];
        [userDefaults setObject:@(NO) forKey:@"WX"];
        [self requestOrder192:indexBtn andListArray:array];
    } else if (rechargeStatus == RechargeStatusZFB) {//支付宝支付
        _payStatus = 2;
        [userDefaults setObject:@"2" forKey:@"payStatus"];
        [self requestOrder192:indexBtn andListArray:array];
    } else if (rechargeStatus == RechargeStatusRDO) {//短信
        _payStatus = 3;
        [userDefaults setObject:@"3" forKey:@"payStatus"];
        _userPhoneStr = phoneStr;
        [self requestOrder192:indexBtn andListArray:array];
    }
    
}

#pragma mark - 去苹果服务器验证productIdentifier
- (void)requestProductData:(NSArray *)array{

    NSSet *nsset = [NSSet setWithArray:array];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

#pragma mark - SKProductsRequestDelegate Protocol
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSArray *product = response.products;
    if ([product count] == 0) {
        [SVProgressHUD dismiss];
        return;
    }

    // 添加到支付队列
    SKPayment *payment = [SKPayment paymentWithProduct:product[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKRequestDelegate Protocol
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

#pragma mark - SKPaymentTransactionObserver Protocol
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing: // 支付中
                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred: // 推迟
                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed: // 支付失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:  // 完成
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored: // 恢复
                [self restoreTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@",
                      @(transaction.transactionState));
            break; }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Transaction:%@被移除", obj.transactionIdentifier);
    }];
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    NSLog(@"%@", error.userInfo);
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
    
}

#pragma mark - 处理支付状态

- (void)showTransactionAsInProgress:(SKPaymentTransaction *)transaction deferred:(BOOL)deferred {
    
    if (deferred) {
        // Update your UI to reflect the deferred status, and wait to be called again.
        NSLog(@"推迟支付：%@", transaction.payment.productIdentifier);
    }else {
        // Update your UI to reflect the in-progress status, and wait to be called again.
        NSLog(@"正在支付：%@", transaction.payment.productIdentifier);
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"支付失败：%@", transaction.payment.productIdentifier);
    switch (transaction.error.code) {
        case SKErrorUnknown:
            NSLog(@"error: 未知错误.");
            break;
        case SKErrorClientInvalid:
            NSLog(@"error: 客户端不允许执行尝试的操作.");
            break;
        case SKErrorPaymentCancelled:
            NSLog(@"error: 用户取消了支付请求.");
            break;
        case SKErrorPaymentInvalid:
            NSLog(@"error: 支付参数无法被苹果AppStore识别.");
            break;
        case SKErrorPaymentNotAllowed:
            NSLog(@"error: 用户不允许授权支付.");
            break;
        case SKErrorStoreProductNotAvailable:
            NSLog(@"error: 请求的商品在商店中不可购买.");
            break;
        default:
            break;
    }
    
    _myTran = transaction;
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    _myTran = transaction;

    NSLog(@"完成支付：%@", transaction.payment.productIdentifier);
    
    [SVProgressHUD dismiss];
    
    /*
     下面的代码用了废弃的方法transactionReceipt来获取凭据，有其原因的：
     1. 服务端要对凭据进行解析，这样取出来的凭据是文本格式
     2. 我们的支付流程中有个orderNum订单号，发货只支持单笔交易发货。而这样取出来的凭据，就是单笔交易的。
     
     为什么要对凭据进行urlencode编码，而不直接发base64文本给服务器？
     服务端那边的流程是：先urldecode，再base64发给苹果接口验证。
     */
    
    NSString *receiptData = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    receiptData = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)receiptData, NULL, CFSTR(":/?#[]@!$&'()*+,;%="), kCFStringEncodingUTF8);
    
    [self requestNotification193:receiptData];

}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    // Restore the previously purchased functionality.
    // 处理恢复购买的逻辑
    NSLog(@"恢复购买：%@", transaction.payment.productIdentifier);
    
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.view showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.view hideLoadingImmediately];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];

    if ([urlStr hasPrefix:@"alipay://alipayclient"]) {
        
        [[UIApplication sharedApplication] openURL:url];
        [self.view hideLoadingImmediately];
        return NO;
        
    } else if ([urlStr hasPrefix:@"https://mclient.alipay.com/cashier/mobilepay.htm"]) {
        
        ZFBViewController *zfbVC = [[ZFBViewController alloc] init];
        zfbVC.urlStr = urlStr;
        
        if (self.navigationController) {
            [self.navigationController pushViewController:zfbVC animated:YES];
        } else {
            zfbVC.isRechare = YES;
            [self presentViewController:zfbVC animated:YES completion:nil];
        }
      
        
        [self.view hideLoadingImmediately];
        return NO;
        
    }
    return YES;
}

@end
