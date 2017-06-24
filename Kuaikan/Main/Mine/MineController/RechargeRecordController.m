//
//  RechargeRecordController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "RechargeRecordController.h"
#import "RechargeRecordCell.h"
#import "ZBBSwitch.h"
#import "RechargeModel.h"
#import "MJRefresh.h"
#import "ConsumeModel.h"
#import "ConsumeCell.h"
#import "EmptyView.h"

@interface RechargeRecordController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSMutableArray *rechargeRecordArray;
@property (nonatomic, strong) NSMutableArray *consumeRecordArray;
@property (nonatomic, assign) BOOL OnAndOff;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) NetworkModel *consumeModel;
@property (nonatomic, strong) EmptyView *emptyView;

@property BOOL isFooterRefresh;

@end

@implementation RechargeRecordController

- (EmptyView *)emptyView{

    if (_emptyView == nil) {
       
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _emptyView;
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

    _isFooterRefresh = NO;

    self.view.backgroundColor = WhiteColor;
    //充值记录
    [self requestRechargeRecord194];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableView.backgroundColor = BackViewColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self setupRefresh];
}

#pragma mark - UITableView下拉刷新
- (void)setupRefresh{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

#pragma mark - 头部刷新
- (void)headerRefreshing{
    
    _isFooterRefresh = NO;
     [_tableView headerEndRefreshing];
}

#pragma mark - 尾部刷新
- (void)footerRefreshing{
    
    _isFooterRefresh = YES;
    
    if (_isFooterRefresh) {
        [_tableView footerEndRefreshing];
    } else {
        [_tableView headerEndRefreshing];
    }
    [SVProgressHUD showImage:nil status:@"没有充值记录了"];
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
    titleMainLabel.text = [NSString stringWithFormat:@"充值记录"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
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


#pragma mark - 充值记录
- (void)requestRechargeRecord194{
    
    self.netWorkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"1";
    requestData[@"pIndex"] = @"1";
    requestData[@"totalNum"] = @"20";
    [self.netWorkModel registerAccountAndCall:194 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.resultCode == 0) {//resultCode==0 成功
        
        if (message.call == 194) {//充值记录
            
            NSDictionary *dict = message.responseData;
            if ([dict[@"list"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = dict[@"list"];
                if (array.count) {
                    
                    _rechargeRecordArray = (NSMutableArray *)[RechargeModel objectArrayWithKeyValuesArray:array];

                    [_tableView reloadData];
                }
            }
        }
    }
}

- (void)closeWindowClick{

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        if (_rechargeRecordArray.count) {
            return _rechargeRecordArray.count;
        } else {
            return 1;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
        if (_rechargeRecordArray.count) {
            RechargeModel *model = _rechargeRecordArray[indexPath.row];
            RechargeRecordCell *cell = [RechargeRecordCell cellWithTableView:tableView];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BackViewColor;
            self.emptyView.titleLabel.text = @"暂无充值记录";
            [cell.contentView addSubview:self.emptyView];
            return cell;
           
        }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

@end
