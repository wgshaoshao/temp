//
//  BookRackHomeController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookRackHomeController.h"
#import "SearchView.h"
#import "SearchMainController.h"
#import "HotStrawView.h"
#import "EmptyRackView.h"
#import "BookDetailController.h"
#import "BookRackViewCell.h"
#import "FreeH5Controller.h"
#import "HMPopMenu.h"
#import "PopMenuView.h"
#import "BookManageController.h"
#import "Help.h"
#import "E_ScrollViewController.h"
#import "BottomView.h"
#import "RackAddView.h"
#import "H5ViewController.h"
#import "CommentPopView.h"
#import "IdeaFeedBackController.h"
#import "RedPacketController.h"
#import "AFNetworking.h"
#import "Function.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PopBottomView.h"
#import "SignInH5Controller.h"
#import "LoginView.h"
#import "LoginAndRegistController.h"

@protocol JSObjcDelegate <JSExport>

- (void)bookStoreClick:(NSString *)srcid;

@end

@interface BookRackHomeController ()<SearchViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HotStrawViewDelegate,EmptyRackViewDelegate,PopMenuViewDelegate,HMPopMenuDelegate,BottomViewDelegate,RackAddViewDelegate,CommentPopViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,JSObjcDelegate,PopBottomViewDelegate,UIAlertViewDelegate,LoginViewDelegate>

@property(nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HotStrawView *hotStrawView;
@property (nonatomic, strong) EmptyRackView *emptyRackView;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) NSArray *bookRackArray;
@property (nonatomic, strong) NSMutableArray *addBookRackArray;
@property (nonatomic, strong) HMPopMenu *popMenu;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) NetworkModel *updateModel;
@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *returnList;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger indexInt;
@property (nonatomic, strong) BottomView *bottomView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

@property (nonatomic, assign) BOOL rackDelete;//YES:选中按钮  NO:未选中按钮
@property (nonatomic, assign) BOOL rackShow;//YES:显示删除按钮  NO:不显示删除按钮
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, assign) BOOL isUpdateChapter;
@property (nonatomic, strong) NSDictionary *responsDict;
@property (nonatomic, assign) BOOL hasCoreData;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, strong) RackAddView *rackAddView;
@property (nonatomic, assign) BOOL isSecond;
@property (nonatomic, strong) NSMutableDictionary *deleteDict;
@property (nonatomic, strong) CommentPopView *commentPopView;
@property (nonatomic, strong) JSContext *jsContent;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) PopBottomView *popBView;
@property (nonatomic, strong) NSString *popBViewUrl;
@property (nonatomic, strong) NSString *popBViewStrId;
@property (nonatomic, strong) NSString *popBViewStrTitle;
@property (nonatomic, strong) LoginView *loginView;

@end

@implementation BookRackHomeController


- (BottomView *)bottomView{

    if (_bottomView == nil) {
   
        _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 54, ScreenWidth, 54)];
        _bottomView.delegate = self;
        [_bottomView creatView];
    }
    return _bottomView;
}


- (NSMutableArray *)deleteArray{

    if (_deleteArray == nil) {
        _deleteArray = [[NSMutableArray alloc] init];
    }
    return _deleteArray;
}

- (EmptyRackView *)emptyRackView{

    if (_emptyRackView == nil) {
        _emptyRackView = [[EmptyRackView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 44)];
        _emptyRackView.delegate = self;
        _emptyRackView.titleLabel.text = @"书城空荡荡的，快去书城挑本书看吧";
    }
    return _emptyRackView;
}

- (HotStrawView *)hotStrawView{

    if (_hotStrawView == nil) {
        _hotStrawView = [[HotStrawView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _hotStrawView.delegate = self;
    }
    return _hotStrawView;
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    //点击loading页面
    [self requestIsLoadingJump];
    
    _isUpdateChapter = NO;
    
    //查询书架是否有数据
    [self setupBookRack];
    [self requestUpdateChapter114];
    [self createNavigationBarView];
    //是否弹框
    [self requestIsMore];
    
    if (!_listArray.count) {
        [self requestSearchHotWord119];
    }
    
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)requestIsMore{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    BOOL isMoreYES = [[userDefaults objectForKey:@"isMoreYES"] boolValue];
    
    NSInteger isMore = [[userDefaults objectForKey:@"isMore"] integerValue];
    if (IsLogin && isMoreYES) {//弹框
        
        [userDefaults setObject:@(NO) forKey:@"isMoreYES"];
        
        NSString *message = @"";
        if (isMore == 1) {
            message = @"您在其他设备上最近阅读的20本图书已同步到你的书架，可直接在书架上查看，如需查看全部阅读记录可点击云书架查看";
        } else {
            message = @"您在其他设备上最近阅读的图书已同步到你的书架，可直接在书架上查看";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)requestIsLoadingJump{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isloadingJump =[[userDefaults objectForKey:@"isloadingJump"] boolValue];
    
    if (isloadingJump) {//从loading页面点击跳转过来
        
        NSInteger type = [[userDefaults objectForKey:@"type"] integerValue];
        //根据type跳转
        if (type == 1) {//书籍详情
            NSString *bookID = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"LoadingPage";
            bookDetailVC.bookID = bookID;
            [self.navigationController pushViewController:bookDetailVC animated:NO];
        } else if (type == 2) {//精选专题
            
            
        } else if (type == 3) {//活动中心
            
            NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
            NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
            H5ViewController *activityH5VC = [[H5ViewController alloc] init];
            activityH5VC.urlStr = url;
            activityH5VC.titleName = title;
            [self.navigationController pushViewController:activityH5VC animated:NO];
        } else if (type == 6) {//签到/抽奖
            NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
            
            if ([title rangeOfString:@"签到"].location != NSNotFound) {
                
                SignInH5Controller *signH5VC = [[SignInH5Controller alloc] init];
                [self.navigationController pushViewController:signH5VC animated:YES];
                
            } else {
                
                NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
                RedPacketController *redPackerVC = [[RedPacketController alloc] init];
                redPackerVC.urlStr = url;
                [self.navigationController pushViewController:redPackerVC animated:YES];
            }
        }
        
        [userDefaults setObject:@(NO) forKey:@"isloadingJump"];
    } else {
        
        NSInteger commentCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"commentCount"] integerValue];
        if (commentCount == 3) {

            //投诉开关
            [self requestComplaint210];
        }
        [self updateVersion];
    }
}

//投诉开关
- (void)requestComplaint210{

    NetworkModel *complaintModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"vtv"] = @"8";
    [complaintModel registerAccountAndCall:210 andRequestData:requestData];
}

//检查更新版本
- (void)updateVersion{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSInteger mustUpdate = [[userDefaults objectForKey:@"mustUpdate"] integerValue];
    NSString *rversion = [userDefaults objectForKey:@"rversion"];
    NSString *introduction = [userDefaults objectForKey:@"introduction"];
    NSString *myReversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (mustUpdate == 0) {//每次弹框提醒
        
        BOOL aginGotoApp =[[userDefaults objectForKey:@"aginGotoApp"] boolValue];
        if (aginGotoApp) {
            
            [userDefaults setObject:@(NO) forKey:@"aginGotoApp"];
            
            if ([rversion compare:myReversion] == 1) {//有更新
                
                [userDefaults setObject:@(NO) forKey:@"updateVersion"];
                UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"版本升级" message:introduction delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alvertView.delegate = self;
                [alvertView show];
            }
        }
        
    } else if (mustUpdate == 1) {//每天弹框提醒
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
     
        NSString *dateStr = [userDefaults objectForKey:@"dateString"];
        
        if (![dateString isEqualToString:dateStr]) {
            if ([rversion compare:myReversion] == 1) {//有更新
                
                [userDefaults setObject:@(NO) forKey:@"updateVersion"];
                UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"升级版本" message:introduction delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alvertView.delegate = self;
                [alvertView show];
            }
        }

    } else if (mustUpdate == 3) {//强制升级
        if ([rversion compare:myReversion] == 1) {//有更新
            
            [userDefaults setObject:@(YES) forKey:@"updateVersion"];
            UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"版本强制升级" message:introduction delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            alvertView.delegate = self;
            [alvertView show];
        } else {
            [userDefaults setObject:@(NO) forKey:@"updateVersion"];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (_popMenu != nil) {
        [_popMenu dismiss];
    }
    
    _rackDelete = NO;
    _rackShow = NO;
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    self.deleteArray = nil;
    [_searchView removeFromSuperview];
    
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isLoginSuccess = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"] boolValue];
    BOOL isFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"] boolValue];
    
    if (!isFirst) {//第一次
        if (!isLoginSuccess) {//未登录
            
            [self requestComplaint210];

        }
    }
    
   NSArray *bookArray = [WHC_ModelSqlite query:[BookInforModel class]];
    for (BookInforModel*book in bookArray) {
        LRLog(@"bookname -----%@",book.bookName);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSearchHotWord119) name:@"requestSearchHotWord119" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVersion) name:@"updateVersion" object:nil];

//    _rackDelete = NO;
    _rackShow = NO;
    
    _indexInt = 0;
    
    _deleteDict = [[NSMutableDictionary alloc] init];
    
    _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerActionBookRack) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    self.view.backgroundColor = WhiteColor;
   
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self ;
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    _collectionView.backgroundColor = BackViewColor;
  
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellEmpty"];
    [_collectionView registerClass:[BookRackViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    
    //添加长按手势
    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    _longPressGR.minimumPressDuration = 1.0;
    [_collectionView addGestureRecognizer:_longPressGR];
}



#pragma mark - 长按手势事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        _rackDelete = NO;
        CGPoint point = [gesture locationInView:_collectionView];
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
        
        if (_rackShow) {
            
        } else {
            _rackShow = YES;
        }
        
        self.deleteArray = nil;
        
        for (int i = 0; i < self.bookRackArray.count; i++) {//循环把所有没有添加到deleteArray的cell加进去
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:i inSection:1];
            
            BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:newIndexPath];
           
            if (newIndexPath.row == indexPath.row) {
 
                [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateSelected];
                cell.deleteBtn.selected = YES;
                [self.deleteArray addObject:@(indexPath.row)];
                [_deleteDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            } else {
                
                [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
                cell.deleteBtn.selected = NO;
                cell.deleteBtn.hidden = NO;
                [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
//        LRLog(@"~~~~%@",_deleteDict);
        NSString *deleteStr = [NSString stringWithFormat:@"删除（%lu）",(unsigned long)self.deleteArray.count];
        
        [self.bottomView.deleteBtn setTitle:deleteStr forState:UIControlStateNormal];
        
        //刷新书架上的书
        NSIndexSet *bookRack = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:bookRack];
//        NSIndexPath *addIndex = [NSIndexPath indexPathForRow:(self.addBookRackArray.count - 1) inSection:1];
//        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:addIndex, nil]];
    
    }
}


#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    self.navigationController.navigationBar.hidden = NO;
    
    _searchView = [self.navigationController.navigationBar viewWithTag:10];
    if (_searchView != nil) {
        return;
    }
    
    _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchView.tag = 10;
    _searchView.delegate = self;
    _searchView.placeolderStr = @"女总裁";
    _searchView.YesOrNo = YES;

    [_searchView creatSearchView:YES];
    [_searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_searchView];
}

#pragma mark - 检查章节更新信息
- (void)requestUpdateChapter114{
    
    NSString *idStrsSecond = nil;
    
    if (self.bookRackArray.count) {
        //存放的是booKRack类型
        
        for (int i = 0; i < self.bookRackArray.count; i ++) {
 
            BookInforModel *bookRack = self.bookRackArray[i];
            if (idStrsSecond) {
                if (bookRack.bookid && bookRack.updateChapter) {
                    idStrsSecond = [NSString stringWithFormat:@"%@,%@:%@",idStrsSecond,bookRack.bookid,bookRack.updateChapter];
                }
            } else {
                if (bookRack.bookid && bookRack.updateChapter) {
                    idStrsSecond = [NSString stringWithFormat:@"%@:%@",bookRack.bookid,bookRack.updateChapter];
                }
            }
        }
    }

    self.updateModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"9";
    if (idStrsSecond.length) {
        requestData[@"idStrs"] = idStrsSecond;
    } else {
        requestData[@"idStrs"] = @"";
    }
    [self.netWorkModel registerAccountAndCall:114 andRequestData:requestData];
}

#pragma mark - 热荐
- (void)requestSearchHotWord119{

    self.netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"vtv"] = @"8";
    
    [self.netWorkModel registerAccountAndCall:119 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.call == 119) {
        
        LRLog(@"%ld___%@",(long)message.resultCode,message.responseData);
        if (message.resultCode == 0) {//resultCode==0 成功
           
            if ([message.responseData isKindOfClass:[NSString class]]) {
                if (![message.responseData isEqualToString:@""]) {
                    _listArray = message.responseData[@"list"];
        
                    [self popBottomView];
                    
                    [self timerActionBookRack];
                }
            } else if ([message.responseData isKindOfClass:[NSDictionary class]]) {
                _listArray = message.responseData[@"list"];
      
                [self popBottomView];
                [self timerActionBookRack];
            }
        } else {//请求失败,再次请求119接口

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self requestSearchHotWord119];
            });
        }
    } else if (message.call == 210) {
        
     
        NSInteger commentCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"commentCount"] integerValue];
        
        if (message.resultCode == 0) {
            
            
            
            NSInteger isShowLogin = [message.responseData[@"isShowLogin"] integerValue];
            
            
            BOOL isLoginSuccess = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"] boolValue];
            BOOL isFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"] boolValue];
            
            if (isShowLogin == 1) {
                
                if (!isFirst) {//第一次
                    if (!isLoginSuccess) {//未登录
                        
                        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        _loginView.delegate = self;
                        [_loginView creatView];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isFirst"];
                    }
                }
                
            }
            NSInteger commentCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"commentCount"] integerValue];
            if (commentCount == 3) {
                NSInteger isAlertComment = [message.responseData[@"isAlertComment"] integerValue];
                if (isAlertComment == 1) {//是否弹出去好评的窗口 1：打开 2：关闭
                    [MobClick event:@"PopAssessView"];
                    _commentPopView = [[CommentPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    _commentPopView.delegate = self;
                    [_commentPopView creatView];
                    
                }
                commentCount = commentCount + 1;
                [[NSUserDefaults standardUserDefaults] setObject:@(commentCount) forKey:@"commentCount"];
                
                
            }
            
            
        } else {
            
            commentCount = commentCount - 1;
            [[NSUserDefaults standardUserDefaults] setObject:@(commentCount) forKey:@"commentCount"];
        }
        
    } else if (message.call == 114) {
        if (message.resultCode == 0) {
            NSArray *array = message.responseData[@"returnList"];
      
            NSMutableArray *iArray = [[NSMutableArray alloc] init];
            
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            JYS_SqlManager *bookModel = [JYS_SqlManager shareManager];
            
            for (NSInteger i = 0; i < array.count; i ++) {
                NSDictionary *dict = array[i];
                NSString *newChapter = [NSString stringWithFormat:@"%@",dict[@"newChapter"]];
                
                BookInforModel *book = [dataManager getBookWithBookId:dict[@"bookId"]];
                NSInteger marketStatus = [dict[@"marketStatus"] integerValue];
                if (![book.marketStatus isEqualToNumber:@(marketStatus)]) {
                    [bookModel updateBookIsFree:dict];
                }
                
                if ([newChapter isEqualToString:@"0"]) {//图书有更新
             
                    [iArray addObject:@(i)];
                }
            }
            if (iArray.count) {
                _returnList = message.responseData[@"returnList"];
                //刷新书架上的书
                NSIndexSet *bookRack = [NSIndexSet indexSetWithIndex:1];
                [self.collectionView reloadSections:bookRack];
            
            }
        }
    } else if (message.call == 110) {
    
        [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
        
        if (message.resultCode == 0) {//请求成功
            BookInforModel *bookRack = self.bookRackArray[_index];
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            if (_isUpdateChapter) {
                
                NSArray *array = message.responseData[@"chapterIdList"];
                
                BookInforModel *bookRackNew = [dataManager getBookWithBookId:bookRack.bookid];
                bookRackNew.updateChapter = [NSString stringWithFormat:@"%@",array[array.count - 1]];
                bookRackNew.bookid = bookRack.bookid;
                [WHC_ModelSqlite update:bookRackNew where:[NSString stringWithFormat:@"bookid = %@",bookRack.bookid]];
                
                NSIndexSet *bookRack = [NSIndexSet indexSetWithIndex:1];
                [self.collectionView reloadSections:bookRack];
                //无更新进入阅读器
                if (_hasCoreData) {//有缓存
                    [self gotoScrollViewCoreData];
                } else {//没有缓存
                    [self gotoScrollViewNoCoreData];
                }
                
                
            } else {
                
                if (_isLast) {
                    [self gotoLastScrollView:message.responseData];
                } else {
                    _responsDict = message.responseData;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_index inSection:1];
                    BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (cell.isShowUpdate) {
                        //更新章节
                        [self requestUpdateChapter];
                    } else {
                        //无更新进入阅读器
                        [self gotoScrollViewNoCoreData];
                    }
                }
            }
            
        } else {//请求失败
            [SVProgressHUD showErrorWithStatus:@"网络出现错误，请检查您的网络"];
        }
    }
}

//
- (void)gotoLastScrollView:(NSDictionary *)dict{
    
    BookInforModel *bookRack = self.bookRackArray[_index];
 
    NSMutableArray *chapterIdList = dict[@"chapterIdList"];
    NSMutableArray *chapterNameList = dict[@"chapterNameList"];
  
    
    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = dict[@"bookId"];
    readVC.allChapterOne = chapterIdList[chapterIdList.count - 1];
    readVC.bookName = bookRack.bookName;
    readVC.allChapterIndex =(chapterIdList.count - 1);
    readVC.bookIcon = bookRack.coverurl;
    readVC.author = bookRack.author;
    readVC.introude = bookRack.introuce;
    readVC.totalChapter =chapterIdList.count;
    readVC.totalTitlArray = chapterNameList;
    readVC.chapterIdListArray = chapterIdList;
    readVC.lastChapterCount = chapterIdList.count;
    readVC.NoUpdateChapter = YES;
    readVC.lastChapterID = chapterIdList[chapterIdList.count - 1];
    [self presentViewController:readVC animated:YES completion:nil];

}

#pragma mark - 无更新章节，直接进入阅读器
- (void)gotoScrollViewNoCoreData{
    
    BookInforModel *bookRack = self.bookRackArray[_index];
    NSMutableArray *array = _responsDict[@"chapterIdList"];

    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = bookRack.bookid;
    readVC.chapterID = bookRack.chapterId.length?bookRack.chapterId:array[0];
    readVC.bookName = bookRack.bookName;
    readVC.bookIcon = bookRack.coverurl;
    readVC.author = bookRack.author;
    readVC.introude = bookRack.introuce;
    readVC.totalChapter = array.count;
    readVC.totalTitlArray = _responsDict[@"chapterNameList"];
    readVC.chapterIdListArray = array;
    readVC.NoUpdateChapter = YES;
    readVC.NewUpdate = _isUpdateChapter;
    _isUpdateChapter = NO;
    [self presentViewController:readVC animated:YES completion:nil];
    
}

#pragma mark - 检测到有更新章节，先进行更新
- (void)requestUpdateChapter{
    _isUpdateChapter = YES;
 
    BookInforModel *bookRack = self.bookRackArray[_index];
    
    [[AppDelegate sharedApplicationDelegate].window showLoadingView];
    
    self.networkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"2";
    requestData[@"chapterStatus"] = @"9999";
    requestData[@"chapterId"] = bookRack.updateChapter;
    requestData[@"defbook"] = @"1";
    requestData[@"bookId"] = bookRack.bookid;
    requestData[@"chapterEndId"] = @"";
    requestData[@"marketId"] = @"";
    requestData[@"payWay"] = @"2";
    requestData[@"needBlockList"] = @"";
    [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
}

#pragma mark - 更新热荐
- (void)timerActionBookRack{
    
    if (_listArray.count) {
  
        _indexInt ++;
        if (_indexInt == _listArray.count) {
            _indexInt = 0;
        }
        NSArray *array = [self subArrayWithIndex:_indexInt array:_listArray length:1];
        NSDictionary *dict = array[0];
        NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
        NSString *noticeType = [NSString stringWithFormat:@"%@",dict[@"noticeType"]];
        
        if ([type isEqualToString:@"1"] || ([type isEqualToString:@"2"] && [noticeType isEqualToString:@"1"])) {
            self.hotStrawView.titleLabel.text = dict[@"noticeInfo"];
            self.hotStrawView.listDict = dict;
        }
    }
}

#pragma mark - 全选按钮点击事件
- (void)bottomViewAllSelectBtnClick{
    
    self.deleteArray = nil;
    _rackDelete = YES;
    for (int i = 0; i < self.bookRackArray.count; i++) {//循环把所有没有添加到deleteArray的cell加进去
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];

  
        [self.deleteArray addObject:@(indexPath.row)];
        [_deleteDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [_deleteDict setObject:@"cancel" forKey:[NSString stringWithFormat:@"%ld",(unsigned long)self.bookRackArray.count]];
    NSString *deleteStr = [NSString stringWithFormat:@"删除（%lu）",(unsigned long)self.bookRackArray.count];
    
    [self.bottomView.deleteBtn setTitle:deleteStr forState:UIControlStateNormal];
    
    //刷新书架上的书
    NSIndexSet *index = [NSIndexSet indexSetWithIndex:1];
    [self.collectionView reloadSections:index];
}

#pragma mark - 取消按钮点击事件
- (void)bottomViewCancelBtnClick{
    _rackDelete = NO;
    _rackShow = NO;
    
    for (int i = 0; i < self.bookRackArray.count; i++) {//循环把所有cell从selectBookArray删掉
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
        BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        if (cell.deleteBtn.selected == YES) {//没选中点击过后为选中状态
            cell.deleteBtn.selected = NO;
            
            [self.deleteArray removeObject:@(indexPath.row)];
        }
        [cell.deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_deleteDict setObject:@"cancel" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [_deleteDict setObject:@"cancel" forKey:[NSString stringWithFormat:@"%ld",(unsigned long)self.bookRackArray.count]];

    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    
    NSIndexPath *addIndex = [NSIndexPath indexPathForRow:(self.addBookRackArray.count - 1) inSection:1];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:addIndex, nil]];
    
}

#pragma mark - 删除所选书籍弹框
- (void)bottomViewDeletebtnClick{
 
    UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"删除" message:@"确定删除选中的书籍" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alvertView.delegate = self;
    [alvertView show];
}

#pragma mark - 删除所选书籍和去升级弹框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView.title isEqualToString:@"版本强制升级"]) {
        
        [self gotoAppStore];
        
    } else if ([alertView.title isEqualToString:@"版本升级"]) {
        
        
        if (buttonIndex == 1) {
            [self gotoAppStore];
        }
    
    } else if ([alertView.title isEqualToString:@"升级版本"]){
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"dateString"];
        
        if (buttonIndex == 1) {
            [self gotoAppStore];
        }
    } else {
    
        if (buttonIndex == 1) {
            for (int i=0; i<=self.bookRackArray.count; i++) {
                [_deleteDict setObject:@"cancel" forKey:[NSString stringWithFormat:@"%d",i]];
            }
            if (self.deleteArray.count) {
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:_bookRackArray];
                
                NSMutableArray *selectArray = [NSMutableArray arrayWithArray:self.deleteArray];
                
                if (self.deleteArray.count) {
                    
                    for (int i = 0; i < self.deleteArray.count; i ++) {
                        
                        NSInteger deleteIndex = [self.deleteArray[i] integerValue];
                        BookInforModel *bookRack = _bookRackArray[deleteIndex];
                        
                        if (bookRack != nil) {
                            
                            [dataManager removeBookRackWithBook:bookRack.bookid];
                        }
                        
                        [array removeObject:bookRack];
                        [selectArray removeObject:@(deleteIndex)];
                    }
                    
                    _bookRackArray = array;
                    _deleteArray = selectArray;
                    
                    _rackShow = NO;
                    for (int i = 0; i < self.bookRackArray.count; i++) {//循环把所有cell从selectBookArray删掉
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
                        BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                        if (cell.deleteBtn.selected == YES) {//没选中点击过后为选中状态
                            cell.deleteBtn.selected = NO;
                            
                            [self.deleteArray removeObject:@(indexPath.row)];
                        }
                        [cell.deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    }
                    
                    [self.bottomView removeFromSuperview];
                    self.bottomView = nil;
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObjectsFromArray:self.bookRackArray];
                    [array insertObject:@"add" atIndex:self.bookRackArray.count];
                    self.addBookRackArray = array;
                    //刷新书架上的书
                    NSIndexSet *index = [NSIndexSet indexSetWithIndex:1];
                    [self.collectionView reloadSections:index];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"请选择书籍"];
            }
        }
    }
}



#pragma mark - 跳转搜索页面
- (void)searchViewBtnClick{
    
    [self bottomViewCancelBtnClick];

    SearchMainController *searchMainVC = [[SearchMainController alloc] init];
    searchMainVC.source = @"BookRack";
    [searchMainVC.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:searchMainVC animated:YES];
}



#pragma mark - 更多按钮的点击
- (void)searchViewMoreBtnClick{
    
    [self bottomViewCancelBtnClick];


    self.deleteArray = nil;
    
    if (_searchView.YesOrNo) {
        [_searchView.moreBtn setImage:[UIImage imageNamed:@"lodin_icon_cancel_-normal"] forState:UIControlStateNormal];
        
        PopMenuView *popMenuView = [[PopMenuView alloc] initWithFrame:CGRectMake(0, 0, 135, 182.5)];
        popMenuView.backgroundColor = WhiteColor;
        
        popMenuView.delegate = self;
        
        _popMenu = [[HMPopMenu alloc] initWithContentView:popMenuView];
        _popMenu.delegate = self;
        [_popMenu showInRect:CGRectMake(0, 0, 135, 182.5)];
        [self.view addSubview:_popMenu];
        
        self.searchView.YesOrNo = NO;
        
    } else {
        
        [_searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
        
        [_popMenu removeFromSuperview];
        _searchView.YesOrNo = YES;
    }
    
    
}

#pragma mark -  HMPopMenu移除事件
- (void)popMenuDidDismissed:(HMPopMenu *)popMenu{

    [self.searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
    [self.collectionView reloadData];
    _searchView.YesOrNo = YES;
}

#pragma mark - wifi传书、书籍管理、按书名排序、按时间排序
- (void)popMenuViewBtnClick:(UIButton *)button{
    
    [MobClick event:@"TopManuel"];
    if (button.tag == 1) {//切换夜间
        
        [self setupchangeNightOrDay];
        
    } else if (button.tag == 2) {//书籍管理
        
        [self setupSkipBookManage];
        
    } else if (button.tag == 3) {//按书名排序
        
        [self setupSortBookName];
        
    } else if (button.tag == 4) {//按时间排序
        
        [self setupSortReadTime];
    }
}

#pragma mark - 切换夜间
- (void)setupchangeNightOrDay{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([AppDelegate sharedApplicationDelegate].nightView.alpha > NightAlpha - 0.1) {
        [AppDelegate sharedApplicationDelegate].nightView.alpha = 0.0;
    } else {
        [AppDelegate sharedApplicationDelegate].nightView.alpha = NightAlpha;
    }
    [userDefaults setObject:@([AppDelegate sharedApplicationDelegate].nightView.alpha) forKey:@"NightAlpha"];
    
    [_searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
    
    [_popMenu removeFromSuperview];
    _searchView.YesOrNo = YES;
}

#pragma mark - 跳转到书籍管理
- (void)setupSkipBookManage{

    BookManageController *bookManageVC = [[BookManageController alloc] init];
    bookManageVC.bookManageArray = self.bookRackArray;
    [self.navigationController pushViewController:bookManageVC animated:YES];
}

#pragma mark - 按书名排序
- (void)setupSortBookName{
    
    self.addBookRackArray = nil;
    self.bookRackArray = [self.bookRackArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {
        return [((BookInforModel*)obj1).bookName compare:((BookInforModel *)obj2).bookName options:NSNumericSearch];
    }];
    if (self.bookRackArray.count) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:self.bookRackArray];
        [array insertObject:@"add" atIndex:self.bookRackArray.count];
        self.addBookRackArray = array;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"bookName" forKey:@"NSNumericSearch"];
        //刷新书架上的书
        NSIndexSet *index = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:index];
        
        [_searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
        
        [_popMenu removeFromSuperview];
        _searchView.YesOrNo = YES;
    }
}

#pragma mark - 按阅读时间来排序
- (void)setupSortReadTime{

    self.addBookRackArray = nil;
    self.bookRackArray = [self.bookRackArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {
        return [((BookInforModel *)obj1).time compare:((BookInforModel *)obj2).time options:NSNumericSearch];
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:self.bookRackArray];
    [array insertObject:@"add" atIndex:self.bookRackArray.count];
    self.addBookRackArray = array;
    
    //刷新书架上的书
    NSIndexSet *index = [NSIndexSet indexSetWithIndex:1];
    [self.collectionView reloadSections:index];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"dateTime" forKey:@"NSNumericSearch"];
    
    
    [_searchView.moreBtn setImage:[UIImage imageNamed:@"common_nav_common–icon_menu_n"] forState:UIControlStateNormal];
    
    [_popMenu removeFromSuperview];
    _searchView.YesOrNo = YES;
}

#pragma mark - 查询书架是否有数据
- (void)setupBookRack{
    
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];    
        //存放的是booKRack类型
//        self.addBookRackArray = nil;
        self.bookRackArray = [dataManager getBookRackBooks];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *numericSearch = [userDefaults objectForKey:@"NSNumericSearch"];
        
        
        self.bookRackArray = [self.bookRackArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {//按时间排序
            if ([numericSearch isEqualToString:@"bookName"]) {
                return [((BookInforModel *)obj1).bookName compare:((BookInforModel *)obj2).bookName options:NSNumericSearch];
            } else {
                return [((BookInforModel *)obj1).time compare:((BookInforModel *)obj2).time options:NSNumericSearch];
            }
            
        }];

    
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:self.bookRackArray];
        [array insertObject:@"add" atIndex:self.bookRackArray.count];
        self.addBookRackArray = array;


        BOOL refreshBookRack =[[userDefaults objectForKey:@"refreshBookRack"] boolValue];
        if (refreshBookRack) {
            
            _returnList = nil;
            NSIndexSet *bookRack = [NSIndexSet indexSetWithIndex:1];
            [self.collectionView reloadSections:bookRack];
            
            [userDefaults setObject:@(NO) forKey:@"refreshBookRack"];
        }

}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else {
        if (self.addBookRackArray.count) {//书架有书
            return self.addBookRackArray.count;
        } else {
            
            return 1;
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        
    return 2;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
       
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = WhiteColor;
        [cell.contentView addSubview:self.hotStrawView];

        return cell;
        
    } else {
        
        if (self.addBookRackArray.count) {//书架有书
         
            BookRackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
            cell.isShow = _rackShow;
           
            if (_returnList.count == self.bookRackArray.count) {
                
                cell.updateArray = _returnList;
            } else {
                cell.updateArray = nil;
            }
           
            cell.updateOneChapter = _isUpdateChapter;
            
            cell.index = indexPath.row;
            cell.arrayCount = self.addBookRackArray.count;
            cell.model = self.addBookRackArray[indexPath.row];
            
            
    
            if ([[_deleteDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"YES"]) {
                [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateSelected];
              
                cell.deleteBtn.selected = YES;
            }else if ([[_deleteDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"NO"]){
                [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
                cell.deleteBtn.selected = NO;
        
            }else if ([[_deleteDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"cancel"]){
                [cell.deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [cell.deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                cell.deleteBtn.selected = NO;
             
            }
            
            return cell;
            
        } else {
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellEmpty" forIndexPath:indexPath];
            
            [cell.contentView addSubview:self.emptyRackView];
            return cell;
        }
    }

    return nil;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(ScreenWidth, 44);
    } else {
        if (self.addBookRackArray.count) {
            
            if (IPAD) {
                return CGSizeMake(CollectionCellWIPad* KKuaikan, CollectionCellH * KKuaikan);
            } else {
                return CGSizeMake(CollectionCellW * KKuaikan, CollectionCellH * KKuaikan);
            }
        } else {
            
            return CGSizeMake(ScreenWidth, ScreenHeight);
        }
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 1) {
        
        if (self.addBookRackArray.count) {
            
            return UIEdgeInsetsMake(25 * KKuaikan, 15 * KKuaikan, 0, 15 * KKuaikan);
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - 点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
     
        if (self.addBookRackArray.count) {

            if (_rackShow) {//删除状态
                
                if ((indexPath.row + 1) == self.addBookRackArray.count) {//点击加号
                   
                } else {
                    BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                    if (cell.deleteBtn.selected) {
                        cell.deleteBtn.selected = NO;
                        [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
                        [self.deleteArray removeObject:@(indexPath.row)];
                         [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
                        
                    } else {
                        cell.deleteBtn.selected = YES;
                        [cell.deleteBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateSelected];
                        [self.deleteArray addObject:@(indexPath.row)];
                         [_deleteDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
                        
                    }

                    NSString *deleteStr = [NSString stringWithFormat:@"删除（%lu）",(unsigned long)self.deleteArray.count];
                    
                    [self.bottomView.deleteBtn setTitle:deleteStr forState:UIControlStateNormal];
                   
                }
                
            } else {
                
                if ((indexPath.row + 1) == self.addBookRackArray.count) {//点击加号
                    if (!_isSecond) {
                        [self showAddView];
                    }
                    
                } else {
                    _index = indexPath.row;
                    
                    BookInforModel *bookRack = self.addBookRackArray[indexPath.row];

          
                    if (bookRack.isUpate.integerValue == 1) {
                        [[AppDelegate sharedApplicationDelegate].window showLoadingView];
                        _hasCoreData = NO;
                        _isLast = YES;
                        
                        self.networkModel = [[NetworkModel alloc]initWithResponder:self];
                        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
                        requestData[@"v"] = @"2";
                        requestData[@"chapterStatus"] = @"20";
                        requestData[@"defbook"] = @"1";
                        requestData[@"bookId"] = bookRack.bookid;
                        requestData[@"chapterEndId"] = @"";
                        requestData[@"payWay"] = @"2";
                        
                        [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
                    } else {
                        
                        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                        NSArray *chapterType = [dataManager getAllCatelogFromBook:bookRack.bookid];

                        if (chapterType.count <= 20) {//没有数据缓存过本地数据库
                            [[AppDelegate sharedApplicationDelegate].window showLoadingView];
                            _hasCoreData = NO;
                            
                            self.networkModel = [[NetworkModel alloc]initWithResponder:self];
                            NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
                            requestData[@"v"] = @"2";
                            requestData[@"chapterStatus"] = @"20";
                            requestData[@"defbook"] = @"1";
                            requestData[@"bookId"] = bookRack.bookid;
                            requestData[@"chapterEndId"] = @"";
                            requestData[@"payWay"] = @"2";
                            
                            [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
                        } else {
                            
                            _hasCoreData = YES;
                            
                            BookRackViewCell *cell = (BookRackViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                            if (cell.isShowUpdate) {
                                //更新章节
                                [self requestUpdateChapter];
                            } else {
                                //没有更新章节进入阅读器（有缓存）
                                [self gotoScrollViewCoreData];
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - 点击加号
- (void)showAddView{
    
    _isSecond = YES;

    _rackAddView = [[RackAddView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    _rackAddView.delegate = self;
    [_rackAddView creatView];
    
    [_rackAddView showRackAddView];
   
}

#pragma mark - 今日免费、逛书城
- (void)rackAddViewBtnClick:(UIButton *)button{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isSecond = NO;
    });
    
    if (button.tag == 10) {//取消
        
        [_rackAddView dissRackAddView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_rackAddView removeFromSuperview];
        });
        
    } else if (button.tag == 11) {//逛书城
        [_rackAddView removeFromSuperview];
        
        [AppDelegate sharedApplicationDelegate].mainTabBarController.selectedIndex = 1;
    } else if (button.tag == 12) {//今日免费
        [_rackAddView removeFromSuperview];
        FreeH5Controller *freeH5VC = [[FreeH5Controller alloc] init];
        [self.navigationController pushViewController:freeH5VC animated:YES];
    }
}

#pragma mark - 检测到没有更新章节进入阅读器（有缓存）
- (void)gotoScrollViewCoreData{
    
    BookInforModel *bookRack = self.bookRackArray[_index];
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    //存放的是Catelog类型
    NSArray *chapterType = [dataManager getAllCatelogFromBook:bookRack.bookid];
    
    //存放的是catelogID数组
    NSMutableArray *chapterIdList = [[NSMutableArray alloc] init];
    
    //目录列表名
    NSMutableArray *chapterNameList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < chapterType.count; i ++) {
        CatelogInforModel *catelog = chapterType[i];
        
        [chapterIdList addObject:catelog.chaterId];
        if (catelog.catelogName.length) {
            [chapterNameList addObject:catelog.catelogName];
        }
    }
    
    
    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = bookRack.bookid;
    readVC.chapterID = bookRack.chapterId;
    readVC.bookName = bookRack.bookName;
    readVC.bookIcon = bookRack.coverurl;
    readVC.author = bookRack.author;
    readVC.introude = bookRack.introuce;
    readVC.totalChapter = chapterIdList.count;
    readVC.totalTitlArray = chapterNameList;
    readVC.chapterIdListArray = chapterIdList;
    readVC.NoUpdateChapter = YES;
    readVC.NewUpdate = _isUpdateChapter;
    _isUpdateChapter = NO;
    [self presentViewController:readVC animated:YES completion:nil];
}



#pragma mark - 热荐点击事件
- (void)hotStrawViewBtnClick{
    
    [self bottomViewCancelBtnClick];
    
    int type = [self.hotStrawView.listDict[@"type"] intValue];
    int noticeType = [self.hotStrawView.listDict[@"noticeType"] intValue];
    
    if (type == 1) {//跑马灯
        
        if (noticeType == 1) {//书籍详情
            
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"PaoMaDeng";
            bookDetailVC.bookID = self.hotStrawView.listDict[@"strId"];//strId(书籍id)
            [self.navigationController pushViewController:bookDetailVC animated:YES];
            
        } else if (noticeType == 2) {//专题页面
        
        } else if (noticeType == 3) {//类似于紧急通知
            
            RedPacketController *redPackerVC = [[RedPacketController alloc] init];
            redPackerVC.urlStr = self.hotStrawView.listDict[@"url"];
            redPackerVC.titleStr =self.hotStrawView.listDict[@"strTitle"];
            [self.navigationController pushViewController:redPackerVC animated:YES];
           
        } else if (noticeType == 4) {//其他
        
        } else if (noticeType == 6) {//签到/抽奖
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.hotStrawView.listDict[@"strId"] forKey:@"strId"];
            
            NSMutableDictionary *jsonDiction = [[NSMutableDictionary alloc]init];
            NSString *urlString = self.hotStrawView.listDict[@"url"];
            
            [jsonDiction setObject:[AppDelegate mypublicParam] forKey:@"pub"];
            
            [jsonDiction setObject:dict forKey:@"pri"];
            
            
            NSString *url = [NSString stringWithFormat:@"%@?json=%@",urlString,[jsonDiction jsonString]];
       
            if ([self.hotStrawView.listDict[@"strTitle"] rangeOfString:@"签到"].location != NSNotFound) {
                
                SignInH5Controller *signH5VC = [[SignInH5Controller alloc] init];
                [self.navigationController pushViewController:signH5VC animated:YES];
                
            } else {
                RedPacketController *redPackerVC = [[RedPacketController alloc] init];
                redPackerVC.urlStr = url;
                redPackerVC.titleStr =self.hotStrawView.listDict[@"strTitle"];
                [self.navigationController pushViewController:redPackerVC animated:YES];
            }
         
        } else if (noticeType == 7) {//看点抢红包
        
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.hotStrawView.listDict[@"strId"] forKey:@"strId"];
            
            NSMutableDictionary *jsonDiction = [[NSMutableDictionary alloc]init];
            NSString *urlString = self.hotStrawView.listDict[@"url"];
            
            [jsonDiction setObject:[AppDelegate mypublicParam] forKey:@"pub"];
            
            [jsonDiction setObject:dict forKey:@"pri"];
            
            NSString *url = [NSString stringWithFormat:@"%@?json=%@",urlString,[jsonDiction jsonString]];
            
            [self gotoRedPacketVC:url];
        }
        
    } else if (type == 2) {//活动
        if (noticeType == 1) {//书籍详情
            
            BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
            bookDetailVC.sourceFrom = @"跑马灯";
            bookDetailVC.bookID = self.hotStrawView.listDict[@"strId"];//strId(书籍id)
            [self.navigationController pushViewController:bookDetailVC animated:YES];
            
        } else if (noticeType == 2) {//专题页面
            
        } else if (noticeType == 3) {//类似于紧急通知
            
        } 
    }
}

#pragma mark - 底部弹框点击领取红包
- (void)popBottomViewBtnClick{
    
    [_popBView removeFromSuperview];
    
    if ([_popBViewStrTitle rangeOfString:@"签到"].location != NSNotFound) {
        
        SignInH5Controller *signH5VC = [[SignInH5Controller alloc] init];
        [self.navigationController pushViewController:signH5VC animated:YES];
        
    } else {
        [MobClick event:@"ClickBottomRedPacket"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_popBViewStrId forKey:@"strId"];
        
        NSMutableDictionary *jsonDiction = [[NSMutableDictionary alloc]init];
        NSString *urlString = _popBViewUrl;
        
        [jsonDiction setObject:[AppDelegate mypublicParam] forKey:@"pub"];
        
        [jsonDiction setObject:dict forKey:@"pri"];
        
        NSString *url = [NSString stringWithFormat:@"%@?json=%@",urlString,[jsonDiction jsonString]];
        [self gotoRedPacketVC:url];
    }
}

#pragma mark - 看点抢红包弹窗
- (void)popBottomView{
    
    
    BOOL isSwitchSiteUrl =[[[NSUserDefaults standardUserDefaults] objectForKey:@"switchSiteUrl"] boolValue];
    
    if (isSwitchSiteUrl) {//YES:从正式环境切到测试环境，第一次不调用
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"switchSiteUrl"];
    } else {
    
        for (int i = 0; i < _listArray.count; i ++) {
            NSDictionary *dict = _listArray[i];
            int type = [dict[@"type"] intValue];
            int noticeType = [dict[@"noticeType"] intValue];
            if (type == 2) {
                if (noticeType == 7) {//看点抢红包弹窗
                    
                    NSString *imageUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"redImageUrl"];
                    if (imageUrlStr.length && [imageUrlStr isEqualToString:dict[@"imageUrl"]]) {
                        
                    } else {
                        
                        [MobClick event:@"PopBottomView"];
                        
                        _popBView = [[PopBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        _popBView.delegate = self;
                        _popBView.imageStr = dict[@"imageUrl"];
                        _popBViewUrl = dict[@"url"];
                        _popBViewStrId = [NSString stringWithFormat:@"%@",dict[@"strId"]];
                        [_popBView creatView];
                        [[AppDelegate sharedApplicationDelegate].window addSubview:_popBView];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"imageUrl"] forKey:@"redImageUrl"];
                    }
                } else if (noticeType == 6) {//签到弹窗
                    NSString *imageUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"signImageUrl"];
                    if (imageUrlStr.length && [imageUrlStr isEqualToString:dict[@"imageUrl"]]) {
                        
                    } else {
                        
                        _popBView = [[PopBottomView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        _popBView.delegate = self;
                        _popBView.imageStr = dict[@"imageUrl"];
                        _popBViewStrTitle = dict[@"strTitle"];
                        _popBViewStrId = [NSString stringWithFormat:@"%@",dict[@"strId"]];
                        [_popBView creatView];
                        [[AppDelegate sharedApplicationDelegate].window addSubview:_popBView];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dict[@"imageUrl"] forKey:@"signImageUrl"];
                    }
                }
            }
        }
    }
    
}

#pragma mark - H5加载出红包界面
- (void)gotoRedPacketVC:(NSString *)url{
    
    
    [MobClick event:@"RedPacket"];
    
    _coverView = [[UIView alloc] init];
    _coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _coverView.backgroundColor = ADColorRGBA(0, 0, 0, 0.4);
    [[AppDelegate sharedApplicationDelegate].window addSubview:_coverView];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(20, (ScreenHeight - 400 * KKuaikan)/2, ScreenWidth - 40, 400 * KKuaikan);
    webView.layer.cornerRadius = 10;
    [webView.layer setMasksToBounds:YES];

    webView.scrollView.scrollEnabled = NO;
    webView.delegate = self ;
    webView.scrollView.delegate = self;
    [_coverView addSubview:webView];
    NSURL *urlUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:urlUrl];
   
    [webView loadRequest:request];

}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [SVProgressHUD showWithStatus:@"加载红包页面中..."];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    

    [SVProgressHUD showWithStatus:@"网络出现错误，加载失败"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [_coverView removeFromSuperview];
    });
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    
    [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.style.webkitUserSelect='none';"];
    
    _jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContent[@"bookSotre"] = self;

    _jsContent.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
  
    };
}

#pragma mark - 移除点出来的红包页面
- (void)bookStoreClick:(NSString *)srcid{
    
    [MobClick event:@"RedPacketClose"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestRemainSum" object:self];
    
    [_coverView removeFromSuperview];
    
}

#pragma mark - 弹出去好评，吐槽弹框
- (void)commentPopViewThreeBtnClick:(UIButton *)button{
    
    [_commentPopView removeFromSuperview];
    if (button.tag == 11) {//去好评
        
        [MobClick event:@"ClickGoodComment"];
        [self gotoAppStore];
        
    } else if (button.tag == 12) {//我要吐槽
        
        [MobClick event:@"ClickIdFeed"];
        IdeaFeedBackController *ideaFeedVC = [[IdeaFeedBackController alloc] init];
        [self.navigationController pushViewController:ideaFeedVC animated:YES];
    } else if (button.tag == 13) {//不，谢谢
   
        [MobClick event:@"ClickNoThank"];
    }
}

#pragma mark - 去书城逛逛
- (void)emptyRackViewBtnClick{
    
    [AppDelegate sharedApplicationDelegate].mainTabBarController.selectedIndex = 1;

}

#pragma mark - 去好评和升级跳转
- (void)gotoAppStore{

    NSString *iTunesString = @"https://itunes.apple.com/app/id1140794436";
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}


#pragma mark - 跳转登录
- (void)loginViewBtnClick{
    
    [_loginView removeFromSuperview];

    LoginAndRegistController *loginAndGegistVC = [[LoginAndRegistController alloc] init];
    [self.navigationController pushViewController:loginAndGegistVC animated:YES];
}


#pragma mark - 从数组循坏获取数据
- (NSMutableArray *)subArrayWithIndex:(NSInteger)index array:(NSMutableArray *)array length:(NSInteger)length{
    
    NSInteger count = array.count;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(NSInteger i = index;i<index+length;i++)
    {
        id object = [array objectAtIndex:i%count];
        [result addObject:object];
    }
    
    return result;
}

+ (NSString *)getBookID{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"bookID"];
}

- (void)dealloc{
    

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
