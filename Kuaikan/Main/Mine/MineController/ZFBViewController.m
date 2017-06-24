//
//  ZFBViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/11/15.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ZFBViewController.h"

@interface ZFBViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *navigationBarView;
@end

@implementation ZFBViewController

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"ZFB"];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    
    if (_isRechare) {
        _webView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    } else {
        _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
   
    
    [self.view addSubview:_webView];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

- (void)createNavigationBarView{
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    if (_isRechare) {
        _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _navigationBarView.backgroundColor = NavigationColor;
        [self.view addSubview:_navigationBarView];
    } else {
        _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [self.navigationController.navigationBar addSubview:_navigationBarView];
    }
    
  
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = @"支付宝支付";
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
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


#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.view showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.view hideLoadingImmediately];
}

//- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
////    LRLog(@"%@")
//    NSURL *url = request.URL;
//    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
//    LRLog(@"%@",urlStr);
//    if ([urlStr hasPrefix:@"alipay://alipayclient"]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//    return YES;
//}

@end
