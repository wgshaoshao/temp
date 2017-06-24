//
//  LoginController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/10.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "LoginController.h"
#import "ForgetPswController.h"

@interface LoginController ()

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *pswordField;

@end

@implementation LoginController

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
    
    [self setupPhoneTextField];
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
    titleMainLabel.text = [NSString stringWithFormat:@"登录快看账户"];
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
        make.top.equalTo(_navigationBarView).with.offset(0.0f);
        make.left.equalTo(closeButton.mas_right).with.offset(0.0f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
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

- (void)setupPhoneTextField{
    
    UIView *numberView = [[UIView alloc] init];
    numberView.frame = CGRectMake(0, 0, 10, 44);
    
    UITextField *numberField = [[UITextField alloc] init];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addOneTextField:numberField fieldFrame:CGRectMake(10, 64 + 20, ScreenWidth - 20, 44) title:@"请输入您的手机号"];
    numberField.leftView = numberView;
    self.numberField = numberField;

    UIView *pswordView = [[UIView alloc] init];
    pswordView.frame = CGRectMake(0, 0, 10, 44);
    
    UITextField *pswordField = [[UITextField alloc] init];
    CGFloat pswFiledY = CGRectGetMaxY(numberField.frame) + 15;
    [self addOneTextField:pswordField fieldFrame:CGRectMake(10, pswFiledY, ScreenWidth - 20, 44) title:@"请输入您的密码"];
    pswordField.leftView = pswordView;
    pswordField.secureTextEntry = YES;
    self.pswordField = pswordField;
    
    CGFloat loginBtnY = CGRectGetMaxY(pswordField.frame) + 20;
    UIButton *loginBtn = [[UIButton alloc] init];
    [self.view addSubview:loginBtn];
    loginBtn.frame = CGRectMake(10, loginBtnY, ScreenWidth - 20, 44);
    loginBtn.backgroundColor = LineLabelColor;
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = GreenColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font16;
    
    CGFloat forgetBtnY = CGRectGetMaxY(loginBtn.frame) + 10;
    UIButton *forgetBtn = [[UIButton alloc] init];
    [self.view addSubview:forgetBtn];
    forgetBtn.frame = CGRectMake(ScreenWidth - 70, forgetBtnY, 60, 20);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = Font14;
    [forgetBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 忘记密码
- (void)forgetBtnClick{

    ForgetPswController *forgetPswVC = [[ForgetPswController alloc] init];
    [self.navigationController pushViewController:forgetPswVC animated:YES];
}


@end
