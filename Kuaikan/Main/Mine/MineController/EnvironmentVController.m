//
//  EnvironmentVController.m
//  Kuaikan
//
//  Created by 少少 on 17/1/18.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import "EnvironmentVController.h"

@interface EnvironmentVController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *environmentArray;
@property (nonatomic, strong) NSString *siteUrlStr;
@end

@implementation EnvironmentVController

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
    
    _environmentArray = @[@"http://m.haohuida.cn",@"http://101.200.193.169:3080"];
    
    _siteUrlStr = @"http://m.haohuida.cn";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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

- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"切换网络环境"];
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
    
    
    return _environmentArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 53.5, ScreenWidth - 20, 0.5);
    label.backgroundColor = LineLabelColor;
    [cell addSubview:label];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_environmentArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleStr = nil;
    NSString *messageStr = nil;

    if (indexPath.row == 0) {//正式环境
        titleStr = @"正式环境";
        messageStr = @"是否确定切换到正式环境";
        _siteUrlStr = @"http://m.haohuida.cn";
    } else if (indexPath.row == 1) {//测试环境
        titleStr = @"测试环境";
        messageStr = @"是否确定切换到测试环境";
        _siteUrlStr = @"http://101.200.193.169:3080";
    }
    
    UIAlertView *alvertView=[[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alvertView.delegate = self;
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {//确定
        if (_siteUrlStr) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_siteUrlStr forKey:@"SITE_URL"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"switchSiteUrl"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestSearchHotWord119" object:self];
            [SVProgressHUD showSuccessWithStatus:@"切换成功"];
        }
    }
}




@end
