//
//  ErrorViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/11/3.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ErrorViewController.h"
#import "PlistViewController.h"

@interface ErrorViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *errorArray;
@end

@implementation ErrorViewController


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
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];

    self.view.backgroundColor = WhiteColor;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"ErrorLog"];
    _errorArray = [[NSMutableArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:path error:nil]];

    if (_errorArray.count) {
//        [_errorArray removeObjectAtIndex:0];
    }
    

    
//    NSString *pathTxT = [NSString stringWithFormat:@"%@",tempFileList[1]];
//    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathTxT]];
//    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    
//    UITextView *textView = [[UITextView alloc] init];
//    textView.font = Font18;
//    textView.text = content;
//    textView.editable = NO;
//    textView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [self.view addSubview:textView];
//    self.textView = textView;
    
//    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
//    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
//    [textView addGestureRecognizer:doubleTapGestureRecognizer];
    
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
    titleMainLabel.text = [NSString stringWithFormat:@"崩溃日志列表"];
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


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    return _errorArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 43.5, ScreenWidth - 20, 0.5);
    label.backgroundColor = LineLabelColor;
    [cell addSubview:label];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_errorArray[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PlistViewController *plistVC = [[PlistViewController alloc] init];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"ErrorLog"];
  
    NSString *pathTxT = [NSString stringWithFormat:@"%@",_errorArray[indexPath.row]];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathTxT]];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    plistVC.content = content;
    [self.navigationController pushViewController:plistVC animated:YES];
}


#pragma mark - 左滑删除书籍
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        self.view.backgroundColor = WhiteColor;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"ErrorLog"];
        NSString *pathTxT = [NSString stringWithFormat:@"%@",_errorArray[indexPath.row]];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pathTxT]];
        BOOL isDelete=[fileManager removeItemAtPath:path error:nil];
        if (isDelete) {
            [SVProgressHUD showSuccessWithStatus:@"成功删除记录"];
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:_errorArray];
//
//        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
//        
//        ReadRecord *readRecord = array[indexPath.row];
//        if (readRecord != nil) {
//            
//            [dataManager deleteObject:readRecord];
//        }
//        [dataManager ];
//        
        [array removeObjectAtIndex:[indexPath row]];
//
//        self.readRecordArray = array;
//
        _errorArray = array;
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
