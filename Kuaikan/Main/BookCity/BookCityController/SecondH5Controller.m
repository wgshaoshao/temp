//
//  SecondH5Controller.m
//  Kuaikan
//
//  Created by 少少 on 16/7/21.
// Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SecondH5Controller.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BookDetailController.h"

@protocol JSObjcDelegate <JSExport>

- (void)bookStoreClick:(NSString *)srcid;

@end

@interface SecondH5Controller ()<UIWebViewDelegate,UIScrollViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) JSContext *jsContent;

@end

@implementation SecondH5Controller

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

    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
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
    if (_titleStr.length) {
        titleMainLabel.text = _titleStr;
    }else{
        titleMainLabel.text = @"书城详情";
    }
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 44, 0, 44));
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

#pragma mark - H5页面点击跳转
- (void)bookStoreClick:(NSString *)srcid{
    
    if (srcid.length) {//有bookID
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0)) ;
            }];
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            if (_titleStr.length) {
                bookDetailVC.sourceFrom = _titleStr;
            }
            bookDetailVC.enterIndex = 100;
            bookDetailVC.bookID = srcid;
            [weakSelf.navigationController pushViewController:bookDetailVC animated:YES];
        });
    }
}


#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.view showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.view hideLoadingImmediately];
    
    _jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContent[@"bookSotre"] = self;
    _jsContent.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

@end
