//
//  FreeH5Controller.m
//  Kuaikan
//
//  Created by 少少 on 16/12/8.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "FreeH5Controller.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FreeThreeView.h"
#import "BookDetailController.h"

@protocol JSObjcDelegate <JSExport>

- (void)bookStoreClick:(NSString *)srcid;

@end

@interface FreeH5Controller ()<JSObjcDelegate,UIWebViewDelegate,UIScrollViewDelegate,FreeThreeViewDelegate>
@property (nonatomic, strong) JSContext *jsContent;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIWebView *twoWebView;
@property (nonatomic, strong) UIWebView *threeWebView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) FreeThreeView *freeThreeView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) NSInteger scrollIndex;

@end

@implementation FreeH5Controller

- (UIButton *)button{

    if (_button == nil) {
        _button = [[UIButton alloc] init];
    }
    return _button;
}

- (FreeThreeView *)freeThreeView{

    if (_freeThreeView == nil) {
        _freeThreeView = [[FreeThreeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _freeThreeView.delegate = self;
        [_freeThreeView creatFoureBtn];
    }
    return _freeThreeView;
}

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49)];
        _webView.delegate = self ;
        _webView.scrollView.delegate = self;

        
    }
    
    return _webView;
}

- (UIWebView *)twoWebView{
    
    if (_twoWebView == nil) {
        
        _twoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64 - 49)];
        _twoWebView.delegate = self ;
        _twoWebView.scrollView.delegate = self;

    }
    
    return _twoWebView;
}

- (UIWebView *)threeWebView{
    
    if (_threeWebView == nil) {
        
        _threeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - 64 - 49)];
        _threeWebView.delegate = self ;
        _threeWebView.scrollView.delegate = self;
 
    }
    
    return _threeWebView;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
//    [self.freeThreeView removeFromSuperview];
    [_navigationBarView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self createNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.freeThreeView];
 
    self.view.backgroundColor = WhiteColor;
    //创建视图页面
    [self initSubviews];
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
    titleMainLabel.text = @"今日限免";
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

- (void)initSubviews{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 44.f, ScreenWidth, ScreenHeight)];
    _scrollView.pagingEnabled = YES ;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    [self.view addSubview:_scrollView];
    
    NSURL *url = [NSURL URLWithString:@"http://m.kkyd.cn/ios_free/ios_limitFree_other.html?blockId=7"] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [_scrollView addSubview:self.webView];
    
    
    NSURL *twoUrl = [NSURL URLWithString:@"http://m.kkyd.cn/ios_free/ios_limitFree_boy.html?blockId=171"] ;
    NSURLRequest *twoRequest = [NSURLRequest requestWithURL:twoUrl];
    [self.twoWebView loadRequest:twoRequest];
    [_scrollView addSubview:self.twoWebView];
    
    NSURL *threeUrl = [NSURL URLWithString:@"http://m.kkyd.cn/ios_free/ios_limitFree_girl.html?blockId=170"];
    NSURLRequest *threeRequest = [NSURLRequest requestWithURL:threeUrl];
    [self.threeWebView loadRequest:threeRequest];
    [_scrollView addSubview:self.threeWebView];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView){
        CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
        NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;

        if (page == 0) {
            self.button.tag = 10;
        } else if (page == 1){
            self.button.tag = 11;
        } else if (page == 2){
            self.button.tag = 12;
        }
        
        [self freeThreeViewButton:self.button];
    }
}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [SVProgressHUD showWithStatus:@"加载今日限免中..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [SVProgressHUD showWithStatus:@"网络出现错误，加载失败"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    
    _jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContent[@"bookSotre"] = self;
    _jsContent.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    
}



#pragma mark - 精选、男生、女生
- (void)freeThreeViewButton:(UIButton *)button{

    self.freeThreeView.selectLabel.hidden = YES;
    self.freeThreeView.boyLabel.hidden = YES;
    self.freeThreeView.girlLabel.hidden = YES;
    
    NSString *URLstr = @"";
    if (button.tag == 10) {//精选firstBtn
        
        self.freeThreeView.selectLabel.hidden = NO;
        URLstr = @"http://m.kkyd.cn/ios_free/ios_limitFree_other.html?blockId=7";
        
    } else if (button.tag == 11) {//男生secondBtn
        
        self.freeThreeView.boyLabel.hidden = NO;
        URLstr = @"http://m.kkyd.cn/ios_free/ios_limitFree_boy.html?blockId=171";
        
    } else if (button.tag == 12) {//女生threeBtn
        
        self.freeThreeView.girlLabel.hidden = NO;
        URLstr = @"http://m.kkyd.cn/ios_free/ios_limitFree_girl.html?blockId=170";
    }
    
    if (button.tag == 10) {

        [_scrollView setContentOffset:CGPointZero animated:YES];
        
        
    } else if (button.tag == 11) {
        
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        
    } else if (button.tag == 12) {
        
        [_scrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:YES];
    }
}



#pragma mark - H5页面点击跳转
- (void)bookStoreClick:(NSString *)srcid{
    
    if (srcid.length) {//有bookID
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"Free";
            bookDetailVC.bookID = srcid;
            bookDetailVC.enterIndex = 100;
            [weakSelf.navigationController pushViewController:bookDetailVC animated:YES];
        });
    }
}

- (void)closeWindowClick{
    
    [SVProgressHUD dismiss];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
