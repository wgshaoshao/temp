//
//  SearchMainController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/31.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SearchMainController.h"
#import "SearchResultController.h"
#import "SearchModel.h"
#import "SearchResultCell.h"
#import "JFTagListView.h"
#import "AllHotSearch.h"
#import "HistorySearchView.h"
#import "BookDetailController.h"
#import "SearchMomentModel.h"
#import "OneResultController.h"

static NSString *SearchResultCellID = @"SearchResultCell";

@interface SearchMainController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,JFTagListDelegate,AllHotSearchDelegate,HistorySearchDelegate,UITableViewDelegate>

@property (nonatomic, strong) SearchResultController *searchResultVC;
@property (nonatomic, strong) UISearchController    *searchController;
@property (nonatomic, strong) NSArray          *resultArray;
@property (nonatomic, strong) UIView           *navigationBarView;
//自定义标签View
@property (strong, nonatomic) JFTagListView    *tagList;
//Tag数组
@property (strong, nonatomic) NSMutableArray   *tagArray;
//标签的模式状态（显示、选择、编辑）
@property (assign, nonatomic) TagStateType     tagStateType;
@property (nonatomic, strong) AllHotSearch     *hotView;
@property (strong, nonatomic) JFTagListView    *tagListHistory;
@property (strong, nonatomic) NSMutableArray   *tagArrayHistory;
@property (assign, nonatomic) TagStateType     tagStateTypeHistory;
@property (nonatomic, strong) HistorySearchView *historyView;
@property (nonatomic, assign) CGFloat           searchHotHeight;
@property (nonatomic, assign) CGFloat           searchHistoryHeight;
@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) SearchMomentModel *searchMomentModel;
@property (nonatomic, strong) UIScrollView *searchTable;
@property (nonatomic, assign) NSInteger indexInt;
@property (nonatomic, strong) UIView *firstView;
//@property (nonatomic, assign) BOOL updateFrame;
@property (nonatomic, strong) NSArray *searchRecordArray;


@end

@implementation SearchMainController

- (UIScrollView *)searchTable{

    if (_searchTable == nil) {
        _searchTable = [[UIScrollView alloc] init];
        _searchTable.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _searchTable.alwaysBounceVertical = YES;
        _searchTable.delegate = self;
    }
    return _searchTable;
}

- (NSMutableArray *)tagArrayHistory{
    
    if (_tagArrayHistory == nil) {
        
        _tagArrayHistory = [[NSMutableArray alloc] init];
    }
    return _tagArrayHistory;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    self.definesPresentationContext = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
 
//    if (self.updateFrame) {
//        _searchTable.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
//    } else {
//        self.updateFrame = YES;
//    }
    [self createNavigationBarView];

    //查询是否有搜索记录
    [self setupSearchRecord];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_navigationBarView removeFromSuperview];
    [_firstView removeFromSuperview];
    self.definesPresentationContext = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = ADColor(230, 230, 230);
    
    [self.view addSubview:self.searchTable];
    
    _indexInt = 0;
    //统计搜索按钮点击和来源
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (_source.length) {
        [dict setValue:_source forKey:@"source"];
    }
    [MobClick event:@"SearchClick" attributes:dict];
    //请求获取搜索热词
    [self requestSearchHotWord111];
}


#pragma mark - 主动弹出键盘
- (void)delayMethod{
    
    [_searchController.searchBar becomeFirstResponder];
}

#pragma mark - 请求获取搜索热词
- (void)requestSearchHotWord111{

    self.networkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];

    [self.networkModel registerAccountAndCall:111 andRequestData:requestData];
}

#pragma mark - 请求搜索时的数据
- (void)requestSearchMoment166:(NSString *)keyWord{
    
    self.searchMomentModel = [[SearchMomentModel alloc]initWithResponder:self];
    
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"keyword"] = keyWord;
    
    //统计搜索内容
    [MobClick event:@"SearchClick" attributes:requestData];
    [self.searchMomentModel registerAccountAndCall:166 andRequestData:requestData];
}


#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.resultCode == 0) {//resultCode==0 成功
        
        //大家热搜数据
        if (message.call == 111) {
            _tagArray = message.responseData;
            
            [self creatHotSearch];
        } else if (message.call == 166) {
            
            // 过滤结果交给我们的搜索结果表
            SearchResultController *tableController = (SearchResultController *)self.searchController.searchResultsController;
            tableController.resultArray = message.responseData;
            _resultArray = (NSArray *)message.responseData;
            [tableController.tableView reloadData];
        }
    }
}

#pragma mark - 查询是否有搜索记录
- (void)setupSearchRecord{

    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    NSArray *searchRecord = [dataManager getAllSearchRecord];
    
    if (searchRecord.count>0) {//有搜索记录
        //存放的是record类型
        self.tagArrayHistory = nil;
        
        //Tag数据
        NSArray *historyArray = nil;
        
        historyArray = [searchRecord sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {
            return [((SearchReacordModel *)obj1).recordTime compare:((SearchReacordModel *)obj2).recordTime options:NSNumericSearch];
        }];
        
        for (int i = 0; i < historyArray.count; i ++) {
            SearchReacordModel *record = historyArray[i];
            
            [self.tagArrayHistory addObject:record.searchstr];
        }
        //刷新数据
        [self.tagListHistory reloadData:self.tagArrayHistory andTime:0];
    }
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

#pragma mark - 取消返回按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    if (searchBar.text.length) {
        [_firstView removeFromSuperview];
        [_navigationBarView removeFromSuperview];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"];
        [MobClick event:@"SearchClick" attributes:dict];
        [self searchDisplayController:nil didHideSearchResultsTableView:_searchResultVC.tableView];
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"];
        [MobClick event:@"SearchClick" attributes:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
    [self createNavigationBarView];
}

#pragma mark - 创建热搜View
- (void)creatHotSearch{
    
    _hotView = [[AllHotSearch alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth + 500, 44)];
    _hotView.delegate = self;
    [_hotView creatUI];
    [self.searchTable addSubview:_hotView];
    
    self.tagStateType = TagStateSelect;//选择模式
    
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight)];

    self.tagList.delegate = self;
    self.tagList.indexTag = 1000;
    //传入Tag数组初始化界面
    
    NSMutableArray *firstArray = nil;
    
    if (_tagArray.count) {
        
        firstArray = [self subArrayWithIndex:0 array:_tagArray length:15];
    }
//    self.tagList.tagViewBackgroundColor = [UIColor redColor];
    [self.tagList creatUI:firstArray];
    [self.searchTable addSubview:self.tagList];
    
    //以下属性是可选的
    //如果传的是字典的话，那么key为必传得
    self.tagList.tagArrkey = @"tags";
    self.tagList.tagBorderColor = ADColor(190, 190, 190);
    self.tagList.tagCornerRadius = 15;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    
    //刷新数据
    [self.tagList reloadData:firstArray andTime:0];
}

#pragma mark - 创建搜索历史View
- (void)creatSearchHistory{
    
    _historyView = [[HistorySearchView alloc] initWithFrame:CGRectMake(0, _searchHotHeight + 44  + 10, ScreenWidth, 44)];
    _historyView.delegate = self;
    [_historyView creatUI];
    [self.searchTable addSubview:_historyView];

    //选择模式
    self.tagStateTypeHistory = TagStateSelect;
    
    //TagView
    self.tagListHistory = [[JFTagListView alloc] initWithFrame:CGRectMake(0, _searchHotHeight + 44  + 44 + 10, ScreenWidth, ScreenHeight)];
    self.tagListHistory.delegate = self;
    self.tagListHistory.indexTag = 2000;
    [self.tagListHistory creatUI:self.tagArrayHistory];   //传入Tag数组初始化界面
    [self.searchTable addSubview:self.tagListHistory];
    self.searchTable.contentSize = CGSizeMake(ScreenWidth,_searchHotHeight + 44 + 10 + 44 + _searchHistoryHeight);
    
    //以下属性是可选的
    //如果传的是字典的话，那么key为必传得
    self.tagListHistory.tagArrkey = @"name";
    self.tagListHistory.tagBorderColor = ADColor(190, 190, 190);
    self.tagListHistory.tagCornerRadius = 15;  //标签圆角的大小，默认10
    self.tagListHistory.tagStateType = self.tagStateTypeHistory;  //标签模式，默认显示模式
    
    //刷新数据
    [self.tagListHistory reloadData:self.tagArrayHistory andTime:0];
    
    //主动弹出键盘
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
}


#pragma mark - 点击刷新按钮
- (void)allHotSearchRefreshBtn{
    
    _indexInt = _indexInt + 5;
    
    NSMutableArray *refreshArray = nil;
    
    if (_tagArray.count) {
        refreshArray = [self subArrayWithIndex:_indexInt array:_tagArray length:15];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"change" forKey:@"change"];
    [MobClick event:@"SearchClick" attributes:dict];
    [self.tagList reloadData:refreshArray andTime:0.1];
}

#pragma mark - 点击删除搜索历史按钮
- (void)historySearchDeleteBtn{
    
    if (self.tagListHistory.tagStateType == TagStateSelect) {
        self.tagListHistory.tagStateType = TagStateEdit;
    } else {
        self.tagListHistory.tagStateType = TagStateSelect;
    }
    
    [self.tagListHistory reloadData:self.tagArrayHistory andTime:0.1];
}

#pragma mark - TagView 代理
//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (taglist.tagStateType == TagStateEdit) {
        //删除Tag
        [self deleteTagRequest:buttonIndex];
    }else if (taglist.tagStateType == TagStateSelect){
        //选择tag
        NSString *selectName = @"";
        if (taglist.indexTag == 1000) {//热搜
            
            NSMutableArray *refreshArray = nil;
            if (_tagArray.count) {
                refreshArray = [self subArrayWithIndex:_indexInt array:_tagArray length:15];
            }
            NSDictionary *dict = refreshArray[buttonIndex];
            selectName = dict[@"tags"];
        } else if (taglist.indexTag == 2000) {//历史搜索记录
            selectName  = self.tagArrayHistory[buttonIndex];
        }
        
        OneResultController *oneResultVC = [[OneResultController alloc] init];
        oneResultVC.source = @"HotSearch";
        oneResultVC.keyWord = selectName;
        [self.navigationController pushViewController:oneResultVC animated:YES];
    }
}

#pragma mark- searchView的高度
-(void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight{
    
    if (taglist.indexTag == 1000) {//热搜
        
        if (_searchHotHeight != listHeight) {
            
            _searchHotHeight = listHeight;
            [_historyView removeFromSuperview];
            [self.tagListHistory removeFromSuperview];
            
            [self creatSearchHistory];
        }
        
    } else if (taglist.indexTag == 2000) {//历史
        
        _searchHistoryHeight = listHeight;
        self.searchTable.contentSize = CGSizeMake(ScreenWidth,_searchHotHeight + 44  + 10 + 44 + _searchHistoryHeight);
    }
}


#pragma mark- 删除Tag
-(void)deleteTagRequest:(NSInteger)index{
    
    NSString *keyword = self.tagArrayHistory[index];
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    BOOL record = [dataManager removeSearchRecordWithString:keyword];
    if (keyword.length) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:keyword forKey:@"delete"];
        [MobClick event:@"SearchClick" attributes:dict];
    }
    
    if (record) {
        //删除成功
    }else{
        //删除失败
    }
    
    [self.tagArrayHistory removeObjectAtIndex:index];
    [self.tagListHistory reloadData:self.tagArrayHistory andTime:0];
}

#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    _firstView = [[UIView alloc] init];
    _firstView.frame = CGRectMake(0, 0, 10, 44);
    [self.navigationController.navigationBar addSubview:_firstView];
    
    _searchResultVC = [[SearchResultController alloc] init];

    _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"女总裁";
    self.searchController.searchBar.showsCancelButton = YES;
    self.searchResultVC.tableView.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, ScreenWidth - 10, 44);
   
 
    //取消searchbar背景色
    self.searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchController.searchBar.bounds.size];

    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
	// 搜索栏内容为空时，仍要使用搜索按钮进行默认搜索。把智能显示搜索按钮功能关闭。
    self.searchController.searchBar.enablesReturnKeyAutomatically = NO;
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


#pragma mark - 键盘的搜索键
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    OneResultController *oneVC = [[OneResultController alloc] init];
    if (searchBar.text == nil || searchBar.text.length==0) {
		// 内容为空，使用默认搜索框内容。
        oneVC.keyWord = searchBar.placeholder;
    } else {
        oneVC.keyWord = searchBar.text;
    }
    
    [self.navigationController pushViewController:oneVC animated:YES];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    // 更新基于搜索文本过滤数组
    NSString *searchText = searchController.searchBar.text;

    // 剔除所有的首尾空格
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    //搜索时请求数据
    [self requestSearchMoment166:strippedString];
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _resultArray[indexPath.row];

    OneResultController *oneVC = [[OneResultController alloc] init];
    oneVC.keyWord = dict[@"key"];

    [self.navigationController pushViewController:oneVC animated:YES];
}


#pragma mark - 取消键盘弹出
- (void)touchesEndedClick{
    
    [_searchController.searchBar resignFirstResponder];
}


@end
