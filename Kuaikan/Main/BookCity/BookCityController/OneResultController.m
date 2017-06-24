//
//  OneResultController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/18.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "OneResultController.h"
#import "SearchResultController.h"
#import "OneResultCell.h"
#import "OneResultModel.h"
#import "BookDetailController.h"
#import "SearchMomentModel.h"
#import "SearchMainController.h"

@interface OneResultController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultController *searchResultVC;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) SearchMomentModel *searchMomentModel;
@property (nonatomic, strong) NSArray *reultArray;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation OneResultController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    
    [self createNavigationBarView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_navigationBarView removeFromSuperview];
    [_firstView removeFromSuperview];
    self.definesPresentationContext = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    self.view.backgroundColor = WhiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.tag = 10;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    
    [self requestSearchHotWord168];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //存储搜索记录
    [self setupSaveSearchRecord];
}

#pragma mark - 存储搜索记录
- (void)setupSaveSearchRecord{
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_keyWord forKey:@"keyWord"];
    [dict setObject:dateString forKey:@"recordTime"];
    
    self.DBModel = [JYS_SqlManager shareManager];
    [self.DBModel insertSearchRecord:dict];
}


#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 44)];
    _navigationBarView.tag = 10;
    
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    _firstView = [[UIView alloc] init];
    _firstView.frame = CGRectMake(0, 0, 10, 44);
    [self.navigationController.navigationBar addSubview:_firstView];
    
    _searchResultVC = [[SearchResultController alloc] init];
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = _keyWord;
    self.searchController.searchBar.showsCancelButton = YES;
    self.searchController.searchBar.enablesReturnKeyAutomatically = NO;
    self.searchResultVC.tableView.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, ScreenWidth - 10, 44);
    //取消searchbar背景色
    self.searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchController.searchBar.bounds.size];
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    self.searchController.view.backgroundColor = [UIColor clearColor];
    for (UIView *view in [[self.searchController.searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = Font15;
            [cancelBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }
    [_navigationBarView addSubview:self.searchController.searchBar];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 请求搜索结果数据
- (void)requestSearchHotWord168{
    
    self.netWorkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"index"] = @(1);
    requestData[@"keyword"] = _keyWord;
    if ([_source isEqualToString:@"HotSearch"]) {
        NSString *str = [NSString stringWithFormat:@"%@+%@",_source,_keyWord];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:str forKey:@"keyword"];
        [MobClick event:@"SearchClick" attributes:dict];
    }
    [self.netWorkModel registerAccountAndCall:168 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.resultCode == 0) {//resultCode==0 成功

        if (message.call == 168) {
            NSArray *searchList = message.responseData[@"searchList"];
            NSArray *recomList = message.responseData[@"recomList"];
            if (searchList.count) {
                self.reultArray = (NSArray *)[OneResultModel objectArrayWithKeyValuesArray:message.responseData[@"searchList"]];
            } else {
                if (recomList.count) {
                    self.reultArray = (NSArray *)[OneResultModel objectArrayWithKeyValuesArray:message.responseData[@"recomList"]];
                }
            }
    
            
            [self.tableView reloadData];
        } else if (message.call == 166) {
                // 过滤结果交给我们的搜索结果表
            SearchResultController *tableController = (SearchResultController *)self.searchController.searchResultsController;
            tableController.resultArray = message.responseData;
            _resultArray = message.responseData;
            [tableController.tableView reloadData];
            
        }
    }
}

#pragma mark - 返回
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"];
    [MobClick event:@"SearchClick" attributes:dict];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    // 更新基于搜索文本过滤数组
    
    NSString *searchText = searchController.searchBar.text;
    
    //    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    
    // 剔除所有的首尾空格
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //搜索时请求数据
    [self requestSearchMoment166:strippedString];
}

#pragma mark - 键盘的搜索键
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    OneResultController *oneVC = [[OneResultController alloc] init];
    if (searchBar.text == nil || searchBar.text.length == 0) {
        // 内容为空，使用默认搜索框内容。
        oneVC.keyWord = searchBar.placeholder;
    } else {
        oneVC.keyWord = searchBar.text;
    }
    
    [self.navigationController pushViewController:oneVC animated:YES];
}

#pragma mark - 请求搜索时的数据
- (void)requestSearchMoment166:(NSString *)keyWord{
    
    self.searchMomentModel = [[SearchMomentModel alloc]initWithResponder:self];
    
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"keyword"] = keyWord;
    [self.searchMomentModel registerAccountAndCall:166 andRequestData:requestData];
}

#pragma mark - TableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _reultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OneResultModel *model = self.reultArray[indexPath.row];
    OneResultCell *cell = [OneResultCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model ;
    
    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.tag == 10) {
        OneResultModel *model = self.reultArray[indexPath.row];
        
        BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
        bookDetailVC.sourceFrom = @"SearchReasult";
        bookDetailVC.bookID = [NSString stringWithFormat:@"%@",model.bookId];
        bookDetailVC.enterIndex = 100;
        [self.navigationController pushViewController:bookDetailVC animated:YES];
    } else {
        NSDictionary *dict = _resultArray[indexPath.row];
        
        OneResultController *oneVC = [[OneResultController alloc] init];
        oneVC.keyWord = dict[@"key"];
        [self.navigationController pushViewController:oneVC animated:YES];
    }
}

#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 10) {
        return 153;
    } else {
        return 44;
    }
}

@end
