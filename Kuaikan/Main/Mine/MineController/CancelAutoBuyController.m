//
//  CancelAutoBuyController.m
//  Kuaikan
//
//  Created by 少少 on 16/6/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CancelAutoBuyController.h"
#import "CancelAutoBuyCell.h"
#import "ConsumeModel.h"

@interface CancelAutoBuyController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSArray *bookRackArray;
@property (nonatomic, strong) NetworkModel *consumeModel;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) JYS_SqlManager *ABModel;


@end

@implementation CancelAutoBuyController

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
    
    //查询书架是否有数据
    [self setupBookRack];
    
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
}

#pragma mark - 查询书架是否有数据
- (void)setupBookRack{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];

    //存放的是booKRack类型
    
    self.bookRackArray = [dataManager getBookRackBooks];
    if (self.bookRackArray.count) {
        self.bookRackArray = [self.bookRackArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj2, id  _Nonnull obj1) {//按时间排序
            return [((BookInforModel *)obj1).time compare:((BookInforModel *)obj2).time options:NSNumericSearch];
            
        }];
        //刷新书架上的书
        //        NSIndexSet *bookRack = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadData];
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
    titleMainLabel.text = [NSString stringWithFormat:@"取消自动订购下章"];
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

- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bookRackArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookInforModel *bookRack = self.bookRackArray[indexPath.row];
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    BookInforModel *book = [dataManager getBookWithBookId:bookRack.bookid];
    
    CancelAutoBuyCell *cell = [CancelAutoBuyCell cellWithTableView:tableView];
    cell.nameLabel.text = bookRack.bookName;
    cell.mySwitch.userInteractionEnabled = NO;
    if ([book.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
        cell.mySwitch.on = YES;
    } else {
        cell.mySwitch.on = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookInforModel *bookRack = self.bookRackArray[indexPath.row];
    
    CancelAutoBuyCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell.mySwitch.on) {
    
        [cell.mySwitch setOn:NO animated:YES];
        
        self.ABModel = [JYS_SqlManager shareManager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:bookRack.bookid forKey:@"bookID"];
        [dict setObject:@(0) forKey:@"isAutoBuy"];
        [self.ABModel amendAutoBuy:dict];
    } else {
        [cell.mySwitch setOn:YES animated:YES];
        
        self.ABModel = [JYS_SqlManager shareManager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:bookRack.bookid forKey:@"bookID"];
        [dict setObject:@(1) forKey:@"isAutoBuy"];
        [self.ABModel amendAutoBuy:dict];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}


@end
