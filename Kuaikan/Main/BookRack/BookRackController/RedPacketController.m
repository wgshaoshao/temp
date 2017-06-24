//
//  RedPacketController.m
//  Kuaikan
//
//  Created by 少少 on 17/2/13.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "RedPacketController.h"

@interface RedPacketController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *navigationBarView;
@end

@implementation RedPacketController
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
    
    //创建视图页面
    [self initSubviews];
}

- (void)initSubviews{
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self ;
    _webView.scrollView.delegate = self;
    _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [self.view addSubview:_webView];
    
    NSString *urlStr = _urlStr;
    if ([_urlStr hasPrefix:@"http"]) {
        urlStr = _urlStr;
    } else {
        urlStr = [NSString stringWithFormat:@"http://%@",_urlStr];
    }

    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_webView loadHTMLString:_urlStr baseURL:nil];
    [_webView loadRequest:request];
    
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
    titleMainLabel.text = _titleStr;
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

@end