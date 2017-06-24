//
//  PersonalSignController.m
//  爱动
//
//  Created by AiDong on 16/1/7.
//  Copyright © 2016年 aidong. All rights reserved.
//

#import "PersonalSignController.h"

@interface PersonalSignController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIView *navigationBarView;

@end

@implementation PersonalSignController


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
    // Do any additional setup after loading the view.
    self.view.backgroundColor =WhiteColor ;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    
    [self initSubviews];
}

#pragma mark - 设置导航条

- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"修改昵称"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
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

#pragma mark - 返回上一级
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改事件
- (void)buttonClick{
    
    if (self.textField.isFirstResponder == YES) {
        [self.textField resignFirstResponder];
    }
        
    if (self.textField.text.length > 0) {
    }
    else{
    }
}

#pragma mark - subview
- (void)initSubviews{
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.frame = CGRectMake(0, 64, ScreenWidth, 20);
    _promptLabel.text = @"昵称不能超过10个字符，请重新输入";
    _promptLabel.font = Font12;
    _promptLabel.hidden = YES;
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.backgroundColor = ADColor(230, 230, 230);
    _promptLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_promptLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.backgroundColor = WhiteColor ;
    _textField.font = Font15;
    _textField.placeholder = @" 输入您的昵称（最多10个字）";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
    _textField.text = self.content ;
    _textField.delegate = self ;
    _textField.borderStyle = UITextBorderStyleRoundedRect ;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100) ;
        make.height.equalTo(@40) ;
        make.left.equalTo(self.view.mas_left).offset(15) ;
        make.right.equalTo(self.view.mas_right).offset(-15) ;
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    button.backgroundColor = ADColor(230, 230, 230);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = Font14;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(20) ;
        make.height.equalTo(@40) ;
        make.left.equalTo(self.view.mas_left).offset(60) ;
        make.right.equalTo(self.view.mas_right).offset(-60) ;
    
    }];
}

#pragma mark - UITextField delegate method

- (void)textFieldDidChange:(UITextField *)tf{

    if (tf.text.length > 10) {
        _promptLabel.hidden = NO;
        tf.text = [tf.text substringToIndex:10];
    } else {
        _promptLabel.hidden = YES;
    }
}

#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end
