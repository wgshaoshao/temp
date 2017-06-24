//
//  ReadRecordController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ReadRecordController.h"
#import "ReadRecordCell.h"
#import "EmptyRackView.h"
#import "E_ScrollViewController.h"
#import "MJRefresh.h"

@interface ReadRecordController ()<UITableViewDataSource,UITableViewDelegate,EmptyRackViewDelegate> {
    
    NSInteger _currenPage;
    BOOL _isFooter;
    BOOL _isNoMoreData;
}

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *readRecordArray;
@property (nonatomic, strong) EmptyRackView *emptyRackView;
@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ReadRecordController

- (EmptyRackView *)emptyRackView{
    
    if (_emptyRackView == nil) {
        _emptyRackView = [[EmptyRackView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight -  44)];
        _emptyRackView.delegate = self;
        _emptyRackView.button.hidden = YES;
        _emptyRackView.titleLabel.text = @"世界那么大，快去书城挑本书看吧";
    }
    return _emptyRackView;
}

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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = LineLabelColor;
    _tableView.backgroundColor = LineLabelColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0.f, 0.f, 0.f));
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (IsLogin) {
        [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
        [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
        [_tableView setFooterRefreshingText:@"加载中..."];
        [_tableView setFooterPullToRefreshText:@"上拉加载更多"];
        [_tableView setFooterReleaseToRefreshText:@"松开加载"];
    }
    
    _currenPage = 1;
    [self setupReadRecord];
}

- (void)setupReadRecord{

    if (IsLogin) {
        
        [SVProgressHUD showWithStatus:@"加载中，请耐心等候" maskType:SVProgressHUDMaskTypeClear];
        
        [self requestFirstPage];

    }else {
       
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
        
        //存放的是readRecord类型
        self.readRecordArray = [dataManager getAllReadRecord];
        //LRLog(@"readRecordArray---%@",((BookInforModel *)(_readRecordArray[0])).introuce)
        NSMutableArray *arrayNew = [NSMutableArray arrayWithArray:self.readRecordArray];
        
        self.readRecordArray = [self.readRecordArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {//按时间排序
            
            return [((BookInforModel *)obj1).time compare:((BookInforModel *)obj2).time options:NSNumericSearch];
        }];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:arrayNew];
        
        if (self.readRecordArray.count > 20) {//阅读记录大于20本书
            for (int i = 20; i < array.count; i ++) {
                BookInforModel *readRecord = array[i];
                [dataManager removeReadRecordWithBookid:readRecord.bookid];
            }
        }
        self.readRecordArray = array;
        [_tableView reloadData];
    }
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
    titleMainLabel.text = [NSString stringWithFormat:@"云书架"];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.readRecordArray.count) {
        return self.readRecordArray.count;

    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.readRecordArray.count) {
        ReadRecordCell *cell = [ReadRecordCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.readRecordArray[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        cell.readBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            if (strongSelf.readRecordArray.count) {
                BookInforModel *readRecord = strongSelf.readRecordArray[indexPath.row];
                
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                BookInforModel *book = [dataManager getBookWithBookId:readRecord.bookid];

                if (!readRecord.isAddBook || [readRecord.isAddBook isEqual:@0]) {
                    // 加入书架
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    NSMutableDictionary *bookDic = [NSMutableDictionary dictionary];
                    NSDate *currentDate = [NSDate date];
                    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
                    dic[@"dateTime"] = dateString;
                    dic[@"book"] = bookDic;
                    dic[@"book"][@"bookId"] = readRecord.bookid;
                    dic[@"book"][@"coverWap"] = readRecord.coverurl;
                    dic[@"book"][@"bookName"] = readRecord.bookName;
                    dic[@"book"][@"author"] = readRecord.author;
                    dic[@"book"][@"introduction"] = readRecord.introuce;
                    
                    [dataManager insertData:dic];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
                    
                    readRecord.isAddBook = @1;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    
                }else {
                    // 继续阅读
                    NSArray *catelogArray = [dataManager getAllCatelogFromBook:readRecord.bookid];
                    if (catelogArray.count<20) {//没有数据缓存过本地数据库
                        [[AppDelegate sharedApplicationDelegate].window showLoadingView];
                        
                        _index = indexPath.row;
                        
                        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
                        requestData[@"v"] = @"2";
                        requestData[@"payWay"] = @"2";
                        requestData[@"chapterStatus"] = @"20";
                        requestData[@"defbook"] = @"1";
                        requestData[@"bookId"] = book.bookid;
                        requestData[@"chapterEndId"] = @"";
                        [strongSelf.networkModel registerAccountAndCall:110 andRequestData:requestData];
                        
                        //        strongSelf.DBModel = [[JYS_SqlManager alloc] initWithResponder:strongSelf];
                        //        [strongSelf.DBModel getCatelogAndCall:110 andRequestData:requestData andIsEnd:NO];
                    } else {
                        //存放的是Catelog类型
                        NSArray *chapterType = catelogArray;
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
                        NSDictionary *dict = @{@"bookID" : readRecord.bookid,@"bookName" : readRecord.bookName};
                        [MobClick event:@"ClickReadRecord" attributes:dict];
                        E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
                        readVC.bookID = readRecord.bookid;
                        readVC.chapterID = readRecord.currentCatelogId;
                        readVC.bookName = readRecord.bookName;
                        readVC.bookIcon = readRecord.coverurl;
                        readVC.author = readRecord.author;
                        readVC.introude = readRecord.introuce;
                        readVC.totalChapter = catelogArray.count;
                        readVC.totalTitlArray = chapterNameList;
                        readVC.chapterIdListArray = chapterIdList;
                        readVC.NoUpdateChapter = YES;
                        [strongSelf presentViewController:readVC animated:YES completion:nil];
                        
                    }
                }
            }
        };
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyRackView];
        return cell;
    }
}

#pragma mark - 网络请求
- (NetworkModel *)networkModel {
    
    if (!_networkModel) {
        _networkModel = [[NetworkModel alloc] initWithResponder:self];
    }
    
    return _networkModel;
}

- (void)receiveMessage:(Message *)message{
    
    [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
    
    if (message.call == 110) {
        if (message.resultCode == 0) {
            //目录列表
            NSArray *chapterIdList = message.responseData[@"chapterIdList"];
            
            //目录列表名
            NSArray *chapterNameList = message.responseData[@"chapterNameList"];
            
            BookInforModel *readRecord = self.readRecordArray[_index];
            NSDictionary *dict = @{@"bookID" : message.responseData[@"bookId"],@"bookName" : readRecord.bookName};
            [MobClick event:@"ClickReadRecord" attributes:dict];
            
            E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
            readVC.bookID = [NSString stringWithFormat:@"%@",message.responseData[@"bookId"]];
            readVC.chapterID = chapterIdList[0];
            
            readVC.bookName = readRecord.bookName;
            readVC.bookIcon = readRecord.coverurl;
            readVC.author = readRecord.author;
            readVC.introude = readRecord.introuce;
            readVC.totalChapter = chapterIdList.count;
            readVC.totalTitlArray = chapterNameList;
            readVC.chapterIdListArray = chapterIdList;
            readVC.NoUpdateChapter = YES;
            [self presentViewController:readVC animated:YES completion:nil];
        }
    }else if (message.call == 213) {
        [SVProgressHUD dismiss];
        if (message.resultCode == 0) {
            if (![message.responseData isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSArray *array = message.responseData[@"list"];
            NSMutableArray *newArray = [NSMutableArray array];
            for (int i = 0; i < array.count; ++i) {
                NSDictionary *dic = array[i];
                BookInforModel *model = [[BookInforModel alloc] init];
                model.author = dic[@"author"];
                model.bookid = dic[@"bookId"];
                model.bookName = dic[@"bookName"];
                model.coverurl = dic[@"coverWap"];
                model.introuce = dic[@"indroduce"];
                model.time = dic[@"timeTips"];
                model.dateTime = dic[@"timeTips"];
                BookInforModel *book = [[JYS_SqlManager shareManager] getBookWithBookId:dic[@"bookId"]];
                if (book) {
                    model.isAddBook = book.isAddBook;
                }
                [newArray addObject:model];
            }
            
            if (_isFooter) {
                [_tableView footerEndRefreshing];
                self.readRecordArray = [self.readRecordArray arrayByAddingObjectsFromArray:newArray];

                if (array.count == 20) {
                    _currenPage++;
                }else {
//                    NSLog(@"没更多数据了");
                    _isNoMoreData = YES;
                }
                
            }else {
                [_tableView headerEndRefreshing];
                self.readRecordArray = newArray;
            }
            
            [_tableView reloadData];
        }else {
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
        }
    }else if (message.call == 216) {
//        NSLog(@"%@", message.responseData);
    }
    
}

#pragma mark - 请求第一页数据
- (void)requestFirstPage
{
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"pIndex"] = @1;
    requestData[@"totalNum"] = @20;
    [self.networkModel registerAccountAndCall:213 andRequestData:requestData];
}

#pragma mark - 下拉刷新、更多
- (void)headerRefresh
{
    _isFooter = NO;
    [self requestFirstPage];
    _currenPage = 1;
    _isNoMoreData = NO;
}

- (void)footerRefresh
{
    _isFooter = YES;
    
    if (_isNoMoreData) {
        [_tableView footerEndRefreshing];
    }else {
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"pIndex"] = @(_currenPage+1);
        requestData[@"totalNum"] = @20;
        [self.networkModel registerAccountAndCall:213 andRequestData:requestData];
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.readRecordArray.count) {
        return 110;
    } else {
        return ScreenHeight ;
    }
}

#pragma mark - 左滑删除书籍
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.readRecordArray];
        BookInforModel *readRecord = array[indexPath.row];
        
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"];
        if (isLogin) {
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            BookInforModel *bookRack = [dataManager getBookWithBookId:readRecord.bookid];
            if (bookRack != nil) {
                [dataManager removeReadRecordWithBookid:bookRack.bookid];
            }
            NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
            requestData[@"bookId"] = readRecord.bookid;
            requestData[@"type"] = @"2";
            [self.networkModel registerAccountAndCall:216 andRequestData:requestData];
        } else {
            JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            BookInforModel *bookRack = [dataManager getBookWithBookId:readRecord.bookid];
            if (bookRack != nil) {
                [dataManager removeReadRecordWithBookid:bookRack.bookid];
            }
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
        
        [array removeObjectAtIndex:[indexPath row]];
        
        self.readRecordArray = array;
        
        if (array.count) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



@end
