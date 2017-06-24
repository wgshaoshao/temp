//
//  CommentViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentViewCell.h"

@interface CommentViewController ()

@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSArray *commentArray;

@end

@implementation CommentViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];

    [self createNavigationBarView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_navigationBarView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestBookComment129];
}

#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
//    _navigationBarView.backgroundColor = ADColor(220, 220, 220);
    [self.navigationController.navigationBar addSubview:_navigationBarView];

    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"评论"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font17;
    titleMainLabel.textColor = WhiteColor;
    titleMainLabel.backgroundColor = [UIColor clearColor];
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
    
//    UIButton *backTopBtn = [[UIButton alloc] init];
//    [backTopBtn addTarget:self action:@selector(backTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_navigationBarView addSubview:backTopBtn];
//    [backTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_navigationBarView).with.offset(0.0f);
//        make.left.equalTo(closeButton.mas_right).with.offset(0.0f);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//    }];
//    [closeButton setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
    
    
}

#pragma mark - 返回到上一级
- (void)closeWindowClick{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求内容评论
- (void)requestBookComment129{

    self.networkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookIDComment;
    [self.networkModel registerAccountAndCall:129 andRequestData:requestData];
}


#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.resultCode == 0) {//resultCode==0 成功
        
        //存评论数组模型
        _commentArray = [CommentModel objectArrayWithKeyValuesArray:message.responseData];
        [self.tableView reloadData];
    }
}


#pragma mark - TableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentModel *model = self.commentArray[indexPath.row];
    CommentViewCell *cell = [CommentViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model ;
    return cell;
}

#pragma mark - 点击cell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    OneResultModel *model = self.reultArray[indexPath.row];
//    
//    BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
//    bookDetailVC.bookID = [NSString stringWithFormat:@"%ld",(long)model.bookId];
//    [self.navigationController pushViewController:bookDetailVC animated:YES];
//}
//
#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

@end
