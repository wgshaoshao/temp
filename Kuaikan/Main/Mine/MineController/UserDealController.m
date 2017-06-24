//
//  UserDealController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "UserDealController.h"

@interface UserDealController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation UserDealController

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
    
    //创建视图页面
    [self initSubviews];
}


- (void)initSubviews{
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self ;
    _webView.scrollView.delegate = self;
    _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [self.view addSubview:_webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"htm"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    // 通过baseURL的方式加载的HTML
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    [_webView loadHTMLString:htmlCont baseURL:baseURL];
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
    titleMainLabel.text = [NSString stringWithFormat:@"用户使用协议"];
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

@end
