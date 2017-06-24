//
//  UserHelpController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "UserHelpController.h"

@interface UserHelpController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UserHelpController



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
    
    NSURL *url = [NSURL URLWithString:@"http://m.kkyd.cn/ios/index.html"];
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
    titleMainLabel.text = [NSString stringWithFormat:@"用户帮助"];
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
}

- (void)closeWindowClick{
    
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [SVProgressHUD showWithStatus:@"加载用户帮助..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [SVProgressHUD showWithStatus:@"网络出现错误，加载失败"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    
}

@end
