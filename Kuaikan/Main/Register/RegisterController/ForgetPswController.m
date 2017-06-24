//
//  ForgetPswController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ForgetPswController.h"
#import "ResetPswController.h"

@interface ForgetPswController ()

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation ForgetPswController

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
    
    self.view.backgroundColor = BackViewColor;
    
    [self setupTwoView];
}

- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"忘记密码"];
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
    
    UIButton *backTopBtn = [[UIButton alloc] init];
    [backTopBtn addTarget:self action:@selector(backTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:backTopBtn];
    [backTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBarView).with.offset(10.0f);
        make.left.equalTo(closeButton.mas_right).with.offset(15.0f);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [backTopBtn setImage:[UIImage imageNamed:@"lodin_icon_cancel_-normal"] forState:UIControlStateNormal];
}

#pragma mark - 返回上一级
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回最顶层
- (void)backTopBtnClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupTwoView{

    UIView *codeView = [[UIView alloc] init];
    [self.view addSubview:codeView];
    codeView.frame = CGRectMake(0, 64, (ScreenWidth / 2), 90);
    codeView.backgroundColor = WhiteColor;
    
    UILabel *oneLabel = [[UILabel alloc] init];
    [codeView addSubview:oneLabel];
    oneLabel.frame = CGRectMake((ScreenWidth - 40) / 4, 20, 20, 20);
    oneLabel.layer.masksToBounds = YES; //没这句话它圆不起来
    oneLabel.layer.cornerRadius = 10.0; //设置图片圆角的尺度
    oneLabel.text = @"1";
    oneLabel.font = Font14;
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.textColor = WhiteColor;
    oneLabel.backgroundColor = NavigationColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [codeView addSubview:titleLabel];
    titleLabel.text = @"安全验证";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font16;
    CGFloat titleLabY = CGRectGetMaxY(oneLabel.frame) + 10;
    titleLabel.frame = CGRectMake(0, titleLabY, ScreenWidth / 2, 25);
    
    UIView *pswView = [[UIView alloc] init];
    [self.view addSubview:pswView];
    pswView.frame = CGRectMake(ScreenWidth / 2, 64, (ScreenWidth / 2), 90);
    pswView.backgroundColor = LineLabelColor;
    
    UILabel *twoLabel = [[UILabel alloc] init];
    [pswView addSubview:twoLabel];
    twoLabel.frame = CGRectMake((ScreenWidth - 40) / 4, 20, 20, 20);
    twoLabel.layer.masksToBounds = YES; //没这句话它圆不起来
    twoLabel.layer.cornerRadius = 10.0; //设置图片圆角的尺度
    twoLabel.text = @"2";
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.textColor = WhiteColor;
    twoLabel.font = Font14;
    twoLabel.backgroundColor = ADColor(200, 200, 200);
    
    UILabel *pswLabel = [[UILabel alloc] init];
    [pswView addSubview:pswLabel];
    CGFloat pswLabelY = CGRectGetMaxY(twoLabel.frame) + 10;
    pswLabel.frame = CGRectMake(0, pswLabelY, ScreenWidth / 2, 25);
    pswLabel.font = Font16;
    pswLabel.text = @"重置密码";
    pswLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *numberView = [[UIView alloc] init];
    numberView.frame = CGRectMake(0, 0, 10, 44);
    
    UITextField *numberField = [[UITextField alloc] init];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    CGFloat numberFieldY = CGRectGetMaxY(pswView.frame) + 40;
    [self addOneTextField:numberField fieldFrame:CGRectMake(10, numberFieldY, ScreenWidth - 20, 44) title:@"请输入您的手机号"];
    numberField.leftView = numberView;
    self.numberField = numberField;
    
    UIView *twocodeView = [[UIView alloc] init];
    twocodeView.frame = CGRectMake(0, 0, 10, 44);
    
    UITextField *codeField = [[UITextField alloc] init];
    CGFloat codeFiledY = CGRectGetMaxY(numberField.frame) + 20;
    [self addOneTextField:codeField fieldFrame:CGRectMake(10, codeFiledY, ScreenWidth - 175, 44 ) title:@"请输入验证码"];
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.leftView = twocodeView;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [self.view addSubview:sendBtn];
    //    [sendBtn setBackgroundImage:[UIImage imageNamed:@"发送验证码"] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(ScreenWidth - 155, codeFiledY, 141, 44);
    //    sendBtn.layer.cornerRadius = 2.0;
    //    [sendBtn.layer setMasksToBounds:YES];
    //    sendBtn.backgroundColor = LineLabelColor;
    sendBtn.titleLabel.font = Font14;
    [sendBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.backgroundColor = ADColor(82, 194, 109);
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn;
    
    CGFloat loginBtnY = CGRectGetMaxY(sendBtn.frame) + 20;
    UIButton *loginBtn = [[UIButton alloc] init];
    [self.view addSubview:loginBtn];
    loginBtn.frame = CGRectMake(10, loginBtnY, ScreenWidth - 20, 44);
    loginBtn.backgroundColor = LineLabelColor;
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = ADColor(82, 194, 109);
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font15;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 进入重置密码页面
- (void)loginBtnClick{

    ResetPswController *resetPswVC = [[ResetPswController alloc] init];
    [self.navigationController pushViewController:resetPswVC animated:YES];
}

//创建一个textField
- (void)addOneTextField:(UITextField *)textField fieldFrame:(CGRect)frame title:(NSString *)title{
    
    textField.font = Font16;
    textField.frame = frame;
    textField.placeholder = title;
    textField.layer.cornerRadius = 3.0;
    [textField.layer setMasksToBounds:YES];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = LineLabelColor.CGColor;
    [self.view addSubview:textField];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - 发送验证码
- (void)sendBtnClick{
    
    if (self.numberField.text.length) {
        BOOL isNumber = [self validateTel:self.numberField.text];
        if (isNumber) {
            
            [self performSelector:@selector(updateButtonTitle:) withObject:@"60" afterDelay:0];
            
            //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //        NSMutableDictionary *params = [NSMutableDictionary dictionary];
            //        params[@"mobilePhoneEncrypt"] = [RAESCrypt encrypt:self.numberField.text];
            //
            //        [manager POST:[AidongAPI regist_sendCode] parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            //
            //            NSNumber *code = responseObject[@"code"];
            //
            //            if ([code isEqualToNumber:@(1)]) {
            //                NSNumber *authCode = responseObject[@"result"];
            //                NSNumberFormatter *numberFor = [[NSNumberFormatter alloc] init];
            //                self.authCode = [numberFor stringFromNumber:authCode];
            //
            //                [SVProgressHUD showImage:nil status:@"验证码已发送，请注意查收"];
            //            } else {
            //                NSString *msg = responseObject[@"msg"];
            //                [SVProgressHUD showImage:nil status:msg];
            //            }
            //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        }];
        } else {
            //        [SVProgressHUD showErrorWithStatus:@"请确认您输入的手机号正确"];
            [self.view showAlertTextWith:@"请输入正确的手机号码"];
        }
        
    } else {
        [self.view showAlertTextWith:@"请输入您的电话号码"];
    }
}

//发送按钮变成倒计时
-(void)updateButtonTitle:(NSString *)str{
    
    float aflote=[str floatValue];
    self.sendBtn.userInteractionEnabled = NO;
    [self.sendBtn setBackgroundImage:nil forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = LineLabelColor;
    [self.sendBtn setTitle:[NSString stringWithFormat:@"%.0f秒",aflote] forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = Font14;
    if (aflote <= 1) {
        [self performSelector:@selector(yanZM_date) withObject:nil afterDelay:1.0];
    }else{
        aflote --;
        [self performSelector:@selector(updateButtonTitle:) withObject:[NSString stringWithFormat:@"%f",aflote] afterDelay:1.0];
    }
}

-(void)yanZM_date{
    
    [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"发送验证码"] forState:UIControlStateNormal];
    [self.sendBtn setTitle:nil forState:UIControlStateNormal];
    self.sendBtn.userInteractionEnabled=YES;
}


//判断是否为电话号码
- (BOOL)validateTel:(NSString *)candidate{
    
    NSString *telRegex = @"^1[0-9]\\d{9}$";
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3}\\d{7,8}$)";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telRegex];
    NSPredicate *PHSP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    if ([telTest evaluateWithObject:candidate] == YES || [PHSP evaluateWithObject:candidate] == YES) {
        return YES;
    } else{
        return NO;
    }
}

@end
