//
//  E_ScrollViewController.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ScrollViewController.h"
#import "E_ReaderViewController.h"
#import "E_ReaderDataSource.h"
#import "E_EveryChapter.h"
#import "E_Paging.h"
#import "E_CommonManager.h"
#import "E_SettingTopBar.h"
#import "E_SettingBottomBar.h"
#import "E_ContantFile.h"
#import "E_DrawerView.h"
#import "CDSideBarController.h"
#import "E_CommentViewController.h"
#import "E_SearchViewController.h"
#import "E_WebViewControler.h"
#import "E_HUDView.h"
#import "E_SettingSecondBar.h"
#import "OrderView.h"
#import "RechargeController.h"
#import "EnsureButton.h"
#import "BackRackView.h"
#import "ThreeOrderView.h"
#import "TwoOrderView.h"
#import "OneOrderView.h"
#import "NewOrderView.h"
#import "NewThreeOrderView.h"
#import "NewTwoOrderView.h"
#import "Function.h"
#import "ReYunTrack.h"
#include "uchardet.h"
#import "ProgressView.h"


#define NUMBER_OF_SAMPLES   (2048)


@interface E_ScrollViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,E_ReaderViewControllerDelegate,E_SettingTopBarDelegate,E_SettingBottomBarDelegate,E_DrawerViewDelegate,E_SearchViewControllerDelegate,E_SettingSecondBarDelegate,UIGestureRecognizerDelegate,OrderViewDelegate,BackRackViewDelegate,ThreeOrderViewDelegate,TwoOrderViewViewDelegate,OneOrderViewDelegate,NewOrderViewDelegate,NewThreeOrderViewDelegate,NewTwoOrderViewDelegate,ProgressViewDelegate>
{
    UIPageViewController * _pageViewController;
    E_Paging             * _paginater;
    BOOL _isTurnOver;     //是否跨章；
    BOOL _isRight;       //翻页方向  yes为右 no为左
    BOOL _pageIsAnimating;          //某些特别操作会导致只调用datasource的代理方法 delegate的不调用
    BOOL _globalIsYes;
    BOOL _isCache;//YES：是缓存  NO：没有缓存
    BOOL _isBackView;//是否是背景页 YES 是  NO 不是
    UITapGestureRecognizer *tapGesRec;
    E_SettingTopBar *_settingToolBar;
    E_SettingBottomBar *_settingBottomBar;
    E_SettingSecondBar *_settingSecondBotBar;
    UIButton *_searchBtn;
    UIButton *_markBtnNew;
    UIButton *_markBtn;
    UIButton *_shareBtn;
    CGFloat   _panStartY;
    UIImage  *_themeImage;
    
    NSString      *_searchWord;//用来接受搜索页面的keyword
    const char *encode;//编码类型
    
}

@property (copy, nonatomic) NSString* chapterTitle_;
@property (copy, nonatomic) NSString* chapterContent_;
@property (unsafe_unretained, nonatomic) NSInteger fontSize;
@property (unsafe_unretained, nonatomic) NSUInteger readOffset;
@property (assign, nonatomic) NSInteger readPage;
@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) NetworkModel *payCheckmodel;
@property (nonatomic, strong) NetworkModel *consumeModel;
@property (nonatomic, strong) NetworkModel *batchModel;
@property (nonatomic, strong) NetworkModel *updateModel;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, strong) JYS_SqlManager *ABModel;
@property (nonatomic, strong) NSString *glaobalChapterId;
@property (nonatomic, assign) NSInteger currentChapter;
@property (nonatomic, assign) BOOL isBar;
@property (nonatomic, assign) BOOL rightOrLeft;
@property (nonatomic, strong) OrderView *orderView;
@property (nonatomic, strong) ThreeOrderView *threeOrderView;
@property (nonatomic, strong) TwoOrderView *twoOrderView;
@property (nonatomic, strong) OneOrderView *oneOrderView;
@property (nonatomic, strong) NewOrderView *neworderView;
@property (nonatomic, strong) NewThreeOrderView *newthreeOrderView;
@property (nonatomic, strong) NewTwoOrderView *newtwoOrderView;
@property (nonatomic, strong) NSString *consumeChapterID;
@property (nonatomic, strong) NSString *consumeChapterName;
@property (nonatomic, assign) NSInteger consumeChapterIndex;
@property (nonatomic, strong) NSString *afterNum;
@property (nonatomic, assign) BOOL isAutoBuy;
@property (nonatomic, strong) NSNumber *action;
@property (nonatomic, strong) NSNumber *twoAction;
@property (nonatomic, strong) NSNumber *threeAction;
@property (nonatomic, strong) NSNumber *fourAction;
@property (nonatomic, strong) NSNumber *fiveAction;

@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, assign) BOOL isNextChapter;
@property (nonatomic, assign) BOOL isMenu;
@property (nonatomic, assign) NSInteger menuChapter;
@property (nonatomic, assign) BOOL isCallBar;
@property (nonatomic, assign) NSUInteger callCurrentPage;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, assign) NSUInteger myCurrentPage;
@property (nonatomic, assign) BOOL isMyCurrent;
@property (nonatomic, strong) ZipArchive *za;
@property (nonatomic, strong) BackRackView *backRackView;
@property (nonatomic, assign) BOOL isBatch;
@property (nonatomic, assign) NSInteger batchIndex;
@property (nonatomic, assign) BOOL isAddOneChapter;
@property (nonatomic, strong) NSString *chapterUnit;
@property (nonatomic, assign) BOOL isLastPage;//YES:向左 NO:向右
@property (nonatomic, assign) BOOL isKuaisu;
@property (nonatomic, assign) BOOL isOnlyOne;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *priceUnit;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) BOOL isBatch110;
@property (nonatomic, assign) BOOL isCallDraw;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, assign) BOOL isNotLast;
@property (nonatomic, assign) BOOL isIndex;
@property (nonatomic, strong) NSMutableArray *chargeListArray;
@property (nonatomic, assign) NSInteger isRequestOK;
@property (nonatomic, assign) BOOL isMunClick;//是否点击目录跳转过来的

@property (nonatomic, strong) BookInforModel *currentBook;

@property (nonatomic, strong) CatelogInforModel *curretCatelogModel;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) NSDictionary *progressDict;
@property (nonatomic, assign) BOOL IsProgress;//下放阅读进度跳转但并无目录数组请求110后再跳转
@property (nonatomic, assign) BOOL IsCloud;//是否从云书架上过来的

@end


@implementation E_ScrollViewController

- (ZipArchive *)za{
    
    if (_za == nil) {
        _za = [[ZipArchive alloc] init];
    }
    return _za;
}

- (UIView *)myView{
    
    if (_myView == nil) {
        _myView = [[UIView alloc] init];
        _myView.frame = CGRectMake(120 * KKuaikan, 60, ScreenWidth - 240 * KKuaikan, ScreenHeight - 270 * KKuaikan);
    }
    return _myView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    _isAutoBuy = YES;
    
    [[AppDelegate sharedApplicationDelegate].window addSubview:self.myView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.myView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}



- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //这本书在书架上且没有封皮，重新请求书籍详情
    if ((!self.currentBook.coverurl.length && (self.currentBook.isAddBook.integerValue == 1))||!self.currentBook.introuce.length) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self requestSearchHotWord157WithBookID:_bookID];
        });
    }
    _isKuaisu = YES;
    
    _isBackView = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_bookID forKey:@"bookID"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    _isBar = YES;
    
    
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = WhiteColor;
    }
    
    //    self.view.backgroundColor = WhiteColor;
    
    self.fontSize = [E_CommonManager fontSize];
    _pageIsAnimating = NO;
    
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    if (themeID == 1) {
        _themeImage = nil;
    } else {
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_g%ld.png",(long)themeID]];
    }
    
    //设置总章节数
    [E_ReaderDataSource shareInstance].totalChapter = _totalChapter;
    //设置总章节的标题
    [E_ReaderDataSource shareInstance].totalTitlArray = [_totalTitlArray mutableCopy];
    
    //设置章节列表数组
    [E_ReaderDataSource shareInstance].chapterIdListArray = [_chapterIdListArray mutableCopy];
    
    
    _isMyCurrent = NO;
    
    _isOnlyOne = NO;
    
    if (_allChapterOne) {
        
        _isIndex = YES;
        [SVProgressHUD showWithStatus:@"正在加载中"];
        [self requestchapterID:_allChapterOne andIs:YES andIsCache:NO];
        _currentChapter = _allChapterIndex;
        
    } else {
        //再次进入页面获取位置
        NSDictionary *dict = [E_CommonManager Manager_getChapterBefore:_bookID];
        NSInteger index = [dict[@"chapterIndex"] integerValue];
        NSInteger pageIndex = [dict[@"currentPage"] integerValue];
        if ((index > _totalChapter) && _totalChapter > 2) {
            index = _totalChapter - 1;
        }
        _currentChapter = index;
        _readPage = pageIndex;
        
        if (index > 0) {
            [self requestStoryContent:index andIs:NO andIsCache:NO];
            
        } else {
            NSString *chapterID = nil;
            for (int i = 0; i < _chapterIdListArray.count; i ++) {
                chapterID = _chapterIdListArray[i];
                if ([chapterID isEqualToString:_chapterID]) {
                    _currentChapter = i;
                    break;
                }
            }
            _isIndex = YES;
            
            [SVProgressHUD showWithStatus:@"正在加载中"];
            [self requestchapterID:_chapterID andIs:YES andIsCache:NO];
        }
    }
    tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callToolBar)];
    [self.myView addGestureRecognizer:tapGesRec];

    

    //书籍阅读进度下放
    if (IsLogin && (self.currentBook.isAddBook.integerValue == 1) && self.currentBook.isRedSyn.integerValue == 0) {
        
        
        [self requsetReadProgress];
    }
    
}

#pragma mark - 当前书籍
- (BookInforModel *)currentBook
{
   
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    _currentBook = [dataManager getBookWithBookId:_bookID];
    
    return _currentBook;
  
}
#pragma mark - 当前章节
- (CatelogInforModel *)curretCatelogModel
{
    if (_curretCatelogModel == nil) {
        if (self.dataArray.count>_currentChapter) {
            _curretCatelogModel = self.dataArray[_currentChapter];
        }else{
            if ([E_ReaderDataSource shareInstance].chapterIdListArray.count>_currentChapter) {
                NSString *currentId = [E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter];
                self.curretCatelogModel = [[JYS_SqlManager shareManager] getCatelogWithCatelogId:currentId andFromBook:_bookID];
                if (self.curretCatelogModel == nil) {
                    self.curretCatelogModel = [[CatelogInforModel alloc]init];
                    self.curretCatelogModel.bookid = _bookID;
                    self.curretCatelogModel.catelogName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];
                    self.curretCatelogModel.chaterId = currentId;
                    self.curretCatelogModel.isPay = @0;
                    self.curretCatelogModel.entityid = [NSString stringWithFormat:@"%@%@",_bookID,currentId];
                    [[JYS_SqlManager shareManager]insertCatelogWithObject:self.curretCatelogModel];
                }
            }
        }
        return _curretCatelogModel;
    }
    return _curretCatelogModel;
}
#pragma mark - 请求获取书籍详情页
- (void)requestSearchHotWord157WithBookID:(NSString *)bookID{
    
    NetworkModel *netModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = bookID;
    requestData[@"defbook"] = @"2";
    [netModel registerAccountAndCall:157 andRequestData:requestData Snyc:NO];
}




#pragma mark - 检查章节更新信息
- (void)requestUpdateChapter114:(NSString *)lastChapter{
    self.updateModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"2";
    
    requestData[@"idStrs"] = [NSString stringWithFormat:@"%@:%@",_bookID,lastChapter];
    
    [self.updateModel registerAccountAndCall:114 andRequestData:requestData];
}
-(NSArray *)dataArray{
    if (_dataArray == nil || _dataArray.count<21) {
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
        _dataArray = [dataManager getAllCatelogFromBook:_bookID];
        
        return _dataArray;
    }
    return _dataArray;
}

#pragma mark - 请求小说的目录
- (void)requestStoryMuenCall110{
    [SVProgressHUD showWithStatus:@"加载目录中，请耐心等候" maskType:SVProgressHUDMaskTypeClear];
    
    NSMutableArray *chapterIdList = [[NSMutableArray alloc] init];
    if (_isUpdate) {
        for (int i = 0; i < self.dataArray.count; i ++) {
            CatelogInforModel *catelog = _dataArray[i];
            [chapterIdList addObject:catelog.chaterId];
        }
        self.networkModel = [[NetworkModel alloc] initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"v"] = @"2";
        requestData[@"chapterStatus"] = @"9999";
        if (chapterIdList.count) {
            requestData[@"chapterId"] = chapterIdList[chapterIdList.count - 1];
        } else {
            requestData[@"chapterId"] = @"";
        }
        requestData[@"defbook"] = @"1";
        requestData[@"bookId"] = _bookID;
        requestData[@"chapterEndId"] = @"";
        requestData[@"marketId"] = @"";
        requestData[@"payWay"] = @"2";
        requestData[@"needBlockList"] = @"";
        [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
        return;
    }
    self.networkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"2";
    requestData[@"chapterStatus"] = @"9999";
    requestData[@"chapterId"] = @"";
    requestData[@"defbook"] = @"1";
    requestData[@"bookId"] = _bookID;
    requestData[@"chapterEndId"] = @"";
    requestData[@"marketId"] = @"";
    requestData[@"payWay"] = @"2";
    requestData[@"needBlockList"] = @"";
    [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
}


#pragma mark - 点击设置弹出第二个bar
- (void)settingBtnClick{
    
    [self.myView removeFromSuperview];
    
    if (_settingSecondBotBar == nil) {
        _settingSecondBotBar = [[E_SettingSecondBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomBarH, self.view.frame.size.width, KSecondBottonBarH)];
        [self.view insertSubview:_settingSecondBotBar belowSubview:_settingBottomBar];
        _settingSecondBotBar.chapterTotalPage = _paginater.pageCount;
        _settingSecondBotBar.chapterCurrentPage = _readPage;
        _settingSecondBotBar.currentChapter = _currentChapter;
        _settingSecondBotBar.delegate = self;
        [_settingSecondBotBar showToolBar];
        
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        
        [_settingSecondBotBar hideToolBar];
        _settingSecondBotBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}


#pragma mark - 弹出或隐藏上下bar
- (void)callToolBar{
    
    _isKuaisu = YES;
    
    if (_settingToolBar == nil) {
        
        _isBar = NO;
        
        _settingToolBar = [[E_SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
        
        [self.view addSubview:_settingToolBar];
        _settingToolBar.titleLabel.text = _bookName;
        
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
        _markBtn = [UIButton buttonWithType:0];
        
        _markBtn.frame = CGRectMake(self.view.frame.size.width - 44 - 5 , 18, 44, 44);
        
        CGRect newFrame = _markBtn.frame;
        newFrame.origin.y += 20;
        
        [UIView animateWithDuration:0.1 animations:^{
            [_markBtn setTitle:@"书签" forState:0];
            _markBtn.frame = CGRectMake(self.view.frame.size.width - 44 - 5, 20, 44, 44);
            
            [self.view addSubview:_markBtn];
            
            NSRange range = [_paginater rangeOfPage:_readPage];
            if ([E_CommonManager checkIfHasBookmark:range withChapter:_currentChapter]) {
                _markBtn.selected = YES;
            } else {
                _markBtn.selected = NO;
            }
            
            if (_markBtn.selected == YES) {
                
                [_markBtn setTitleColor:[UIColor redColor] forState:0];
                
            } else {
                
                [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
            }
            _markBtn.titleLabel.font = Font16;
            [_markBtn addTarget:self action:@selector(doMark) forControlEvents:UIControlEventTouchUpInside];
        } completion:^(BOOL finished) {
            
        }];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        
        _isBar = YES;
        
        [self hideMultifunctionButton];
        [_markBtn removeFromSuperview];
        
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    if (_settingBottomBar == nil) {
        
        _isBar = NO;
        
        _settingBottomBar = [[E_SettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
        [self.view addSubview:_settingBottomBar];
        
        [_settingBottomBar.coverBtn setTitleColor:ADColor(184, 184, 184) forState:UIControlStateNormal];
        
        _settingBottomBar.chapterTotalPage = _paginater.pageCount;
        _settingBottomBar.chapterCurrentPage = _readPage;
        _settingBottomBar.currentChapter = _currentChapter;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        
        _isBar = YES;
        
        [_settingSecondBotBar hideToolBar];
        _settingSecondBotBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        [[AppDelegate sharedApplicationDelegate].window addSubview:self.myView];
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}



- (void)initPageView:(BOOL)isFromMenu;{
    
    if (_pageViewController) {
        [_pageViewController removeFromParentViewController];
        [_pageViewController.view removeFromSuperview];
        _pageViewController.dataSource = nil;
        _pageViewController.delegate = nil;
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    //    UIPanGestureRecognizer *sgestureReco = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sgestureRecos:)];
    //    [_pageViewController.view addGestureRecognizer:sgestureReco];
    
    
    for (UIGestureRecognizer *gestureReco in _pageViewController.view.gestureRecognizers) {
        
        gestureReco.delegate = self;
        
    }
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _isKuaisu = YES;
    
    if (isFromMenu == YES) {
        
        [self showPage:0];
    }else{
        NSUInteger beforePage = _readPage;
        if (_isMunClick) {
            
            beforePage = 0;
        } else {
            
            if (_isLastPage) {
                
                beforePage = self.lastPage;
                
            }
        }
        
        [self showPage:beforePage];
    }
}

#pragma mark - readerVcDelegate
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    
    if (yesOrNo == NO) {
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }else{
        _pageViewController.delegate = nil;
        _pageViewController.dataSource = nil;
    }
}

- (void)ciBaWithString:(NSString *)ciBaString{
    
    E_WebViewControler *webView = [[E_WebViewControler alloc] initWithSelectString:ciBaString];
    [self presentViewController:webView animated:YES completion:NULL];
}

- (void)turnToClickChapterLastPate{
    
    _isLastPage = NO;
}

#pragma mark - 点击目录跳转 或者点击上下章
- (void)turnToClickChapter:(NSInteger)chapterIndex{
    
    [[AppDelegate sharedApplicationDelegate].window addSubview:self.myView];
    
    [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
    
    _isMyCurrent = NO;
    
    _isKuaisu = YES;
    
    _isOnlyOne = NO;
    
    _isAddOneChapter = YES;
    
    _isMunClick = YES;
    _isBatch = NO;
    _menuChapter = _currentChapter;
    
    _currentChapter = chapterIndex;
    _consumeChapterIndex = chapterIndex;
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSArray *chapterNameListArray = [E_ReaderDataSource shareInstance].totalTitlArray;
    NSString *chapterId = chapterIdListArray[chapterIndex];
    
    NSString *chapterName = @"";
    if (chapterIndex >= chapterNameListArray.count) {
        chapterName = chapterNameListArray[chapterNameListArray.count - 1];
    } else {
        chapterName = chapterNameListArray[chapterIndex];
    }
    
    
    if (self.dataArray.count>chapterIndex) {
        self.curretCatelogModel = self.dataArray[chapterIndex];
    }
    
    if ([self.currentBook.marketStatus isEqualToNumber:@(3)]) {//限免
        
        [self requestStoryContent:chapterIndex andIs:@(!_isLastPage) andIsCache:NO];
        
    } else {//非限免
        LRLog(@"isPay------%ld",(long)_curretCatelogModel.isPay.integerValue);
        if (_curretCatelogModel.isPay.integerValue == 1) {//需要付费
            LRLog(@"------%@",self.currentBook.confirmStatus);
            if ([self.currentBook.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
                
                _consumeChapterID = chapterId;
                _consumeChapterName = chapterName;
                
                NSDictionary *dict = nil;
                
                [self requestConsume197:dict];
                
                
                [self requestStoryContent:chapterIndex andIs:@(!_isLastPage) andIsCache:NO];
                
                
            } else {//需要弹框确认购买
                [SVProgressHUD showWithStatus:@"加载付费弹框中" maskType:SVProgressHUDMaskTypeClear];
                [self requestPayCheck196:chapterId andChapterName:chapterName];
            }
        } else if (!_curretCatelogModel.isPay.integerValue){
            
            NSString *isChapter = _chargeListArray[chapterIndex];
            if ([isChapter isEqualToString:@"1"]) {//需要付费
                //                [[AppDelegate sharedApplicationDelegate].window showLoadingView];
                //                [self requestPayCheck196:chapterId andChapterName:chapterName];
                _consumeChapterID = chapterId;
                _consumeChapterName = chapterName;
                
                NSDictionary *dict = nil;
                
                [self requestConsume197:dict];
                
                
                [self requestStoryContent:chapterIndex andIs:@(!_isLastPage) andIsCache:NO];
            } else {
                
                [self requestStoryContent:chapterIndex andIs:@(!_isLastPage) andIsCache:NO];
                
            }
        } else {//不需付费
            
            [self requestStoryContent:chapterIndex andIs:@(!_isLastPage) andIsCache:NO];
            
        }
    }
}


#pragma mark - 支付检查
- (void)requestPayCheck196:(NSString *)chapterID andChapterName:(NSString *)chapterName{
    
    _consumeChapterID = chapterID;
    _consumeChapterName = chapterName;
    
    NSString *lastChapterId = _chapterIdListArray.lastObject;
    
    self.payCheckmodel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookID;
    requestData[@"baseChapterId"] = chapterID;
    if (_isBatch) {
        requestData[@"readAction"] = @"4";
    } else {
        requestData[@"readAction"] = @"3";
    }
    
    requestData[@"lastChapterId"] = lastChapterId;
    requestData[@"marketStatus"] = @"";
    [self.payCheckmodel registerAccountAndCall:196 andRequestData:requestData];
}

#pragma mark - 网络请求或本地请求章节内容
- (void)requestchapterID:(NSString *)chapterID andIs:(BOOL)isYesOrNo andIsCache:(BOOL)isCache{
    
    self.glaobalChapterId = chapterID;
    _globalIsYes = isYesOrNo;
    _isRequestOK =_currentChapter;
    _isCache = isCache;
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    CatelogInforModel *chapter = [dataManager getCatelogWithCatelogId:chapterID andFromBook:_bookID];
    
    if ((chapter.isDownload == nil)||(chapter.isDownload.integerValue==0)) {//没有进行过本地数据库缓存
        self.networkModel = [[NetworkModel alloc]initWithResponder:self];
        
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"defbook"] = @"1";
        requestData[@"bookId"] = _bookID;
        requestData[@"chapterIds"] = chapterID;
        requestData[@"chapterStatus"] = @"1";
        //        LRLog(@"downloadchapterID--%@",chapterID);
        [self.networkModel registerAccountAndCall:113 andRequestData:requestData];
        
    } else {//本地数据库存在
        [self decompressionZip:chapter.url andChapterIds:chapterID andIsYesOrNo:isYesOrNo andIsCache:isCache];
        
    }
}

#pragma mark - 批量请求章节内容
- (void)downloadManyCaputerWithArray:(NSArray *)chaputerArray{
    
    NSInteger totalCount = chaputerArray.count;
    int i = 0;
    while (i<totalCount) {
        NSString *chapterId = chaputerArray[i];
        if ([self isChaputerDownWithId:chapterId]) {
            i++;
            continue;
        }
        [self downloadZipWithChaputerId:chapterId];
        i++;
    }
    //171  iOS目前自有不需要走接口可以直接
    //    [self requestBatch171:idStr];
}

- (void)downloadZipWithChaputerId:(NSString *)chaputerId
{//本地数据库没有存过此章节的路径
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[self componentPathWithChaputerId:chaputerId]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if(!error){
        //保存到应用的caches目录。现在你已经把文件下载到了本地磁盘
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"MyCache"];
        BOOL isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir ]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
        [data writeToFile:zipPath options:0 error:&error];
        //        LRLog(@"data--%@",data);
        
        if(!error){
            
            if ([self.za UnzipOpenFile:zipPath]) {
                //
                BOOL ret = [self.za UnzipFileTo:path overWrite:YES];
                if (NO == ret){} [self.za UnzipCloseFile];
                // 把解压出的内存写入caches目录
                NSString *componentStr = [NSString stringWithFormat:@"%@.txt",chaputerId];//存入的名字
                NSString *textFilePath = [path stringByAppendingPathComponent:componentStr];
                int result= [self haveTextBianMa:[textFilePath UTF8String]];
                CFStringEncoding cfEncode = [self textEncodingTypeWithResult:result];
                NSError *err;
                NSString *contentString=[NSString stringWithContentsOfFile:textFilePath encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&err];
                //                LRLog(@"contentString--%@",contentString);
                if (contentString.length) {//有内容
                    if(!contentString){
                        contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000632 error:nil];
                    }
                    
                    if(!contentString){
                        contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000631 error:nil];
                    }
                    
                    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                    contentString = [self serializationString:contentString];
                    
                    CatelogInforModel *chapter = [dataManager getCatelogWithCatelogId:chaputerId andFromBook:_bookID];
                    if(chapter ==nil)
                    {
                        chapter = [CatelogInforModel new];
                        chapter.entityid = [NSString stringWithFormat:@"%@%@",_bookID,chaputerId];
                        chapter.chaterId = chaputerId;
                        chapter.path = [self componentPathWithChaputerId:chaputerId];
                        chapter.bookid = _bookID;
                        chapter.chaterId = chaputerId;
                        chapter.isDownload = @1;
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [WHC_ModelSqlite insert:chapter];
                        });
                    }else{
                        chapter.path = [self componentPathWithChaputerId:chaputerId];
                        chapter.bookid = _bookID;
                        chapter.chaterId = chaputerId;
                        chapter.isDownload = @1;
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [WHC_ModelSqlite update:chapter where:[NSString stringWithFormat:@"entityid = %@",chapter.entityid]];
                        });
                    }
                    
                } else {//没有内容
                    
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        
                        [self requestStoryContent:_currentChapter andIs:NO andIsCache:NO];
                    });
                }
            }
        }else{
            
        }
    }else{
        
    }
}


//判断章节是否存在
- (BOOL)isChaputerDownWithId:(NSString *)chaputerId
{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    CatelogInforModel *chapter = [dataManager getCatelogWithCatelogId:chaputerId andFromBook:_bookID];
    return chapter.path.length>0?YES:NO;
}
//组装章节路径
- (NSString *)componentPathWithChaputerId:(NSString *)chaputerId
{
    NSString *downloadUrl = [NSString stringWithFormat:@"%@bookId=%@&chapterId=%@",ZIP_URL,_bookID,chaputerId];
    return downloadUrl;
}

- (void)requestBatch171:(NSString *)chaputerIds{
    
    self.batchModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookID;
    requestData[@"chapterIds"] = chaputerIds;
    requestData[@"payWay"] = @2;
    [self.batchModel registerAccountAndCall:171 andRequestData:requestData Snyc:YES];
}


#pragma mark - 网络请求或本地请求章节内容
- (void)requestStoryContent:(NSInteger)index andIs:(BOOL)isYesOrNo andIsCache:(BOOL)isCache{
    
    NSString *chapterIds = @"";
    if (index >= [E_ReaderDataSource shareInstance].chapterIdListArray.count) {
        chapterIds = [NSString stringWithFormat:@"%@,",[E_ReaderDataSource shareInstance].chapterIdListArray[[E_ReaderDataSource shareInstance].chapterIdListArray.count - 1]];
    } else {
        chapterIds = [NSString stringWithFormat:@"%@,",[E_ReaderDataSource shareInstance].chapterIdListArray[index]];
    }
    _globalIsYes = isYesOrNo;
    _isCache = isCache;
    
    if (!isCache) {
        if (!_isMyCurrent) {
            
            _isRequestOK = _currentChapter;
            _currentChapter = index;
            _isMyCurrent = YES;
        }
    }
    
    NSString *chapterId = @"";
    
    if (index >= [E_ReaderDataSource shareInstance].chapterIdListArray.count) {
        chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[[E_ReaderDataSource shareInstance].chapterIdListArray.count - 1];
    } else {
        
        chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[index];
    }
    
    self.glaobalChapterId = chapterId;
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    CatelogInforModel *chapter = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
    
    
    if ((chapter.isDownload == nil)||(chapter.isDownload.integerValue==0)) {//没有进行过本地数据库缓存
        
        if (!isCache) {//不是缓存的情况下提醒正在请求下章内容
            [SVProgressHUD showWithStatus:@"加载章节内容中..."];
        }
        
        self.networkModel = [[NetworkModel alloc] initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"chapterStatus"] = @"1";
        requestData[@"defbook"] = @"1";
        requestData[@"bookId"] = _bookID;
        requestData[@"chapterIds"] = chapterIds;
        
        [self.networkModel registerAccountAndCall:113 andRequestData:requestData];
        
    }
    {//本地数据库存在
        
        [self decompressionZip:chapter.url andChapterIds:chapter.chaterId andIsYesOrNo:isYesOrNo andIsCache:isCache];
        //        LRLog(@"chapter.url---%@",chapter.url);
    }
    
}


#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.call == 113) {
        if (message.resultCode == 0) {
            //            LRLog(@"message-----%@",message.responseData);
            JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
            [DBModel insertChaperToDataBase:message.responseData];
            
            //            LRLog(@"responseData---%@",message.responseData);
            
            [self decompressionZip:message.responseData[@"url"] andChapterIds:self.glaobalChapterId andIsYesOrNo:_globalIsYes andIsCache:_isCache];
        } else {//获取章节失败
            [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
            _isMyCurrent = NO;
            
            if (!_isCache) {
                if (_menuChapter) {
                    _currentChapter = _menuChapter;
                } else {
                    _currentChapter = _isRequestOK;
                }
            }
            
            _isCache = NO;
        }
        
    } else if (message.call == 216) {
        
        
        if (message.resultCode == 0) {

            if ([message.responseData isKindOfClass:[NSDictionary class]]) {
                
                NSString *chapterID = message.responseData[@"chapterId"];
                NSArray *tipsArray = message.responseData[@"tips"];
                NSDictionary *secondTip = tipsArray[1];
                NSString *secondTipStr = secondTip[@"tip"];
                if (chapterID.length && secondTipStr.length) {//云书架有章节ID
                    _progressDict = message.responseData;
                    _progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    _progressView.delegate = self;
                    _progressView.array = message.responseData[@"tips"];
                    [_progressView creatView];
                }
            }
        }
    } else if (message.call == 114) {
        NSArray *returnList = message.responseData[@"returnList"];
        NSDictionary *dict = returnList[0];
        NSString *newChapter = [NSString stringWithFormat:@"%@",dict[@"newChapter"]];
        
        JYS_SqlManager *updateModel = [JYS_SqlManager shareManager];
        if ([newChapter isEqualToString:@"0"]) {//有更新
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(YES) forKey:@"isUpdate"];
            
            [dict setObject:_bookID forKey:@"bookID"];
            [updateModel updateChapter:dict];
            
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(NO) forKey:@"isUpdate"];
            
            [dict setObject:_bookID forKey:@"bookID"];
            [updateModel updateChapter:dict];
        }
    } else if (message.call == 110) {
        if (message.resultCode == 0) {
            //            LRLog(@"%@",message.responseData);
            _NewUpdate = NO;
            
            
            NSString *lastChapter = nil;
            if ([E_ReaderDataSource shareInstance].chapterIdListArray.count == 20) {
                [E_ReaderDataSource shareInstance].totalTitlArray = [[NSArray arrayWithArray:message.responseData[@"chapterNameList"]] mutableCopy];
                [E_ReaderDataSource shareInstance].chapterIdListArray = [[NSArray arrayWithArray:message.responseData[@"chapterIdList"]] mutableCopy];
                [E_ReaderDataSource shareInstance].totalChapter = [E_ReaderDataSource shareInstance].chapterIdListArray.count;
                lastChapter = [NSString stringWithFormat:@"%@",[E_ReaderDataSource shareInstance].chapterIdListArray[[E_ReaderDataSource shareInstance].chapterIdListArray.count - 1]];
            } else {
                NSMutableArray *array = [[NSArray arrayWithArray:message.responseData[@"chapterIdList"]] mutableCopy];
                [array removeObjectAtIndex:0];
                NSMutableArray *chaptrtNameArray =[[NSArray arrayWithArray:message.responseData[@"chapterNameList"]] mutableCopy];
                [chaptrtNameArray removeObjectAtIndex:0];
                
                lastChapter = [NSString stringWithFormat:@"%@",array[array.count - 1]];
                
                
                NSMutableArray *newNameArray = [E_ReaderDataSource shareInstance].totalTitlArray;
                [chaptrtNameArray arrayByAddingObjectsFromArray:newNameArray];
                NSMutableArray *nameArray = [NSMutableArray arrayWithArray:[E_ReaderDataSource shareInstance].totalTitlArray];
                [nameArray addObjectsFromArray:chaptrtNameArray];
                [E_ReaderDataSource shareInstance].totalTitlArray = [nameArray mutableCopy];
                
                //设置章节列表数组
                NSMutableArray *newIDArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
                [array arrayByAddingObjectsFromArray:newIDArray];
                NSMutableArray *idArray = [NSMutableArray arrayWithArray:newIDArray];
                [idArray addObjectsFromArray:array];
                [E_ReaderDataSource shareInstance].chapterIdListArray = [idArray mutableCopy];
                
                [E_ReaderDataSource shareInstance].totalChapter = idArray.count;
            }
            
            LRLog(@"---------%@",[E_ReaderDataSource shareInstance].chapterIdListArray);
            
            [self requestUpdateChapter114:lastChapter];
            
            
            NSString *isPay = @"";
            NSString *isChargeList = [NSString stringWithFormat:@"%@",message.responseData[@"isChargeList"]];
            
            NSMutableArray *chargeListArray = [[NSMutableArray alloc] init];
            NSArray *chapterIdListArray = message.responseData[@"chapterIdList"];
            for (int i = 0; i < chapterIdListArray.count; i ++) {
                
                isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
                [chargeListArray addObject:isPay];
            }
            _chargeListArray = chargeListArray;
            
            [SVProgressHUD dismiss];
            if (_isBatch110) {
                [self secondIsBtach];
                
            }
            
            if (_isCallDraw) {
                [self secondIsCallDraw];
            }
            
            
            JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
            [DBModel insertCatelogToDataBase:message.responseData andIsEnd:YES andIsBatch:_isBatch110 andIsCallDraw:_isCallDraw];
            
            if (_IsProgress) {
                _IsProgress = NO;
                UIButton *button = [[UIButton alloc] init];
                button.tag = 11;
                [self progressViewTwoBtnClick:button];
            }
            
            
        } else {
            [SVProgressHUD showWithStatus:@"网络不给力，请您重新获取"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
    } else if (message.call == 197) {//消费（扣费）接口
        
        
        if (message.resultCode == 0) {
            
            NSString *statusStr = [NSString stringWithFormat:@"%@",message.responseData[@"status"]];
            if ([statusStr isEqualToString:@"3"]) {//余额不足
                
                self.ABModel = [JYS_SqlManager shareManager];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_bookID forKey:@"bookID"];
                [dict setObject:@(0) forKey:@"isAutoBuy"];
                
                [self.ABModel amendAutoBuy:dict];
                
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
            if (!(remainSum == nil || [remainSum isEqualToString:@""])) {
                
                [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            }
            
            self.DBModel = [JYS_SqlManager shareManager];
            if ([_afterNum isEqualToString:@"1"]) {//一章一章购买
                [ReYunChannel setEvent:@"event_1"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
                [dict setObject:_afterNum forKey:@"afterNum"];
                [dict setObject:_bookID forKey:@"bookID"];
                [dict setObject:_consumeChapterName forKey:@"consumeChapterName"];
                
                [self.DBModel amendPayRecord:dict];
                
            } else {//多个章节一起购买
                
                
                [SVProgressHUD showWithStatus:@"正在批量购买，请等待"];
                
                if ([E_ReaderDataSource shareInstance].chapterIdListArray.count != [E_ReaderDataSource shareInstance].totalTitlArray.count) {
                    [self requestStoryMuenCall110];
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                if (_currentChapter > _consumeChapterIndex) {
                    
                    NSString *consumeChapID =[E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter];
                    [dict setObject:@(_currentChapter) forKey:@"consumeChapterIndex"];
                    [dict setObject:consumeChapID forKey:@"consumeChapterID"];
                } else {
                    
                    [dict setObject:@(_consumeChapterIndex) forKey:@"consumeChapterIndex"];
                    [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
                }
                
                
                if ([_chapterUnit isEqualToString:@"本"]) {
                    NSString *newAfterNum = [NSString stringWithFormat:@"%lu",[E_ReaderDataSource shareInstance].chapterIdListArray.count - _currentChapter];
                    [dict setObject:_bookID forKey:@"bookID"];
                    [dict setObject:newAfterNum forKey:@"afterNum"];
                    
                } else {
                    [dict setObject:_afterNum forKey:@"afterNum"];
                }
                [dict setObject:[E_ReaderDataSource shareInstance].chapterIdListArray forKey:@"chapterIdListArray"];
         
                
                
                int afterNum = [dict[@"afterNum"] intValue];
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                
                NSString *startId = [dict objectForKey:@"consumeChapterID"];
                
                NSArray * array = [dataManager getPaymentStatusWithCurrentCatelog:startId andCount:afterNum fromBook:_bookID];
                
                //热云检测批量消费
                if (afterNum == 10) {
                    [ReYunChannel setEvent:@"event_2"];
                }else if (afterNum == 50){
                    [ReYunChannel setEvent:@"event_3"];
                }else if (afterNum == 100){
                    [ReYunChannel setEvent:@"event_4"];
                }else{
                    [ReYunChannel setEvent:@"event_5"];
                }
                NSMutableArray *chaputerArray = [NSMutableArray new];
                for (CatelogInforModel *catelog in array) {
                    [chaputerArray addObject:catelog.chaterId];
                }
                [dataManager updatePaymentRecordWithArray:array fromBook:_bookID];
                [self downloadManyCaputerWithArray:chaputerArray];
                [SVProgressHUD showSuccessWithStatus:@"购买成功"];
            }
        }
    } else if (message.call == 196) {//消费检查接口
        
        if (_isBatch) {
            [SVProgressHUD dismiss];
            [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
        } else {
            
            if (!_isMyCurrent) {
                [SVProgressHUD dismiss];
                [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
            }
        }
        
        if (message.resultCode == 0) {
            
            NSString *statusStr = [NSString stringWithFormat:@"%@",message.responseData[@"status"]];
            if ([statusStr isEqualToString:@"4"]) {
                
                if (_isLastPage) {
                    [self requestStoryContent:(_currentChapter - 1) andIs:NO andIsCache:NO];
                } else {
                    if (_isMunClick) {
                        [self requestStoryContent:_currentChapter andIs:YES andIsCache:NO];
                    } else {
                        [self requestStoryContent:(_currentChapter + 1) andIs:YES andIsCache:NO];
                    }
                }
            } else {
                
                NSArray *lotsTips = message.responseData[@"lotsTips"];
                if (_isBatch) {//批量下载点击
                    
                    
                    if (lotsTips.count == 3) {
                        
                        [self batchThreeOrderView:message.responseData];
                        
                    } else if (lotsTips.count == 2) {
                        
                        [self batchTwoOrderView:message.responseData];
                        
                    } else if (lotsTips.count == 1) {
                        
                        [self batchOneOrderView:message.responseData];
                    }
                } else {//其他正常操作
                    NSString *chapterId = @"";
                    
                    if (_isAddOneChapter || _IsCloud) {
                        _IsCloud = NO;
                        chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter];
                    } else {
                        chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter + 1];
                    }
                
                    _chapterUnit = message.responseData[@"chapterUnit"];
                    
                    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                    CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
                    
                    if (catelog.isPay.integerValue == 1) {//需要付费
                        
                        [self needPayData:message.responseData];
                    } else if (!catelog.isPay) {//需要付费
                        
                        [self needPayData:message.responseData];
                    } else if (lotsTips.count) {//需要付费
                        
                        [self needPayData:message.responseData];
                    } else {//不需付费
                        
                        [self requestStoryContent:_currentChapter andIs:YES andIsCache:NO];
                        
                    }
                }
            }
        } else if (message.resultCode == -1009){
            if (_isBatch) {//批量下载点击
                [E_HUDView showMsg:@"网络出现问题" inView:self.view];
                
            }
        } else {//请求付费弹框失败
            if (_isBatch) {//批量下载点击
                [E_HUDView showMsg:@"暂无批量下载章节" inView:self.view];
                
            }
        }
    }else if (message.call == 157){
        if ([message.responseData isKindOfClass:[NSDictionary class]]) {
            
            if (self.currentBook.isAddBook.integerValue == 1) {
                JYS_SqlManager *bookModel = [JYS_SqlManager shareManager];
                [bookModel insertData:message.responseData];
            }
            
            NSDictionary *book = message.responseData[@"book"];
            _bookIcon = book[@"coverWap"];
            _bookName = book[@"bookName"];
            _author = book[@"author"];
            _introude = book[@"introduction"];
        }
        
    }else if (message.call == 171){
        if (message.resultCode == 0){
            //            LRLog(@"171---%@",message.responseData);
        }
    }
}

//需要扣费
- (void)needPayData:(NSDictionary *)dict{
    
    _isAutoBuy = YES;
    NSArray *lotsTips = dict[@"lotsTips"];
    if (lotsTips.count == 4) {//需要确认购买框
        
        [self setupFourOrderView:dict];
        
    } else if (lotsTips.count == 3) {
        
        [self setupThreeOrderView:dict];
        
    } else if (lotsTips.count == 2) {
        
        [self setupTwoOrderView:dict];
        
    } else if (lotsTips.count == 1) {
        
        [self setupOneOrderView:dict];
    } else {//不需要弹出
        NSArray *lotsTips = dict[@"lotsTips"];
        
        NSDictionary *dictNew = lotsTips[0];
        
        [self requestConsume197:dictNew];
        
        [self requestStoryContent:_currentChapter andIs:@(!_isLastPage) andIsCache:NO];
        
    }
}

- (void)batchThreeOrderView:(NSDictionary *)dict{
    
    _threeOrderView = [[ThreeOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 370, ScreenWidth, 370)];
    
    _threeOrderView.delegate = self;
    [_threeOrderView creatView];
    
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",[E_ReaderDataSource shareInstance].totalTitlArray[_batchIndex]];
    
    _threeOrderView.chaperNameLab.text = oneLabelStr;
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _threeOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _threeOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _threeOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *threeLotTip = lotsTips[2];
    _threeOrderView.thirtyBtn.moneyLabel.text = threeLotTip[@"lotsTips"];
    _threeOrderView.thirtyBtn.bottomLabel.text = threeLotTip[@"discountTips"];
    _threeOrderView.thirtyBtn.titleLab.text = threeLotTip[@"discount"];
    _threeOrderView.thirtyBtn.firstLabel.text = threeLotTip[@"totalPriceTips"];
    _threeOrderView.thirtyBtn.hidden = NO;
    _threeOrderView.thirtyBtn.oneDict = threeLotTip;
    _threeAction = threeLotTip[@"action"];
    
    
    NSDictionary *twoLotTip = lotsTips[1];
    _threeOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _threeOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _threeOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _threeOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _threeOrderView.tenBtn.hidden = NO;
    _threeOrderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    
    NSDictionary *oneLotTip = lotsTips[0];
    _threeOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _threeOrderView.fiveBtn.firstLabel.text = oneLotTip[@"totalPriceTips"];
    _threeOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"discountTips"];
    _threeOrderView.fiveBtn.titleLab.text = oneLotTip[@"discount"];
    
    _threeOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _threeOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"discountTips"]];
    _threeOrderView.fiveBtn.oneDict = oneLotTip;
    _threeOrderView.orderDict = oneLotTip;
    _threeOrderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
}

- (void)batchTwoOrderView:(NSDictionary *)dict{
    
    _twoOrderView = [[TwoOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 370, ScreenWidth, 370)];
    
    _twoOrderView.delegate = self;
    [_twoOrderView creatView];
    
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",[E_ReaderDataSource shareInstance].totalTitlArray[_batchIndex]];
    
    _twoOrderView.chaperNameLab.text = oneLabelStr;
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _twoOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _twoOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    }
    
    _twoOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    _twoOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _twoOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _twoOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _twoOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _twoOrderView.tenBtn.hidden = NO;
    _twoOrderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    
    NSDictionary *oneLotTip = lotsTips[0];
    _twoOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _twoOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"discountTips"];
    _twoOrderView.fiveBtn.titleLab.text = oneLotTip[@"discount"];
    _twoOrderView.fiveBtn.firstLabel.text = oneLotTip[@"totalPriceTips"];
    _twoOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _twoOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"discountTips"]];
    _twoOrderView.fiveBtn.oneDict = oneLotTip;
    _twoOrderView.orderDict = oneLotTip;
    _twoOrderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
}

- (void)batchOneOrderView:(NSDictionary *)dict{
    
    _oneOrderView = [[OneOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 310, ScreenWidth, 310)];
    
    _oneOrderView.delegate = self;
    [_oneOrderView creatView];
    
    NSString *chapterUnit = dict[@"chapterUnit"];
    if ([chapterUnit isEqualToString:@"本"]) {
        _oneOrderView.chaperNameLab.text = @"整本书出售";
    } else {
        
        NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",[E_ReaderDataSource shareInstance].totalTitlArray[_batchIndex]];
        
        _oneOrderView.chaperNameLab.text = oneLabelStr;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _oneOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _oneOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _oneOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _oneOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _oneOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _oneOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _oneOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _oneOrderView.fiveBtn.oneDict = oneLotTip;
    _oneOrderView.orderDict = oneLotTip;
    _oneOrderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
}

- (void)setupTwoOrderView:(NSDictionary *)dict{
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    
    _newtwoOrderView = [[NewTwoOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _newtwoOrderView.delegate = self;
    
    NSInteger afterNum = [twoLotTip[@"afterNum"] integerValue];
    if (afterNum < 10) {
        _newtwoOrderView.istenChapter = YES;
    }
    
    [_newtwoOrderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _newtwoOrderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _newtwoOrderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _newtwoOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _newtwoOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _newtwoOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    if (afterNum < 10) {
        
        _newtwoOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
        _newtwoOrderView.tenBtn.bottomLabel.text = twoLotTip[@"totalPriceTips"];
        _newtwoOrderView.tenBtn.hidden = NO;
        _newtwoOrderView.tenBtn.isFirstBtn = YES;
        _newtwoOrderView.tenBtn.oneDict = twoLotTip;
        
    } else {
        _newtwoOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
        _newtwoOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
        _newtwoOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
        _newtwoOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
        _newtwoOrderView.tenBtn.hidden = NO;
        _newtwoOrderView.tenBtn.oneDict = twoLotTip;
    }
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _newtwoOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _newtwoOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _newtwoOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _newtwoOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _newtwoOrderView.fiveBtn.oneDict = oneLotTip;
    _newtwoOrderView.orderDict = oneLotTip;
    _newtwoOrderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupThreeOrderView:(NSDictionary *)dict{
    
    _newthreeOrderView = [[NewThreeOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _newthreeOrderView.delegate = self;
    [_newthreeOrderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _newthreeOrderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _newthreeOrderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _newthreeOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _newthreeOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _newthreeOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *threeLotTip = lotsTips[2];
    _newthreeOrderView.thirtyBtn.moneyLabel.text = threeLotTip[@"lotsTips"];
    _newthreeOrderView.thirtyBtn.bottomLabel.text = threeLotTip[@"discountTips"];
    _newthreeOrderView.thirtyBtn.titleLab.text = threeLotTip[@"discount"];
    _newthreeOrderView.thirtyBtn.firstLabel.text = threeLotTip[@"totalPriceTips"];
    _newthreeOrderView.thirtyBtn.hidden = NO;
    _newthreeOrderView.thirtyBtn.oneDict = threeLotTip;
    _threeAction = threeLotTip[@"action"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    _newthreeOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _newthreeOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _newthreeOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _newthreeOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _newthreeOrderView.tenBtn.hidden = NO;
    _newthreeOrderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _newthreeOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _newthreeOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _newthreeOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _newthreeOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _newthreeOrderView.fiveBtn.oneDict = oneLotTip;
    _newthreeOrderView.orderDict = oneLotTip;
    _newthreeOrderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupFourOrderView:(NSDictionary *)dict{
    
    _orderView = [[OrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _orderView.delegate = self;
    [_orderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _orderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _orderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _orderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _orderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _orderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *fourLotTip = lotsTips[3];
    _orderView.fiftyBtn.moneyLabel.text = fourLotTip[@"lotsTips"];
    _orderView.fiftyBtn.bottomLabel.text = fourLotTip[@"discountTips"];
    _orderView.fiftyBtn.titleLab.text = fourLotTip[@"discount"];
    _orderView.fiftyBtn.firstLabel.text = fourLotTip[@"totalPriceTips"];
    _orderView.fiftyBtn.hidden = NO;
    _orderView.fiftyBtn.oneDict = fourLotTip;
    _fourAction = fourLotTip[@"action"];
    
    NSDictionary *threeLotTip = lotsTips[2];
    _orderView.thirtyBtn.moneyLabel.text = threeLotTip[@"lotsTips"];
    _orderView.thirtyBtn.bottomLabel.text = threeLotTip[@"discountTips"];
    _orderView.thirtyBtn.titleLab.text = threeLotTip[@"discount"];
    _orderView.thirtyBtn.firstLabel.text = threeLotTip[@"totalPriceTips"];
    _orderView.thirtyBtn.hidden = NO;
    _orderView.thirtyBtn.oneDict = threeLotTip;
    _threeAction = threeLotTip[@"action"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    _orderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _orderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _orderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _orderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _orderView.tenBtn.hidden = NO;
    _orderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _orderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _orderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _orderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _orderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _orderView.fiveBtn.oneDict = oneLotTip;
    _orderView.orderDict = oneLotTip;
    _orderView.fiveBtn.hidden = NO;
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupOneOrderView:(NSDictionary *)dict{
    
    _neworderView = [[NewOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 340, ScreenWidth, 340)];
    
    _neworderView.delegate = self;
    [_neworderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _neworderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _orderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _neworderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _neworderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    }
    
    _neworderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _neworderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _neworderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _neworderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _neworderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _neworderView.fiveBtn.oneDict = oneLotTip;
    _neworderView.orderDict = oneLotTip;
    
    _fiveAction = oneLotTip[@"action"];
    _action = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
}

- (void)clickOneTwoOrThree:(UIButton *)button{
    
    
    if (button.tag == 10) {
        _fiveAction = _action;
    } else if (button.tag == 11) {
        _fiveAction = _twoAction;
    } else if (button.tag == 12) {
        _fiveAction = _threeAction;
    } else if (button.tag == 13){
        _fiveAction = _fourAction;
    } else {
        _fiveAction = _action;
    }
}

- (void)clickOneTwoThreeOrFour:(UIButton *)button{
    
    if (button.tag == 10) {
        _fiveAction = _action;
    } else if (button.tag == 11) {
        _fiveAction = _twoAction;
    } else if (button.tag == 12) {
        _fiveAction = _threeAction;
    } else if (button.tag == 13) {
        _fiveAction = _fourAction;
    } else {
        _fiveAction = _action;
    }
}


#pragma mark - 解压Zip
- (void)decompressionZip:(NSString *)urlStr andChapterIds:(NSString *)chapterIdsStr andIsYesOrNo:(BOOL)isYesOrNo andIsCache:(BOOL)isCache{
    
    [SVProgressHUD dismiss];
    
    CatelogInforModel *chapter = [[JYS_SqlManager shareManager] getCatelogWithCatelogId:chapterIdsStr andFromBook:_bookID];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"MyCache"];
    NSString *componentStr = [NSString stringWithFormat:@"%@.txt",chapterIdsStr];//存入的名字
    NSString *textFilePath = [path stringByAppendingPathComponent:componentStr];
    int result= [self haveTextBianMa:[textFilePath UTF8String]];
    CFStringEncoding cfEncode = [self textEncodingTypeWithResult:result];
    NSError *err;
    NSString *contentString=[NSString stringWithContentsOfFile:textFilePath encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&err];
    //    NSString *contentString = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    if (chapter.path && contentString.length) {//本地数据库存过此章节的路径
        
        if(!contentString){
            contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000632 error:nil];
        }
        
        if(!contentString){
            contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000631 error:nil];
        }
        contentString = [self serializationString:contentString];
        if (!isCache) {
            E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
            chapter.chapterContent = contentString;
            [self parseChapter:chapter];
            [self initPageView:isYesOrNo];
        }
        
    } else {//本地数据库没有存过此章节的路径
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error){
            //保存到应用的caches目录。现在你已经把文件下载到了本地磁盘
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"MyCache"];
            BOOL isDir = YES;
            if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir ]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
            [data writeToFile:zipPath options:0 error:&error];
            
            
            if(!error){
                
                if ([self.za UnzipOpenFile:zipPath]) {
                    //
                    BOOL ret = [self.za UnzipFileTo:path overWrite:YES];
                    if (NO == ret){} [self.za UnzipCloseFile];
                    // 把解压出的内存写入caches目录
                    NSString *componentStr = [NSString stringWithFormat:@"%@.txt",chapterIdsStr];//存入的名字
                    NSString *textFilePath = [path stringByAppendingPathComponent:componentStr];
                    int result= [self haveTextBianMa:[textFilePath UTF8String]];
                    CFStringEncoding cfEncode = [self textEncodingTypeWithResult:result];
                    NSError *err;
                    NSString *contentString=[NSString stringWithContentsOfFile:textFilePath encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&err];
                    if (contentString.length) {//有内容
                        if(!contentString){
                            contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000632 error:nil];
                        }
                        
                        if(!contentString){
                            contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000631 error:nil];
                        }
                        
                        
                        contentString = [self serializationString:contentString];
                        
                        CatelogInforModel *chapter = [[JYS_SqlManager shareManager] getCatelogWithCatelogId:chapterIdsStr andFromBook:_bookID];
                        if(chapter == nil){
                            chapter = [CatelogInforModel new];
                            chapter.chaterId = chapterIdsStr;
                            chapter.entityid = [NSString stringWithFormat:@"%@%@",_bookID,chapterIdsStr];
                            chapter.bookid = _bookID;
                            chapter.url = urlStr;
                            chapter.path = textFilePath;
                            chapter.isDownload = @1;
                            [WHC_ModelSqlite insert:chapter];
                        }else{
                            chapter.entityid = [NSString stringWithFormat:@"%@%@",_bookID,chapterIdsStr];
                            chapter.bookid = _bookID;
                            chapter.chaterId = chapterIdsStr;
                            chapter.url = urlStr;
                            chapter.path = textFilePath;
                            chapter.isDownload = @1;
                            [WHC_ModelSqlite update:chapter where:[NSString stringWithFormat:@"entityid = %@%@",_bookID,chapter.chaterId]];
                        }
                        WEAKSELF
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!isCache) {
                                E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
                                
                                chapter.chapterContent = contentString;
                                [weakSelf parseChapter:chapter];
                                [weakSelf initPageView:isYesOrNo];
                            }
                        });
                    } else {//没有内容
                        
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            
                            [self requestStoryContent:_currentChapter andIs:NO andIsCache:NO];
                        });
                    }
                }
            }else{
                
            }
        }else{
            
        }
    }
    
}


- (void)sliderToChapterPage:(NSInteger)chapterIndex{
    
    [self showPage:chapterIndex - 1];
}

#pragma mark - 编码判断
-(int)haveTextBianMa:(const char*)strTxtPath{
    FILE* file;
    char buf[NUMBER_OF_SAMPLES];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    file = fopen(strTxtPath, "rt");
    if (file==NULL) {
        //        printf("文件打开失败！\n");
        return 1;
    }
    len = fread(buf, sizeof(char), NUMBER_OF_SAMPLES, file);
    fclose(file);
    
    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0)
    {
        //        printf("分析编码失败！\n");
        return -1;
    }
    uchardet_data_end(ud);
    //    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));
    encode=uchardet_get_charset(ud);
    
    uchardet_delete(ud);
    
    return 0;
}

- (CFStringEncoding)textEncodingTypeWithResult:(int)result{
    CFStringEncoding cfEncode = 0;
    if (result==0) {
        
        NSString *encodeStr=[[NSString alloc] initWithCString:encode encoding:NSUTF8StringEncoding];
        
        if ([encodeStr isEqualToString:@"gb18030"]) {
            
            cfEncode= kCFStringEncodingGB_18030_2000;
            
        }else if([encodeStr isEqualToString:@"Big5"]){
            
            cfEncode= kCFStringEncodingBig5;
            
        }else if([encodeStr isEqualToString:@"UTF-8"]){
            
            cfEncode= kCFStringEncodingUTF8;
            
        }else if([encodeStr isEqualToString:@"Shift_JIS"]){
            
            cfEncode= kCFStringEncodingShiftJIS;
            
        }else if([encodeStr isEqualToString:@"windows-1252"]){
            
            cfEncode= kCFStringEncodingWindowsLatin1;
            
        }else if([encodeStr isEqualToString:@"x-euc-tw"]){
            
            cfEncode= kCFStringEncodingEUC_TW;
            
        }else if([encodeStr isEqualToString:@"EUC-KR"]){
            
            cfEncode= kCFStringEncodingEUC_KR;
            
        }else if([encodeStr isEqualToString:@"EUC-JP"]){
            
            cfEncode= kCFStringEncodingEUC_JP;
            
        }
        
    }
    return cfEncode;
}

#pragma mark - 字符串替换
- (NSString *)serializationString:(NSString *)contentString{
    while([contentString containsString:@"\n"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
    }
    while([contentString containsString:@"\r\r"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r\r" withString:@"\r"];
    }
    while([contentString containsString:@"    "]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"    " withString:@""];
    }
    while([contentString containsString:@"\r "]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r " withString:@"\r"];
    }
    while([contentString containsString:@"\r　"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r　" withString:@"\r"];
    }
    
    
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\r" withString:@"\r\n　　"];
    return contentString;
}

#pragma mark - 点击侧边栏书签跳转
- (void)turnToClickMark:(E_Mark *)eMark{
    _isMyCurrent = NO;
    [self requestStoryContent:[eMark.markChapter integerValue] andIs:YES andIsCache:NO];
    
    //    if (_pageViewController) {
    //
    //        [_pageViewController.view removeFromSuperview];
    //        [_pageViewController removeFromParentViewController];
    //        _pageViewController = nil;
    //    }
    //    _pageViewController = [[UIPageViewController alloc] init];
    //    _pageViewController.delegate = self;
    //    _pageViewController.dataSource = self;
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    NSInteger showPage = [self findOffsetInNewPage:NSRangeFromString(eMark.markRange).location];
    [self showPage:showPage];
}

#pragma mark - 上一章
- (void)turnToPreChapter{
    
    if (_currentChapter <= 0) {
        [E_HUDView showMsg:@"已经是第一章" inView:self.view];
        return;
    }
    
    _isLastPage = YES;
    
    [self callToolBar];
    [self turnToClickChapter:_currentChapter - 1];
}

#pragma mark - 下一章
- (void)turnToNextChapter{
    
    if (_currentChapter == [E_ReaderDataSource shareInstance].totalChapter - 1) {
        
        if (_currentChapter == 19) {//去请求目录
            _isBatch110 = NO;
            _isCallDraw = NO;
            [self requestStoryMuenCall110];
        } else {
            if (_NewUpdate) {
                _isUpdate = YES;
                _isBatch110 = NO;
                _isCallDraw = NO;
                [self requestStoryMuenCall110];
            } else {
                if ([self.currentBook.isUpdate isEqualToNumber:@(1)]) {//有更新
                    _isUpdate = YES;
                    _isBatch110 = NO;
                    _isCallDraw = NO;
                    [self requestStoryMuenCall110];
                    
                } else {
                    [E_HUDView showMsg:@"已经是最后一章" inView:self.view];
                }
            }
            return;
        }
    }
    
    _isLastPage = NO;
    [self callToolBar];
    [self turnToClickChapter:_currentChapter + 1];
}

#pragma mark - 批量下载OneView购买确认框
- (void)oneOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    
    if ([_fiveAction isEqualToNumber:@(3)]) {
        
        //余额不足，跳转充值页面
        [self gotoRechargeVC:NO andDict:button.ensureDict];
    } else {//余额充足
        [SVProgressHUD showWithStatus:@"正在批量购买，请等待"];
        
        [self requestConsume197:button.ensureDict];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
        
    }
}


#pragma mark - 批量下载TwoView确定购买
- (void)twoOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {
        //余额不足，跳转充值页面
        [self gotoRechargeVC:NO andDict:button.ensureDict];
    } else {//余额充足
        [SVProgressHUD showWithStatus:@"正在批量购买，请等待"];
        
        [self requestConsume197:button.ensureDict];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
    }
}


#pragma mark - 批量下载ThreeView确认购买
- (void)threeOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {
        
        //余额不足，跳转充值页面
        [self gotoRechargeVC:NO andDict:button.ensureDict];
    } else {//余额充足
        [SVProgressHUD showWithStatus:@"正在批量购买，请等待"];
        
        [self requestConsume197:button.ensureDict];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
    }
}

#pragma mark - NewTwoOrderView自动订购下一章
- (void)newTwoOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}

#pragma mark - NewTwoOrderView关闭购买框
- (void)newTwoOrderViewCancelBtnClick{
    
    _currentChapter  = _menuChapter;
    _isOnlyOne = NO;
    _isMyCurrent = NO;
    
}

#pragma mark - NewTwoOrderView确认购买
- (void)newTwoOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {
        _currentChapter = _menuChapter;
        //余额不足，跳转充值页面
        [self gotoRechargeVC:YES andDict:button.ensureDict];
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        //请求上一章节还是下一章节还是当前章节
        [self requestLastOrNextOrCurrent];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
    }
}

#pragma mark - NewThreeOrderView自动订购下一章
- (void)newThreeOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}

#pragma mark - NewThreeOrderView关闭购买框
- (void)newThreeOrderViewCancelBtnClick{
    
    _currentChapter = _menuChapter;
    _isOnlyOne = NO;
    _isMyCurrent = NO;
    
}

#pragma mark - NewThreeOrderView确认购买
- (void)newThreeOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        _currentChapter = _menuChapter;
        //余额不足，跳转充值页面
        [self gotoRechargeVC:YES andDict:button.ensureDict];
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        //请求上一章节还是下一章节还是当前章节
        [self requestLastOrNextOrCurrent];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
    }
}

#pragma mark - NewOrderView自动订购下一章
- (void)newOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}

#pragma mark - NewOrderView关闭购买框
- (void)newOrderViewCancelBtnClick{
    
    _currentChapter  = _menuChapter;
    _isOnlyOne = NO;
    _isMyCurrent = NO;
    
}

#pragma mark - NewOrderView确认购买
- (void)newOrderViewEnsureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        _currentChapter = _menuChapter;
        //余额不足，跳转充值页面
        [self gotoRechargeVC:YES andDict:button.ensureDict];
    } else {//余额充足
        
        [self requestConsume197:button.ensureDict];
        
        //请求上一章节还是下一章节还是当前章节
        [self requestLastOrNextOrCurrent];
        
        
        //修改书支付情况
        [self amendBookConfirmStatus];
    }
}

#pragma mark - 自动订购下一章
- (void)autoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}

#pragma mark - 关闭购买确认框
- (void)cancelBtnClick{
    
    _currentChapter  = _menuChapter;
    
    _isOnlyOne = NO;
    _isMyCurrent = NO;
    
}


#pragma mark - 确认购买
- (void)ensureBtnClick:(EnsureButton *)button{
    _isMyCurrent = NO;
    if ([_fiveAction isEqualToNumber:@(3)]) {
        
        _currentChapter = _menuChapter;
        //余额不足，跳转充值页面
        [self gotoRechargeVC:YES andDict:button.ensureDict];
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        //请求上一章节还是下一章节还是当前章节
        [self requestLastOrNextOrCurrent];
        
        //修改书支付情况
        [self amendBookConfirmStatus];
        
    }
}



#pragma mark - 请求上一章节还是下一章节还是当前章节
- (void)requestLastOrNextOrCurrent{
    if (!_isLastPage) {
        if (_isAddOneChapter) {
            [self requestStoryContent:(_currentChapter) andIs:@(YES) andIsCache:NO];
        } else {
            [self requestStoryContent:(_currentChapter + 1) andIs:@(!_isLastPage) andIsCache:NO];
        }
    } else {
        [self requestStoryContent:(_currentChapter - 1) andIs:@(NO) andIsCache:NO];
    }
}

#pragma mark - 余额不足跳转支付页面   YES:飞批量下载的操作   NO:批量下载的操作
- (void)gotoRechargeVC:(BOOL)isOrderOrBatch andDict:(NSDictionary *)dict{

    RechargeController *rechargeVC = [[RechargeController alloc] init];
    
    NSInteger afterNum = [dict[@"afterNum"] integerValue];
    if (isOrderOrBatch && afterNum == 1) {
        rechargeVC.chapterName = _chapterName;
    }
    rechargeVC.bookName = _bookName;
    rechargeVC.priceStr = _priceStr;
    rechargeVC.priceUnit = _priceUnit;
    rechargeVC.isRechare = YES;
    [self presentViewController:rechargeVC animated:YES completion:nil];
}

#pragma mark - 修改书支付情况
- (void)amendBookConfirmStatus{
    
    if (_isAutoBuy) {
        self.ABModel = [JYS_SqlManager shareManager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_bookID forKey:@"bookID"];
        [dict setObject:@(1) forKey:@"isAutoBuy"];
        
        [self.ABModel amendAutoBuy:dict];
    }
}

#pragma mark - 消费（扣费）接口
- (void)requestConsume197:(NSDictionary *)dict{
    
    if (self.currentBook.isAddBook.integerValue == 0) {//没有添加到书架上
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLogo" object:nil];
        [self refreshBookRack];
        [self saveBookRack];
    }
    NSString *totalPrice = nil;
    NSString *discountPrice = nil;
    NSString *discountRate = nil;
    if (dict.count) {
        totalPrice = [NSString stringWithFormat:@"%@",dict[@"totalPrice"]];
        _afterNum = [NSString stringWithFormat:@"%@",dict[@"afterNum"]];
        discountPrice = [NSString stringWithFormat:@"%@",dict[@"discountPrice"]];
        discountRate = dict[@"discountRate"];
    } else {
        discountPrice = self.currentBook.price;
        _afterNum = @"1";
        totalPrice = self.currentBook.sourceFrom;
        discountRate = self.currentBook.marketId;
    }
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSString *lastChapterId = chapterIdListArray.lastObject;
    
    self.consumeModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"bookId"] = _bookID;
    requestData[@"totalPrice"] = totalPrice;
    if ([_chapterUnit isEqualToString:@"本"]) {
        requestData[@"afterNum"] = @"";
    } else {
        requestData[@"afterNum"] = _afterNum;
    }
    
    if (![_afterNum isEqualToString:@"1"]) {
        requestData[@"discountRate"] = discountRate;
    }
    requestData[@"discountPrice"] = discountPrice;
    requestData[@"baseChapterId"] = _consumeChapterID;
    requestData[@"position"] = @"0";
    requestData[@"readAction"] = @"1";
    requestData[@"lastChapterId"] = lastChapterId;
    requestData[@"marketStatus"] = @"4";
    [self.consumeModel registerAccountAndCall:197 andRequestData:requestData];
}

//保存到书架上
- (void)saveBookRack{
    
    _haveBookRack = YES;
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSMutableDictionary *dicta = [[NSMutableDictionary alloc] init];
    [dicta setObject:_bookID forKey:@"bookId"];
    [dicta setObject:_bookIcon forKey:@"coverWap"];
    [dicta setObject:_author forKey:@"author"];
    [dicta setObject:_introude forKey:@"introduction"];
    [dicta setObject:_bookName forKey:@"bookName"];
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSString *lastChapterID = chapterIdListArray[chapterIdListArray.count - 1];
    
    NSMutableDictionary *lastChap = [[NSMutableDictionary alloc] init];
    [lastChap setObject:lastChapterID forKey:@"chapterId"];
    
    NSString *chapterID = [E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter];
    NSMutableDictionary *chapterListDict = [[NSMutableDictionary alloc] init];
    [chapterListDict setObject:chapterID forKey:@"chapterId"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:chapterListDict];
    
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    [mutableDict setObject:dateString forKey:@"dateTime"];
    [mutableDict setObject:dicta forKey:@"book"];
    [mutableDict setObject:lastChap forKey:@"lastChapterInfo"];
    [mutableDict setObject:array forKey:@"chapterList"];
    
    self.DBModel = [JYS_SqlManager shareManager];
    [self.DBModel insertData:mutableDict];
    
}

#pragma mark - 隐藏设置bar
- (void)hideTheSettingBar{
    
    if (_settingToolBar == nil) {
        
    }else{
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [_markBtn removeFromSuperview];
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    if (_settingBottomBar == nil) {
        
    }else{
        
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        
        [_settingSecondBotBar hideToolBar];
        _settingSecondBotBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}


#pragma mark --
- (void)parseChapter:(E_EveryChapter *)chapter
{
    self.chapterContent_ = chapter.chapterContent;
    self.chapterTitle_ = chapter.chapterTitle;
    [self configPaginater];
}

- (void)configPaginater
{
    _paginater = [[E_Paging alloc] init];
    E_ReaderViewController *temp = [[E_ReaderViewController alloc] init];
    NSMutableArray *array = [E_ReaderDataSource shareInstance].totalTitlArray;
    if (_currentChapter >= array.count) {
        _currentChapter = array.count - 1;
    }
    NSString *chapterName = nil;
    if ( [E_ReaderDataSource shareInstance].totalTitlArray.count>_currentChapter) {
        chapterName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];

    }
    
    temp.chapterTitle = chapterName;
    
    float currentPage = [[NSString stringWithFormat:@"%ld",(long)_readPage] floatValue] ;
    float totalPage = [[NSString stringWithFormat:@"%ld",(unsigned long)_paginater.pageCount] floatValue];
    
    temp.progressRatio = currentPage/totalPage;
    
    temp.bookName = _bookName;
    temp.delegate = self;
    [temp view];
    _paginater.contentFont = self.fontSize;
    _paginater.textRenderSize = [temp readerTextSize];
    _paginater.contentText = self.chapterContent_;
    [_paginater paginate];
    
    if (_isIndex) {
        [SVProgressHUD dismiss];
        _isIndex = NO;
    }
}

- (void)readPositionRecord
{
    NSInteger currentPage = [_pageViewController.viewControllers.lastObject currentPage];
    NSRange range = [_paginater rangeOfPage:currentPage];
    self.readOffset = range.location;
}

- (void)fontSizeChanged:(int)fontSize
{
    [self readPositionRecord];
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    NSInteger showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage:showPage];
}

#pragma mark - 直接隐藏多功能下拉按钮
- (void)hideMultifunctionButton{
    if (_searchBtn) {
        [_shareBtn removeFromSuperview];_shareBtn = nil;[_markBtnNew removeFromSuperview];_markBtnNew = nil;[_searchBtn removeFromSuperview];_searchBtn = nil;
    }
}

#pragma mark - 标签按钮点击
- (void)clickMarkButton{
    
    [self doMark];
}

#pragma mark - 返回按钮
- (void)goBack{
    
    [SVProgressHUD dismiss];
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSArray *chapterNameList = [E_ReaderDataSource shareInstance].totalTitlArray;
    NSString *chapterId = nil;
    NSString *chapterName = nil;
    
    
    chapterId = chapterIdListArray[_currentChapter];
    chapterName = chapterNameList[_currentChapter];
    
    //上传书籍阅读进度
    if (IsLogin) {
        [self saveBookReadProgress:chapterId];
    }
    
    if (self.currentBook.isAddBook.integerValue == 0) {//没有添加到书架上
        
        if (_haveBookRack) {//已经添加到书架上了
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLogo" object:nil];
            [self backRackViewCancelBtnClick];
        } else {
            
            _backRackView = [[BackRackView alloc] init];
            _backRackView.delegate = self;
            [_backRackView creatView];
        }
        
    } else {//已经添加到书架上了
        
        //刷新书架
        [self refreshBookRack];
        
        NSArray *chapterArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
        NSString *lastChapter = chapterArray[chapterArray.count - 1];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
        [mutableDict setObject:dateString forKey:@"dateTime"];
        [mutableDict setObject:_bookID forKey:@"bookID"];
        
        if (_lastChapterID.length) {
            [mutableDict setObject:_lastChapterID forKey:@"updateChapter"];
        } else {
            if (!_NoUpdateChapter) {
                [mutableDict setObject:lastChapter forKey:@"updateChapter"];
            }
        }

        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_bookID forKey:@"bookID"];
        [dict setObject:@(_readPage) forKey:@"currentPageIndex"];
        [dict setObject:@(_currentChapter) forKey:@"chapterIndex"];
        if (chapterName.length) {
            [dict setObject:chapterName forKey:@"chapterName"];
        }else{
            [dict setObject:@"未知章节" forKey:@"chapterName"];
        }
        if (_bookIcon.length) {
            [dict setObject:_bookIcon forKey:@"bookIcon"];
        } else {
            [dict setObject:@"" forKey:@"bookIcon"];
        }
        if (_bookName.length) {
            [dict setObject:_bookName forKey:@"bookName"];
        } else {
            [dict setObject:@"" forKey:@"bookName"];
        }
        if (_author.length) {
            [dict setObject:_author forKey:@"author"];
        } else {
            [dict setObject:@"" forKey:@"author"];
        }
        if (_introude.length) {
            [dict setObject:_introude forKey:@"introduce"];
        } else {
            [dict setObject:@"" forKey:@"introduce"];
        }
        
        [dict setObject:dateString forKey:@"dateString"];
        [dict setObject:chapterId forKey:@"chapterID"];
        
        JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
        [DBModel insertReadBook:dict];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}
#pragma mark - 是否加入书架取消按钮
- (void)backRackViewCancelBtnClick{
    
    [_backRackView removeFromSuperview];
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSString *chapterId = nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_bookID forKey:@"bookID"];
    [dict setObject:@(_readPage) forKey:@"currentPageIndex"];
    [dict setObject:@(_currentChapter) forKey:@"chapterIndex"];
    
    chapterId = chapterIdListArray[_currentChapter];
    NSString *chapterName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];
    if (chapterName.length) {
        [dict setObject:chapterName forKey:@"chapterName"];
    }else{
        [dict setObject:@"未知章节" forKey:@"chapterName"];
    }
    
    
    [dict setObject:_bookIcon forKey:@"bookIcon"];
    [dict setObject:_bookName forKey:@"bookName"];
    [dict setObject:_author forKey:@"author"];
    [dict setObject:_introude forKey:@"introduce"];
    [dict setObject:dateString forKey:@"dateString"];
    [dict setObject:chapterId forKey:@"chapterID"];
    
    JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
    [DBModel insertReadBook:dict];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 是否加入书架确定按钮
- (void)backRackViewEnsureBtnClick{
    
    //刷新书架
    [self refreshBookRack];
    
    [_backRackView removeFromSuperview];
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSMutableDictionary *dicta = [[NSMutableDictionary alloc] init];
    [dicta setObject:_bookID forKey:@"bookId"];
    [dicta setObject:_bookIcon forKey:@"coverWap"];
    [dicta setObject:_author forKey:@"author"];
    [dicta setObject:_introude forKey:@"introduction"];
    [dicta setObject:_bookName forKey:@"bookName"];
    
    NSString *chapterID = [E_ReaderDataSource shareInstance].chapterIdListArray[_currentChapter];
    NSMutableDictionary *chapterListDict = [[NSMutableDictionary alloc] init];
    [chapterListDict setObject:chapterID forKey:@"chapterId"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:chapterListDict];
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSString *lastChapterID = chapterIdListArray[chapterIdListArray.count - 1];
    
    NSMutableDictionary *lastChapter = [[NSMutableDictionary alloc] init];
    if (_lastChapterID.length) {
        [lastChapter setObject:_lastChapterID forKey:@"chapterId"];
    } else {
        [lastChapter setObject:lastChapterID forKey:@"chapterId"];
    }
    
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    [mutableDict setObject:dateString forKey:@"dateTime"];
    [mutableDict setObject:dicta forKey:@"book"];
    [mutableDict setObject:array forKey:@"chapterList"];
    
    
    [mutableDict setObject:lastChapter forKey:@"lastChapterInfo"];
    self.DBModel = [JYS_SqlManager shareManager];
    [self.DBModel insertData:mutableDict];
    NSString *chapterName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_bookID forKey:@"bookID"];
    [dict setObject:@(_readPage) forKey:@"currentPageIndex"];
    [dict setObject:@(_currentChapter) forKey:@"chapterIndex"];
    
    if (chapterName.length) {
        [dict setObject:chapterName forKey:@"chapterName"];
    }else{
        [dict setObject:@"未知章节" forKey:@"chapterName"];
    }
    NSString *chapterId = chapterIdListArray[_currentChapter];
    
    
    [dict setObject:_bookIcon forKey:@"bookIcon"];
    [dict setObject:_bookName forKey:@"bookName"];
    [dict setObject:_author forKey:@"author"];
    [dict setObject:_introude forKey:@"introduce"];
    [dict setObject:dateString forKey:@"dateString"];
    [dict setObject:chapterId forKey:@"chapterID"];
    
    JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
    [DBModel insertReadBook:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLogo" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 动画显示或隐藏多功能下拉按钮
- (void)showMultifunctionButton{
    
    if (_searchBtn) {
        DELAYEXECUTE(0.15,{[_shareBtn removeFromSuperview];_shareBtn = nil;DELAYEXECUTE(0.12, {[_markBtnNew removeFromSuperview];_markBtnNew = nil;DELAYEXECUTE(0.09, [_searchBtn removeFromSuperview];_searchBtn = nil;);});});
        return;
    }
    
    _searchBtn = [UIButton buttonWithType:0];
    _searchBtn.frame = CGRectMake(self.view.frame.size.width - 70, 20 + 44 + 16, 44, 44);
    [_searchBtn setTitle:@"搜索" forState:0];
    _searchBtn.titleLabel.font = Font14;
    _searchBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _searchBtn.layer.cornerRadius = 22;
    [_searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    
    NSRange range = [_paginater rangeOfPage:_readPage];
    if ([E_CommonManager checkIfHasBookmark:range withChapter:_currentChapter]) {
        _markBtn.selected = YES;
    }else{
        _markBtn.selected = NO;
    }
    
    if (_markBtn.selected == YES) {
        
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
        
    }else{
        
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    _markBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_markBtn addTarget:self action:@selector(doMark) forControlEvents:UIControlEventTouchUpInside];
    
    _shareBtn = [UIButton buttonWithType:0];
    _shareBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _shareBtn.frame = CGRectMake(self.view.frame.size.width - 70, 20 + 44 + 16 + 44 + 16 + 44 + 16, 44, 44);
    [_shareBtn setTitle:@"分享" forState:0];
    _shareBtn.layer.cornerRadius = 22;
    [_shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    
    DELAYEXECUTE(0.15,{[self.view addSubview:_searchBtn];DELAYEXECUTE(0.12, {[self.view addSubview:_markBtnNew];DELAYEXECUTE(0.09, [self.view addSubview:_shareBtn]);});});
    
}

#pragma mark - 多功能按钮群中的搜索按钮触发事件
- (void)doSearch{
    
    [self hideMultifunctionButton];
    [self hideTheSettingBar];
    //    sideBar.singleTap.enabled = NO;
    E_SearchViewController *searchVc = [[E_SearchViewController alloc] init];
    searchVc.delegate = self;
    [self presentViewController:searchVc animated:YES completion:NULL];
}

- (void)doShare{
    
}

#pragma mark - 书签
- (void)doMark{
    
    _markBtn.selected = !_markBtn.selected;
    if (_markBtn.selected == YES) {
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
    }else{
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    
    NSRange range = [_paginater rangeOfPage:_readPage];
    [E_CommonManager saveCurrentMark:_currentChapter andChapterRange:range byChapterContent:_paginater.contentText];
}

#pragma mark - searchViewControllerDelegate -
- (void)turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord{
    
    _searchWord = keyWord;
    
    E_EveryChapter *e_chapter = [[E_ReaderDataSource shareInstance] openChapter:[chapter integerValue]];//加1 是因为indexPath.row从0 开始的
    _currentChapter = [chapter integerValue];
    [self parseChapter:e_chapter];
    
    if (_pageViewController) {
        
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    NSInteger showPage = [self findOffsetInNewPage:searchRange.location - [[E_ReaderDataSource shareInstance] getChapterBeginIndex:[chapter integerValue]]];
    [self showPage:showPage];
}

#pragma mark - 退出APP记录当前此时的阅读记录
- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    if (self.currentBook.isAddBook.integerValue == 1) {//已经在书架上
        
        //        [self saveBookRack];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
        [mutableDict setObject:dateString forKey:@"dateTime"];
        [mutableDict setObject:_bookID forKey:@"bookID"];
        
    }
    
    [self refreshBookRack];
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSString *chapterId = nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_bookID forKey:@"bookID"];
    [dict setObject:@(_readPage) forKey:@"currentPageIndex"];
    [dict setObject:@(_currentChapter) forKey:@"chapterIndex"];
    
    chapterId = chapterIdListArray[_currentChapter];
    
    NSString *chapterName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];
    if (chapterName.length) {
        [dict setObject:chapterName forKey:@"chapterName"];
    }else{
        [dict setObject:@"未知章节" forKey:@"chapterName"];
    }
    
    if (_bookIcon.length) {
        [dict setObject:_bookIcon forKey:@"bookIcon"];
    } else {
        [dict setObject:@"" forKey:@"bookIcon"];
    }
    if (_bookName.length) {
        [dict setObject:_bookName forKey:@"bookName"];
    } else {
        [dict setObject:@"" forKey:@"bookName"];
    }
    if (_author.length) {
        [dict setObject:_author forKey:@"author"];
    } else {
        [dict setObject:@"" forKey:@"author"];
    }
    if (_introude.length) {
        [dict setObject:_introude forKey:@"introduce"];
    } else {
        [dict setObject:@"" forKey:@"introduce"];
    }
    [dict setObject:dateString forKey:@"dateString"];
    [dict setObject:chapterId forKey:@"chapterID"];
    
    JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
    [DBModel insertReadBook:dict];
    
    //上传书籍阅读进度
    if (IsLogin && application) {
        [self saveBookReadProgress:chapterId];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 回掉第二次批量下载按钮
- (void)secondIsBtach{
    
    
    _isBatch = YES;
    
    NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
    NSArray *chapterNameListArray = [E_ReaderDataSource shareInstance].totalTitlArray;
    if ((_currentChapter == chapterIdListArray.count-1) || (_currentChapter == chapterIdListArray.count-2)) {
        [E_HUDView showMsg:@"末章暂不支持批量下载" inView:self.view];
        return;
    }
    [[AppDelegate sharedApplicationDelegate].window showLoadingView];
    
    NSString *chapterId = @"";
    NSString *chapterName = @"";
    NSString *lastChapter = @"";
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    
    for (NSInteger i = _currentChapter; i < chapterIdListArray.count; i ++) {
        chapterId = chapterIdListArray[i];
        
        CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
        
        if (catelog.isPay) {
            if (catelog.isPay.integerValue == 1) {//需要付费
                _batchIndex = i;
                lastChapter = chapterId;
                _consumeChapterIndex = i;
                chapterName = chapterNameListArray[i];
                break;
            }
        } else {
            
            if (_chargeListArray.count > i) {
                NSString *ispay = _chargeListArray[i];
                if ([ispay isEqualToString:@"1"]) {
                    _batchIndex = i;
                    lastChapter = chapterId;
                    _consumeChapterIndex = i;
                    chapterName = chapterNameListArray[i];
                    break;
                }
            } else {
                NSInteger countI = i - _currentChapter;
                NSString *ispay = @"";
                if (countI > _chargeListArray.count) {
                    ispay = _chargeListArray[0];
                } else {
                    ispay = _chargeListArray[countI];
                }
                
                if ([ispay isEqualToString:@"1"]) {
                    _batchIndex = i;
                    lastChapter = chapterId;
                    _consumeChapterIndex = i;
                    chapterName = chapterNameListArray[i];
                    break;
                }
            }
        }
    }
    
    _isAddOneChapter = NO;
    
    //获得支付弹框的信息
    [self requestPayCheck196:lastChapter andChapterName:chapterName];
}

#pragma mark - 批量下载按钮
- (void)batchBtnClick{
    
    if ([self.currentBook.marketStatus isEqualToNumber:@(3)]) {//今日限免
        
        [SVProgressHUD showWithStatus:@"限免书籍无需购买"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } else {
        if (_NewUpdate) {//有更新的章节
            _isUpdate  = YES;
            _isBatch110 = YES;
            _isCallDraw = NO;
            
            [self requestStoryMuenCall110];
        } else {
            
            if ([self.currentBook.isUpdate isEqualToNumber:@(1)]||self.dataArray.count<21) {//有更新
                _isBatch110 = YES;
                _isCallDraw = NO;
                _isUpdate = YES;
                
                [self requestStoryMuenCall110];
                
            } else {
                
                _isBatch = YES;
                
                NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
                NSArray *chapterNameListArray = [E_ReaderDataSource shareInstance].totalTitlArray;
                if ((_currentChapter == chapterIdListArray.count-1) || (_currentChapter == chapterIdListArray.count-2)) {
                    [E_HUDView showMsg:@"末章暂不支持批量下载" inView:self.view];
                    return;
                }
                [[AppDelegate sharedApplicationDelegate].window showLoadingView];
                
                NSString *lastChapter = @"";
                NSString *chapterName = @"";
                
                
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                
                NSArray *chargeArray = [dataManager getPaymentStatusWithCurrentCatelog:self.curretCatelogModel.chaterId andCount:0 fromBook:_bookID];
                if (chargeArray.count) {
                    CatelogInforModel *catelog = chargeArray[0];
                    lastChapter = catelog.chaterId;
                }
                for (CatelogInforModel *catelogs in self.dataArray) {
                    if ([catelogs.chaterId isEqualToString:lastChapter]) {
                        _batchIndex = [self.dataArray indexOfObject:catelogs];
                        _consumeChapterIndex = [self.dataArray indexOfObject:catelogs];
                        break;
                    }
               }
                _isAddOneChapter = NO;
                
                //获得支付弹框的信息
                [self requestPayCheck196:lastChapter andChapterName:chapterName];
                
            }
        }
    }
}

#pragma mark - 第二次触发目录
- (void)secondIsCallDraw{
    
    [self callToolBar];
    
    [self.myView removeFromSuperview];
    tapGesRec.enabled = NO;
    WEAKSELF
    DELAYEXECUTE(0.18, {E_DrawerView *drawerView = [[E_DrawerView alloc] initWithFrame:weakSelf.view.frame parentView:weakSelf.view];
        drawerView.delegate = weakSelf;
        drawerView.bookID = _bookID;
        drawerView.myIndex = _currentChapter;
        [drawerView configUI];
        [weakSelf.view addSubview:drawerView];});
    
}


#pragma mark - 目录触发事件
- (void)callDrawerView{
    
    if (_NewUpdate) {//有更新的章节
        _isUpdate = YES;
        _isBatch110 = NO;
        _isCallDraw = YES;
        
        
        [self requestStoryMuenCall110];
    } else {
        
        if (self.dataArray.count<20 ||[self.currentBook.isUpdate isEqualToNumber:@(1)]) {//有更新
            if ([self.currentBook.isUpdate isEqualToNumber:@(1)]) {
                _isUpdate = YES;

            }
            _isBatch110 = NO;
            _isCallDraw = YES;
            [self requestStoryMuenCall110];
        } else {
            
            [self callToolBar];
            
            [self.myView removeFromSuperview];
            tapGesRec.enabled = NO;
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                E_DrawerView *drawerView = [[E_DrawerView alloc] initWithFrame:weakSelf.view.frame parentView:weakSelf.view];
                drawerView.delegate = weakSelf;
                drawerView.bookID = _bookID;
                drawerView.myIndex = _currentChapter;
                [drawerView configUI];
                [weakSelf.view addSubview:drawerView];
            });
        }
    }
}


#pragma mark - 底部右侧按钮触发事件
- (void)callCommentView{
    
    E_CommentViewController *e_commentVc = [[E_CommentViewController alloc] init];
    [self presentViewController:e_commentVc animated:YES completion:NULL];
    
}

- (void)openTapGes{
    
    [[AppDelegate sharedApplicationDelegate].window addSubview:self.myView];
    tapGesRec.enabled = YES;
}

#pragma mark - 改变主题
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme{
    
    if (theme == 1) {
        _themeImage = nil;
    } else {
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_g%ld.png",(long)theme]];
        
    }
    
    [self showPage:self.readPage];
}

#pragma mark - 根据偏移值找到新的页码
- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset{
    
    NSInteger pageCount = _paginater.pageCount;
    
    for (int i = 0; i < pageCount; i++) {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset) {
            return i;
        }
    }
    return 0;
}

//显示第几页
- (void)showPage:(NSUInteger)page{
    
    _isNextChapter = NO;
    _isMyCurrent = NO;
    
    E_ReaderViewController *readerController = [self readerControllerWithPage:page];
    
    [_pageViewController setViewControllers:@[readerController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL f){
    }];
}

#pragma mark - 夜间白天切换
- (void)nightBtnClick{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        [_settingBottomBar.nightBtn setTitle:@"夜间" forState:UIControlStateNormal];
        [_settingBottomBar.nightBtn setImage:[UIImage imageNamed:@"reader_icon_Night_n"] forState:UIControlStateNormal];
        [AppDelegate sharedApplicationDelegate].nightView.alpha = 0.0;
        
    } else {
        [_settingBottomBar.nightBtn setTitle:@"日间" forState:UIControlStateNormal];
        [_settingBottomBar.nightBtn setImage:[UIImage imageNamed:@"reader_icon_Day_n"] forState:UIControlStateNormal];
        
        [AppDelegate sharedApplicationDelegate].nightView.alpha = NightAlpha;
    }
    
    
    [userDefaults setObject:@([AppDelegate sharedApplicationDelegate].nightView.alpha) forKey:@"NightAlpha"];
    [self showPage:self.readPage];
}

#pragma mark - 点击页面进入上下章节
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    _isMunClick = NO;
    
    // 滑动屏幕
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (_isBar) {
            
            _isAddOneChapter = NO;
            
            _isBatch = NO;
            if (_readPage >= (unsigned long)self.lastPage && (_readPage != 0) && (([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x <= 0) )) {
                
                //滑动往下一章
                [self gotoNextChapter];
                return NO;
                
            } else if ((_readPage <= 0 && ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x >= 0))) {
                
                //滑动往前一章
                [self gotoLastChapter];
                
                return NO;
                
            } else {
                //滑动是否跳转下一页
                return [self slideGotoNextPage:gestureRecognizer];
            }
            
        } else {
            
            [self callToolBar];
            return NO;
        }
    }
    
    // 点击屏幕
    if ([gestureRecognizer isKindOfClass:[UIGestureRecognizer class]]) {
        if (_isBar) {
            
            _isAddOneChapter = NO;
            
            _isBatch = NO;
            
            if (_readPage >= (unsigned long)self.lastPage && (_readPage != 0) && (([gestureRecognizer isKindOfClass:[UIGestureRecognizer class]] && [(UIGestureRecognizer *)gestureRecognizer locationInView:self.view].x > (ScreenWidth - 120 * KKuaikan)))) {
                
                //点击往下一章
                [self gotoNextChapter];
                return NO;
                
            } else if (_readPage <= 0 && (_readPage <= 0 && ([gestureRecognizer isKindOfClass:[UIGestureRecognizer class]] && [(UIGestureRecognizer *)gestureRecognizer locationInView:self.view].x < 120 * KKuaikan))) {
                
                //点击往前一章
                [self gotoLastChapter];
                
                return NO;
                
            } else {
                //点击是否跳转下一页
                return [self clickNextPage:gestureRecognizer];
            }
            
        } else {
            [self callToolBar];
            return NO;
        }
    } else {
        return NO;
    }
}

//点击是否跳转下一页
- (BOOL)clickNextPage:(UIGestureRecognizer *)gestureRecognizer{
    if (_isKuaisu) {
        
        if (_readPage >= self.lastPage) {
            //                        return NO;
            //如果点击屏幕左侧向前翻页，原先卡在这儿了
            if ([(UIGestureRecognizer *)gestureRecognizer locationInView:self.view].x < 120 * KKuaikan) {
                
                return YES;
            } else {
                
                return NO;
            }
            
        } else {
            
            return YES;
        }
    } else {
        return NO;
    }
}

//滑动是否跳转下一页
- (BOOL)slideGotoNextPage:(UIGestureRecognizer *)gestureRecognizer{

    if (_isKuaisu) {
        if (_readPage <= 0) {
            if ([(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x < [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].y) {
                
                return YES;
            } else {
                
                return NO;
            }
        } else {
            if (_readPage >= self.lastPage) {
                
                LRLog(@"x===%f",[(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x);
                LRLog(@"y===%f",[(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].y);
                
                if (([(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x > [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].y) && ([(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].y > 0)) {
                    
                    return YES;
                } else {
                    
                    return NO;
                }
            } else {
                return YES;
            }
        }
    } else {
        
        return NO;
    }
}

//手势点击或者滑动往下一章
- (void)gotoNextChapter{

    _isNotLast = YES;
    
    NSInteger totalChapter = [E_ReaderDataSource shareInstance].totalChapter - 1;
    
    if ((_currentChapter == totalChapter) && totalChapter != 0){ //最后一章节
        
        if (_currentChapter == 19) {//去请求目录
            _isBatch110 = NO;
            _isCallDraw = NO;
            [self requestStoryMuenCall110];
        } else {
            if (_NewUpdate) {
                _isUpdate = YES;
                _isBatch110 = NO;
                _isCallDraw = NO;
                
                [self requestStoryMuenCall110];
            } else {
                if ([self.currentBook.isUpdate isEqualToNumber:@(1)]) {//有更新
                    
                    _isUpdate = YES;
                    _isBatch110 = NO;
                    _isCallDraw = NO;
                    
                    [self requestStoryMuenCall110];
                } else {
                    [E_HUDView showMsg:@"已经是最后一章了" inView:nil];
                }
            }
        }
    } else {
        if (!_isMyCurrent) {
            
            _menuChapter = _currentChapter;
            _isLastPage = NO;
            
            NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
            NSArray *chapterNameListArray = [E_ReaderDataSource shareInstance].totalTitlArray;
            NSString *chapterId = chapterIdListArray[_currentChapter + 1];
            NSString *chapterName = chapterNameListArray[_currentChapter + 1]
            ;
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
            
            if ([self.currentBook.marketStatus isEqualToNumber:@(3)]) {//限免
                [self requestStoryContent:_currentChapter + 1 andIs:YES andIsCache:NO];
            } else {//非限免
                if (catelog.isPay.integerValue == 1) {//需要付费
                    
                    if ([self.currentBook.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
                        
                        _consumeChapterID = chapterId;
                        _consumeChapterName = chapterName;
                        
                        NSDictionary *dict = nil;
                        [self requestConsume197:dict];
                        
                        [self requestStoryContent:_currentChapter + 1 andIs:YES andIsCache:NO];
                        
                    } else {//需要弹框确认购买
                        
                        if (!_isOnlyOne) {
                            [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeBlack];
                            _isOnlyOne = YES;
                            [self requestPayCheck196:chapterId andChapterName:chapterName];
                            
                        } else {
                            _isOnlyOne = NO;
                            
                        }
                        _isNextChapter = YES;
                    }
                    
                } else {//不需付费
                    
                    [self requestStoryContent:_currentChapter + 1 andIs:YES andIsCache:NO];
                }
            }
        }
    }
}

//手势点击或者滑动往前一章
- (void)gotoLastChapter{

    if (_currentChapter <= 0) {
        [E_HUDView showMsg:@"已经是第一章了" inView:nil];
    } else {
        
        if (!_isMyCurrent) {
            
            _menuChapter = _currentChapter;
            
            _isLastPage = YES;
            
            NSArray *chapterIdListArray = [E_ReaderDataSource shareInstance].chapterIdListArray;
            NSArray *chapterNameListArray = [E_ReaderDataSource shareInstance].totalTitlArray;
            NSString *chapterId = chapterIdListArray[_currentChapter - 1];
            NSString *chapterName = chapterNameListArray[_currentChapter - 1];
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
            
            
            if ([self.currentBook.marketStatus isEqualToNumber:@(3)]) {//限免
                [self requestStoryContent:_currentChapter - 1 andIs:NO andIsCache:NO];
            } else {//非限免
                if (catelog.isPay.integerValue == 1) {//需要付费
                    
                    if ([self.currentBook.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
                        _consumeChapterID = chapterId;
                        _consumeChapterName = chapterName;
                        
                        NSDictionary *dict = nil;
                        [self requestConsume197:dict];
                        
                        [self requestStoryContent:_currentChapter - 1 andIs:NO andIsCache:NO];
                        
                    } else {//需要弹框确认购买
                        
                        if (!_isOnlyOne) {
                            [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeBlack];
                            _isOnlyOne = YES;
                            [self requestPayCheck196:chapterId andChapterName:chapterName];
                        } else {
                            
                            _isOnlyOne = NO;
                        }
                    }
                    
                } else {//不需付费
                    
                    [self requestStoryContent:_currentChapter - 1 andIs:NO andIsCache:NO];
                }
            }
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return YES;
}

- (E_ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    
    _readPage = page;
    E_ReaderViewController *textController = [[E_ReaderViewController alloc] init];
    textController.delegate = self;
    
    NSString *chapterName = [E_ReaderDataSource shareInstance].totalTitlArray[_currentChapter];
    
    textController.chapterTitle = chapterName;
    
    float currentPage = [[NSString stringWithFormat:@"%ld",(long)_readPage] floatValue];
    float totalPage = [[NSString stringWithFormat:@"%ld",(unsigned long)_paginater.pageCount] floatValue] - 1;
    textController.progressRatio = currentPage/totalPage;
    
    textController.bookName = _bookName;
    textController.keyWord = _searchWord;
    textController.themeBgImage = _themeImage;
    textController.view.backgroundColor = [UIColor blackColor];
    
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        textController.view.backgroundColor = ADColor(30, 33, 39);
        textController.isNightText = YES;
    } else {
        textController.view.backgroundColor = (_themeImage == nil)?WhiteColor:[UIColor colorWithPatternImage:_themeImage];
        textController.isNightText = NO;
    }
    
    [textController view];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    
    textController.font = self.fontSize;
    textController.text = [_paginater stringOfPage:page];
    
    if (_settingBottomBar) {
        
        float currentPage = [[NSString stringWithFormat:@"%ld",(long)_readPage] floatValue] + 1;
        float totalPage = [[NSString stringWithFormat:@"%ld",(unsigned long)textController.totalPage] floatValue];
        
        float percent;
        if (currentPage == 1) {//强行放置头部
            percent = 0;
        }else{
            percent = currentPage/totalPage;
        }
        
        [_settingBottomBar changeSliderRatioNum:percent];
    }
    
    _searchWord = nil;
    return textController;
}


#pragma mark - 向左翻页
//当页面视图控制器已经有一个视图控制器在屏幕里并需要知道下一个即将要显示的视图控制器时将调用
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    _isKuaisu = NO;
    _isTurnOver = NO;
    _isRight = NO;
    
    
    E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    
    if (_pageIsAnimating && currentPage <= 0 && _currentChapter <= 0) {
        [E_HUDView showMsg:@"已经是第一章了" inView:nil];
        _pageIsAnimating = YES;
        return reader;
    }
    //双页翻动模式，，将背景页保存到第二次触发该方法时调用，
    
    _pageIsAnimating = YES;
    
    pageViewController.doubleSided = YES;
    
    _isBackView = !_isBackView;
    return [self readerControllerWithPage:currentPage - (_isBackView?1:0)];
}

#pragma mark - 向右翻页
//当用户决定翻转下一个页面时将发生此事件。当这个视图正在翻转的同时页面视图控制器想要判断 哪一个视图控制器需要显示的时候将调用第二个方法
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    pageViewController.doubleSided = YES;
    _isKuaisu = NO;
    _isTurnOver = NO;
    _isRight = YES;
    
    _isMyCurrent = NO;
    _isOnlyOne = NO;
    
    E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    NSUInteger totalPage = reader.totalPage;
    _myCurrentPage = currentPage;
    
    
    if ((unsigned long)currentPage == 1) {
        [self applicationWillResignActive:nil];
    }
    
    NSInteger totalChapter = [E_ReaderDataSource shareInstance].totalChapter - 1;
    
    if (_currentChapter != totalChapter && (unsigned long)currentPage >= 1 && !_isCache) {//还没到最后一章，最后一章不用提前下载
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self requestStoryContent:_currentChapter + 1 andIs:NO andIsCache:YES];
        });
    }
    
    if (_pageIsAnimating && currentPage <= 0 && _currentChapter >= totalPage) {
        [E_HUDView showMsg:@"没有更多内容了" inView:nil];
        return reader;
    }
    
    _pageIsAnimating = YES;
    
    _isBackView = !_isBackView;
    return [self readerControllerWithPage:currentPage + (_isBackView?1:0)];
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    _pageIsAnimating = NO;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _isKuaisu = YES;
    
    if (completed) {
        //翻页完成
        if (_isTurnOver && !_isRight) {//往左翻 且正好跨章节
            
        }else if(_isTurnOver && _isRight){//往右翻 且正好跨章节
            
        }
        
    }else{ //翻页未完成 又回来了。
        
        if (_isRight) {
            _readPage = _readPage - 1;
        } else {
            _readPage = _readPage + 1;
        }
    }
}

- (NSUInteger)lastPage{
    
    return _paginater.pageCount - 1;
}

#pragma mark - 刷新书架
- (void)refreshBookRack{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
}

#pragma mark - 上传书籍阅读进度
- (void)saveBookReadProgress:(NSString *)chapterID{

    NSDate *currentDate = [NSDate date];
    NetworkModel *readModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"bookId"] = _bookID;
    requestData[@"chapterId"] = chapterID;
    requestData[@"operateDur"] = [NSString stringWithFormat:@"%lld",[self getDateTimeTOMilliSeconds:currentDate]];
    
    
    [readModel registerAccountAndCall:215 andRequestData:requestData];
}


#pragma mark - 下放书籍阅读进度
- (void)requsetReadProgress{

    NSDictionary *dict = [E_CommonManager Manager_getChapterBefore:_bookID];
    NSInteger index = [dict[@"chapterIndex"] integerValue];
    
    NSString *chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[index];

    NetworkModel *readProgreeModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"bookId"] = _bookID;

    requestData[@"chapterId"] = chapterId;
    requestData[@"type"] = @"1";
    
    [readProgreeModel registerAccountAndCall:216 andRequestData:requestData];
}

#pragma mark - 下放书籍阅读进度弹框取消和确认按钮
- (void)progressViewTwoBtnClick:(UIButton *)button{

    
    [_progressView removeFromSuperview];

    if (button.tag == 11) {//确定
        
        if (self.dataArray.count > 20) {//有缓存
            
            _IsCloud = YES;
            
            [SVProgressHUD showWithStatus:@"正在加载中"];
            NSString *chapID = _progressDict[@"chapterId"];
            
            
            NSString *chapterID = nil;
            for (int i = 0; i < [E_ReaderDataSource shareInstance].chapterIdListArray.count; i ++) {
                chapterID = [E_ReaderDataSource shareInstance].chapterIdListArray[i];
                if ([chapterID isEqualToString:chapID]) {
                    _currentChapter = i;
                    break;
                }
            }

            [self requestchapterID:chapterID andIs:YES andIsCache:NO];
            
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            BookInforModel *bookRack = [dataManager getBookWithBookId:_bookID];
            bookRack.isRedSyn = @(1);
            [WHC_ModelSqlite update:bookRack where:[NSString stringWithFormat:@"bookid = %@",bookRack.bookid]];
            
        } else {//没有缓存
            
            _IsProgress = YES;
            [self requestStoryMuenCall110];
        }
    }
}

-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}





@end
