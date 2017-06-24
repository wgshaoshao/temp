//
//  H5ViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/6/16.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "H5ViewController.h"
#import "RechargeController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BookDetailController.h"

@protocol JSObjcDelegate <JSExport>

- (void)bookStoreClick:(NSString *)srcid;

@end

@interface H5ViewController ()<UIWebViewDelegate,UIScrollViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) JSContext *jsContent;

@end

@implementation H5ViewController

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
    
    //创建视图页面
    [self initSubviews];
}

- (void)initSubviews{
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self ;
    _webView.scrollView.delegate = self;
    _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [self.view addSubview:_webView];

    NSString *urlStr = nil;
    if ([_urlStr hasPrefix:@"http"]) {
        urlStr = _urlStr;
    } else {
        urlStr = [NSString stringWithFormat:@"http://%@",_urlStr];
    }
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
    titleMainLabel.text = _titleName;
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

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [self.view showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self.view hideLoadingImmediately];
    
    _jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContent[@"bookSotre"] = self;
    _jsContent.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    
}
//
//- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL *url = request.URL;
//    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
//    LRLog(@"____%@",urlStr);
//    if ([urlStr hasPrefix:@"alipay://alipayclient"]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//    return YES;
//}

#pragma mark - H5页面点击跳转
- (void)bookStoreClick:(NSString *)srcid{
    
    WEAKSELF
    if (srcid.length) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"跑马灯、活动";
            bookDetailVC.bookID = srcid;
            bookDetailVC.enterIndex = 100;
            [weakSelf.navigationController pushViewController:bookDetailVC animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RechargeController *rechargeVC = [[RechargeController alloc] init];
            [weakSelf.navigationController pushViewController:rechargeVC animated:YES];
        });
    }
    
}


@end
