//
//  ResetPswController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/12.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ResetPswController.h"

@interface ResetPswController ()
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation ResetPswController
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
    codeView.backgroundColor = LineLabelColor;
    
    UILabel *oneLabel = [[UILabel alloc] init];
    [codeView addSubview:oneLabel];
    oneLabel.frame = CGRectMake((ScreenWidth - 40) / 4, 20, 20, 20);
    oneLabel.layer.masksToBounds = YES; //没这句话它圆不起来
    oneLabel.layer.cornerRadius = 10.0; //设置图片圆角的尺度
    oneLabel.text = @"1";
    oneLabel.font = Font14;
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.textColor = WhiteColor;
    oneLabel.backgroundColor = ADColor(200, 200, 200);
    
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
    pswView.backgroundColor = WhiteColor;
    
    UILabel *twoLabel = [[UILabel alloc] init];
    [pswView addSubview:twoLabel];
    twoLabel.frame = CGRectMake((ScreenWidth - 40) / 4, 20, 20, 20);
    twoLabel.layer.masksToBounds = YES; //没这句话它圆不起来
    twoLabel.layer.cornerRadius = 10.0; //设置图片圆角的尺度
    twoLabel.text = @"2";
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.textColor = WhiteColor;
    twoLabel.font = Font14;
    twoLabel.backgroundColor = NavigationColor;
    
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
    
    UIView *ensureView = [[UIView alloc] init];
    ensureView.frame = CGRectMake(0, 0, 10, 44);
    
    UITextField *ensureField = [[UITextField alloc] init];
    ensureField.keyboardType = UIKeyboardTypeNumberPad;
    CGFloat ensureFieldY = CGRectGetMaxY(numberField.frame) + 20;
    [self addOneTextField:ensureField fieldFrame:CGRectMake(10, ensureFieldY, ScreenWidth - 20, 44) title:@"重新输入密码"];
    ensureField.leftView = ensureView;
//    self.numberField = numberField;
    
    CGFloat loginBtnY = CGRectGetMaxY(ensureField.frame) + 20;
    UIButton *loginBtn = [[UIButton alloc] init];
    [self.view addSubview:loginBtn];
    loginBtn.frame = CGRectMake(10, loginBtnY, ScreenWidth - 20, 44);
    loginBtn.backgroundColor = LineLabelColor;
    [loginBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = ADColor(82, 194, 109);
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font15;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)loginBtnClick{

}


@end
