//
//  BookCityHomeController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookCityHomeController.h"
#import "SearchMainController.h"
#import "SuspensionView.h"
#import "OneResultController.h"
#import "SecondH5Controller.h"
#import "AFNetworking.h"
#import "Function.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BookDetailController.h"
#import "AFNetworking.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "MJRefresh.h"

@protocol JSObjcDelegate <JSExport>

- (void)bookStoreClick:(NSString *)srcid;

@end

@interface BookCityHomeController ()<UIWebViewDelegate,UIScrollViewDelegate,SuspensionViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIWebView *twoWebView;
@property (nonatomic, strong) UIWebView *threeWebView;
@property (nonatomic, strong) UIWebView *fourWebView;
@property (nonatomic, strong) SuspensionView *suspensionView;
@property (nonatomic, strong) JSContext *jsContent;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, assign) NSInteger scrollIndex;
@property (nonatomic, strong) UIButton *myButton;
@property (nonatomic, assign) BOOL isHeadRefresh;



@end

@implementation BookCityHomeController

- (UIButton *)myButton{

    if (_myButton == nil) {
        _myButton = [[UIButton alloc] init];
    }
    return _myButton;
}

- (SuspensionView *)suspensionView{

    if (_suspensionView == nil) {
        _suspensionView = [[SuspensionView alloc] initWithFrame:CGRectMake(0, 0, (4 * ScreenWidth) / 5, 44)];
        _suspensionView.delegate = self;
        
        [_suspensionView creatFoureBtn];
        
    }
    return _suspensionView;
}

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 -64)];
        _webView.delegate = self ;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = BackViewColor;
//        _webView.scrollView.bounces = NO;
        [_scrollView addSubview:_webView];
    }
    
    return _webView;
}

- (UIWebView *)twoWebView{
    
    if (_twoWebView == nil) {

        _twoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 49 -64)];
        _twoWebView.delegate = self ;
        _twoWebView.backgroundColor = BackViewColor;
        _twoWebView.scrollView.delegate = self;
        [_scrollView addSubview:_twoWebView];
    }
    
    return _twoWebView;
}

- (UIWebView *)threeWebView{
    
    if (_threeWebView == nil) {
  
        _threeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - 49 -64)];
        _threeWebView.delegate = self ;
        _threeWebView.backgroundColor = BackViewColor;
        _threeWebView.scrollView.delegate = self;
        [_scrollView addSubview:_threeWebView];
    }
    
    return _threeWebView;
}

- (UIWebView *)fourWebView{
    
    if (_fourWebView == nil) {
 
        _fourWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 3, 0, ScreenWidth, ScreenHeight - 49 -64)];
        _fourWebView.delegate = self ;
        _fourWebView.backgroundColor = BackViewColor;
        _fourWebView.scrollView.delegate = self;
        [_scrollView addSubview:_fourWebView];
    }
    
    return _fourWebView;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createNavigationBarView];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_searchBtn removeFromSuperview];
    [_imageView removeFromSuperview];
    [self.view hideLoadingImmediately];
    [SVProgressHUD dismiss];
    [self.suspensionView removeFromSuperview];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
 
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _isFirst = NO;

//    FreeH5Controller *free = [[FreeH5Controller alloc] init];
//    [self.navigationController pushViewController:free animated:YES];

    //创建视图页面
    [self initSubviews];
    
    [self requestCityPage211];
    
}



#pragma mark - 下放书城page页
- (void)requestCityPage211{
    
    self.netWorkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@""] = @"";
    [self.netWorkModel registerAccountAndCall:211 andRequestData:requestData];
}


- (void)initSubviews{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, ScreenHeight)];
    _scrollView.pagingEnabled = YES ;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 4, 0);
    [self.view addSubview:_scrollView];

    NSString *urlStr = [NSString stringWithFormat:@"%@/asg/portal/view/index.html",SITE_URL];
    NSURL *url = [NSURL URLWithString:urlStr] ;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.resultCode == 0) {
        _result = message.responseData[@"result"];
   
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        for (int i = 0; i < _result.count; i ++) {
            NSDictionary *dict = _result[i];
            if (i == 0) {
                
                [userDefaults setObject:dict[@"name"] forKey:@"firstName"];
            } else if (i == 1) {
                
                [userDefaults setObject:dict[@"name"] forKey:@"secondName"];
            } else if (i == 2) {
                
                [userDefaults setObject:dict[@"name"] forKey:@"threeName"];
            } else if (i == 3) {
                
                [userDefaults setObject:dict[@"name"] forKey:@"fourName"];
            }
        }
    }
}

#pragma mark - 记录点击的频道
- (void)setupIndex:(NSInteger)index{
    
    NSDictionary *dict = _result[index];
    NSMutableDictionary *jsonDiction = [[NSMutableDictionary alloc]init];
    NSString *urlString = dict[@"url"];
    
    [jsonDiction setObject:[AppDelegate mypublicParam] forKey:@"pub"];

    [jsonDiction setObject:@"" forKey:@"pri"];
    
    NSString *url = [NSString stringWithFormat:@"%@&json=%@",urlString,[jsonDiction jsonString]];
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)url, NULL, (CFStringRef)@"|", kCFStringEncodingUTF8 );
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{@"json":[jsonDiction jsonString]};
    [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    [manager POST:(__bridge NSString *)encodedString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    if (scrollView == _scrollView){
        CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
        NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;

        if (page == 0) {
            self.myButton.tag = 10;
        }else if (page == 1){
            self.myButton.tag = 11;
        }else if (page == 2){
            self.myButton.tag = 12;
        }else if (page == 3){
            self.myButton.tag = 13;
        }
        _isHeadRefresh = NO;
        [self suspensionViewFourBtn:self.myButton];
    }
}



#pragma mark - H5页面点击跳转
- (void)bookStoreClick:(NSString *)srcid{

    if (srcid.length) {//有bookID
        WEAKSELF
        
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            

            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"BookStore";//标识一下书籍来源
            bookDetailVC.bookID = srcid;
            [weakSelf.navigationController pushViewController:bookDetailVC animated:YES];
        });
    }
}

#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    _searchBtn = [[UIButton alloc] init];
    _searchBtn.frame = CGRectMake((ScreenWidth * 4) / 5, 0, ScreenWidth / 5, 44);
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake((ScreenWidth - 110)/10, 11, 22, 22);
    _imageView.image = [UIImage imageNamed:@"common_nav_icon_n2@x"];
    [_searchBtn addSubview:_imageView];
    
    [self.navigationController.navigationBar addSubview:_searchBtn];
    
    [self.navigationController.navigationBar addSubview:self.suspensionView];
}


#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self.view showLoadingView];
    
    });
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.view hideLoadingImmediately];
    
    if (_scrollIndex == 0) {

        [_webView.scrollView headerEndRefreshing];
        
    } else if (_scrollIndex == 1) {
   
        [_twoWebView.scrollView headerEndRefreshing];
    } else if (_scrollIndex == 2) {
        
        [_threeWebView.scrollView headerEndRefreshing];
        
    } else if (_scrollIndex == 3) {
        
        [_fourWebView.scrollView headerEndRefreshing];
        
    }
    
    _isShow = YES;
    
    _jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContent[@"bookSotre"] = self;
    _jsContent.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self.view hideLoadingImmediately];
    [SVProgressHUD showWithStatus:@"网络出现错误，加载失败"];
    
    if (_scrollIndex == 0) {
        
        [_webView.scrollView headerEndRefreshing];
        
    } else if (_scrollIndex == 1) {
        
        [_twoWebView.scrollView headerEndRefreshing];
        
    } else if (_scrollIndex == 2) {
        
        [_threeWebView.scrollView headerEndRefreshing];
        
    } else if (_scrollIndex == 3) {
        
        [_fourWebView.scrollView headerEndRefreshing];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    NSLog(@"url == %@",url);
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    NSMutableDictionary *dict = [self getURLParametersWithURLString:urlStr];
    if (dict == nil) {//首页
        [dict setObject:@"index" forKey:@"type"];
        [MobClick event:@"BookStoreClick" attributes:dict];
    }else{//非首页
        [MobClick event:@"BookStoreClick" attributes:dict];
        LRLog(@"BookStoreClick---dict--%@",dict);
    }
    
    if (([urlStr hasPrefix:SITE_URL] || [urlStr hasPrefix:SITE_H5URL]) && (![urlStr containsString:@"srcid"])) {
        
        NSString *str = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([str containsString:@"headerName=女生"]) {//跳转女生
            
            self.myButton.tag = 12;
            _isHeadRefresh = NO;
            [self suspensionViewFourBtn:self.myButton];
            return NO;
        } else if ([str containsString:@"headerName=男生"]) {//跳转男生
            self.myButton.tag = 11;
            _isHeadRefresh = NO;
            [self suspensionViewFourBtn:self.myButton];
            return NO;
        } else {
            return YES;
        }
        
        
    } else {
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SecondH5Controller *secondH5VC = [[SecondH5Controller alloc] init];
            secondH5VC.sourceFrom = @"BookStore";
            secondH5VC.urlStr = urlStr;
            secondH5VC.titleStr = dict[@"headerName"];
            [weakSelf.navigationController pushViewController:secondH5VC animated:YES];
        });
        return NO;
    }
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParametersWithURLString:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

#pragma mark - 精选、男生、女生、分类按钮
- (void)suspensionViewFourBtn:(UIButton *)button{
    
    
    self.suspensionView.selectLabel.hidden = YES;
    self.suspensionView.boyLabel.hidden = YES;
    self.suspensionView.girlLabel.hidden = YES;
    self.suspensionView.classiftyLabel.hidden = YES;
    
    [self.suspensionView.selectBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    [self.suspensionView.boyBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    [self.suspensionView.girlBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];
    [self.suspensionView.classifyBtn setTitleColor:SuspensionColor forState:UIControlStateNormal];

    NSString *URLstr = @"";
    if (button.tag == 10) {//精选firstBtn
        
        _scrollIndex = 0;
        
        self.suspensionView.selectLabel.hidden = NO;
        [self.suspensionView.selectBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        if (!_isFirst) {
            [self setupIndex:0];
        }
        
        NSDictionary *dict = _result[0];
        NSString *urlStr = dict[@"url"];
        if (urlStr.length) {
            URLstr = urlStr;
        } else {
            URLstr = [NSString stringWithFormat:@"%@/asg/portal/view/index.html",SITE_URL];
        }
        
    } else if (button.tag == 11) {//男生secondBtn
        _scrollIndex = 1;
        self.suspensionView.boyLabel.hidden = NO;
        [self.suspensionView.boyBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        if (!_isFirst) {
            [self setupIndex:1];
        }
        
        NSDictionary *dict = _result[1];
        NSString *urlStr = dict[@"url"];
        if (urlStr.length) {
            URLstr = urlStr;
        } else {
            URLstr = [NSString stringWithFormat:@"%@/asg/portal/view/index.html?channelCode=%@&type=boy",SITE_URL,ChannelCode];
        }
        
    } else if (button.tag == 12) {//女生threeBtn
        
        _scrollIndex = 2;
        self.suspensionView.girlLabel.hidden = NO;
        [self.suspensionView.girlBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        
        if (!_isFirst) {
            [self setupIndex:2];
        }
        
        NSDictionary *dict = _result[2];
        NSString *urlStr = dict[@"url"];
        if (urlStr.length) {
            URLstr = urlStr;
        } else {
            URLstr = [NSString stringWithFormat:@"%@/asg/portal/view/index.html?channelCode=%@&type=girl",SITE_URL,ChannelCode];
        }
        
    } else if (button.tag == 13) {//分类fourBtn
        
        _scrollIndex = 3;
        self.suspensionView.classiftyLabel.hidden = NO;
        [self.suspensionView.classifyBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        
        if (!_isFirst) {
            [self setupIndex:3];
        }
        
        NSDictionary *dict = _result[3];
        NSString *urlStr = dict[@"url"];
        if (urlStr.length) {
            URLstr = urlStr;
        } else {
            URLstr = [NSString stringWithFormat:@"%@/asg/portal/view/index.html?channelCode=%@&type=categoryList",SITE_URL,ChannelCode];
        }
    }
    
    NSURL *url = [NSURL URLWithString:URLstr] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *netWorkType = [Function getNetWorkType];
    if ([netWorkType isEqualToString:@""]) {
        //无网络
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"断网了,请检查您的网络设置!"];
         request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:20];
    }else{
        if (!_isHeadRefresh) {
            if (_isShow) {
                _isShow = NO;
                [SVProgressHUD show];
            }
        }
        
        request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20];
    }
    if (button.tag == 10) {
        
        [_scrollView setContentOffset:CGPointZero animated:YES];
        [self.webView loadRequest:request];

    } else if (button.tag == 11) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        [self.twoWebView loadRequest:request];

    } else if (button.tag == 12) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:YES];
        [self.threeWebView loadRequest:request];

    } else if (button.tag == 13) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth * 3, 0) animated:YES];
        [self.fourWebView loadRequest:request];

    }
}


#pragma mark - 头部刷新
- (void)headerRefreshing{

    if (_scrollIndex == 0) {
        self.myButton.tag = 10;

    } else if (_scrollIndex == 1) {
        self.myButton.tag = 11;
 
    } else if (_scrollIndex == 2) {
        self.myButton.tag = 12;
        
    } else if (_scrollIndex == 3) {
        self.myButton.tag = 13;

    }
    _isHeadRefresh = YES;
    [self suspensionViewFourBtn:self.myButton];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= -10) {
        
        if (_scrollIndex == 0) {
            [_webView.scrollView addHeaderWithTarget:self action:@selector(headerRefreshing)];
        } else if (_scrollIndex == 1) {
            [_twoWebView.scrollView addHeaderWithTarget:self action:@selector(headerRefreshing)];
        } else if (_scrollIndex == 2) {
            [_threeWebView.scrollView addHeaderWithTarget:self action:@selector(headerRefreshing)];
        } else if (_scrollIndex == 3) {
            [_fourWebView.scrollView addHeaderWithTarget:self action:@selector(headerRefreshing)];
        }
    }
}


#pragma mark - 跳转搜索页面
- (void)searchBtnClick{
    
    _searchBtn.enabled = NO;
    
    [SVProgressHUD dismiss];
    [self.view hideLoadingImmediately];
    

    SearchMainController *searchMainVC = [[SearchMainController alloc] init];
    searchMainVC.source = @"BookStore";
    [searchMainVC.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:searchMainVC animated:YES];
}


@end
