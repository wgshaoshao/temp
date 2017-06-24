//
//  BookManageController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookManageController.h"
#import "BookManageCell.h"
#import "OneBookManageView.h"
#import "BookManageView.h"
#import "BookDetailController.h"

#define BottomViewHeight 70.f

@interface BookManageController ()<UITableViewDataSource,UITableViewDelegate,OneBookManageViewDelegate,BookManageViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OneBookManageView *oneBookV;
@property (nonatomic, strong) BookManageView *bookManageView;
@property (nonatomic, strong) NSMutableArray *selectBookArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableDictionary *deleteDict;
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, assign) BOOL isSecondClick;
@end

@implementation BookManageController

- (NSMutableArray *)indexArray{

    if (_indexArray == nil) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}


- (NSMutableArray *)selectBookArray{

    if (_selectBookArray == nil) {
        _selectBookArray = [[NSMutableArray alloc] init];
    }
    return _selectBookArray;
}

- (BookManageView *)bookManageView{

    if (_bookManageView == nil) {
        _bookManageView = [[BookManageView alloc] initWithFrame:CGRectZero];
        _bookManageView.delegate = self;
        [self.view addSubview:_bookManageView];
        WEAKSELF
        [_bookManageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.height.equalTo(@(BottomViewHeight));
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
        }];
    }
    return _bookManageView;
}

- (OneBookManageView *)oneBookV{
    if (_oneBookV == nil) {
        _oneBookV = [[OneBookManageView alloc] initWithFrame:CGRectZero];
        _oneBookV.delegate = self;
        _oneBookV.isRed = NO;
        [self.view addSubview:_oneBookV];
        WEAKSELF
        [_oneBookV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.height.equalTo(@(BottomViewHeight));
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
        }];
    }
    return _oneBookV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.title = @"书籍管理";
    
    _deleteDict = [[NSMutableDictionary alloc] init];
    
    [self setUpNavigationBarItems];
    
    [self setupOneManageView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.pagingEnabled = YES ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableView.backgroundColor = ADColor(242, 242, 242);
    [self.view addSubview:_tableView];
    WEAKSELF
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0.f, 0.f, BottomViewHeight, 0.f));
    }];
}

#pragma mark - 设置导航条
- (void)setUpNavigationBarItems{
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    self.navigationItem.leftBarButtonItem = backItem ;
    [backItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark - 返回
- (void)backItemAction:(UIBarButtonItem *)item{
    
    if (self.selectBookArray.count) {
        for (int i = 0; i < _bookManageArray.count; i++) {//循环把所有cell从selectBookArray删掉
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.isSelectBtn.selected = NO;
            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
            
            BookInforModel *bookRack = _bookManageArray[indexPath.row];
            
            [self.selectBookArray removeObject:bookRack];
            [self.indexArray removeObject:@(indexPath.row)];
        }
        self.bookManageView.hidden = YES;
        self.oneBookV.hidden = NO;
        
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(221, 221, 221);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 创建只选择一本书时的View
- (void)setupOneManageView{
    
    if (_bookManageArray.count) {//书架有书
        
        [self.bookManageView creatView];
        self.bookManageView.hidden = YES;
        
        [self.oneBookV creatView];
    }
}

#pragma mark - 选择一本书四个按钮的点击事件
- (void)OneBookManageViewBtnClick:(UIButton *)button{
    
    if (button.tag == 1) {//删除
        
        [self setupDeleteOneBook];
    } else if (button.tag == 2) {//详情
        
        [self setupGotoDetail];
    } else if (button.tag == 3) {//更新
        
        [self updateBook];
        
    } else if (button.tag == 4) {//全选
        
        [self setupSaveAllCell];
    }
}

#pragma mark - 1本书时点击详情
- (void)setupGotoDetail{
    
    if (self.selectBookArray.count) {
        
        BookInforModel *bookRack = self.selectBookArray[0];
        
        BookDetailController *bookDetailVC = [[BookDetailController alloc] init];
        bookDetailVC.sourceFrom = @"BookManager";
        bookDetailVC.bookID = bookRack.bookid;
        [self.navigationController pushViewController:bookDetailVC animated:YES];
    } else {
        
        [self.view showAlertTextWith:@"请您选择一本书籍"];
    }
}

#pragma mark - 1本书时点击删除
- (void)setupDeleteOneBook{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:_bookManageArray];
    
    if (self.selectBookArray.count) {
        
        BookInforModel *bookRack = self.selectBookArray[0];
        if (bookRack != nil) {
            
            [dataManager removeBookRackWithBook:bookRack.bookid];
           
        }
        
        [array removeObject:bookRack];
        _bookManageArray = array;
        [self.selectBookArray removeObject:bookRack];
        
        NSString *index = self.indexArray[0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:0];
        BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.isSelectBtn.selected = NO;
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
        [_indexArray removeObject:@([index integerValue])];
//        [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [_deleteDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        
        if (!_bookManageArray.count) {
            
            self.oneBookV.hidden = YES;
            self.bookManageView.hidden = YES;
            
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
        //删除一本书回复删除按钮颜色
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(221, 221, 221);
        
        [self.tableView reloadData];
    } else {
        
        [self.view showAlertTextWith:@"请您选择一本书籍"];
    }
}

#pragma mark - 少于2本书时点击全选
- (void)setupSaveAllCell{
    
    if (_bookManageArray.count == self.selectBookArray.count) {
        [self.oneBookV.allButton setTitle:@"全选" forState:UIControlStateNormal];
        for (int i = 0; i < _bookManageArray.count; i++) {//循环把所有cell从selectBookArray删掉
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.isSelectBtn.selected = NO;
            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
            
            BookInforModel *bookRack = _bookManageArray[indexPath.row];
            
            [self.selectBookArray removeObject:bookRack];
            [self.indexArray removeObject:@(indexPath.row)];
            [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
        self.bookManageView.hidden = YES;
        self.oneBookV.hidden = NO;
        
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(221, 221, 221);
    } else {
        [self.bookManageView.allButton setTitle:@"取消全选" forState:UIControlStateNormal];
        for (int i = 0; i < _bookManageArray.count; i++) {//循环把所有没有添加到selectBookArray的cell加进去
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
      
            
            [_deleteDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            if (cell.isSelectBtn.selected == NO) {//没选中点击过后为选中状态、
                
                cell.isSelectBtn.selected = YES;
                [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateNormal];
                
                BookInforModel *bookRack = _bookManageArray[indexPath.row];
                
                if (self.indexArray.count) {
                    for (int i = 0; i < self.indexArray.count; i ++) {
                        
                        NSInteger index = [self.indexArray[i] integerValue];
                        
                       
                        if (index == indexPath.row) {//存在
                            _isManage = YES;
                            break;
                        } else {
                            _isManage = NO;
                        }
                    }
                    
                    if (!_isManage) {
                        [self.selectBookArray addObject:bookRack];
                        [self.indexArray addObject:@(indexPath.row)];
                    }
                } else {
                    [self.selectBookArray addObject:bookRack];
                    [self.indexArray addObject:@(indexPath.row)];
                }
                
            }
        }
        
 
        if (self.selectBookArray.count > 1) {//显示bookManageView
            self.bookManageView.hidden = NO;
            self.bookManageView.selectLabel.text = [NSString stringWithFormat:@"已选%lu本",(unsigned long)self.selectBookArray.count];
            self.oneBookV.hidden = YES;
            
        } else if (self.selectBookArray.count == 1) {//显示oneBookV
            self.bookManageView.hidden = YES;
            self.oneBookV.hidden = NO;
            [self.oneBookV.allButton setTitle:@"取消全选" forState:UIControlStateNormal];
        
            [self.oneBookV.deleteBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.oneBookV.deleteBtn.backgroundColor = ADColor(216, 69, 60);
          
        }
    }
}


#pragma mark - 选择多本书三个按钮的点击事件
- (void)bookManageViewBtnClick:(UIButton *)button{

    if (button.tag == 1) {//删除
        
        [self setupDeleteMoreBook];
        
    } else if (button.tag == 2) {//更新
        
        [self updateBook];
    
    } else if (button.tag == 3) {//全选
        
        [self setupDeleteAllSelectCell];
    }
}

//更新
- (void)updateBook{

    if (!_isSecondClick) {
        if (self.selectBookArray.count) {//书架有书
            
            _isSecondClick = YES;
            [SVProgressHUD showWithStatus:@"检查更新中" maskType:SVProgressHUDMaskTypeNone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"更新成功"];
                _isSecondClick = NO;
            });
        } else {
            
            [self.view showAlertTextWith:@"请您选择一本书籍"];
        }
    }
}

#pragma mark - 多本书的时候点击删除
- (void)setupDeleteMoreBook{

    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:_bookManageArray];
    
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:_selectBookArray];
    
    NSMutableArray *newIndexArray = [NSMutableArray arrayWithArray:self.indexArray];
    
    if (self.selectBookArray.count) {
        
        for (int i = 0; i < self.selectBookArray.count; i ++) {
            
            BookInforModel *bookRack = self.selectBookArray[i];
            
            if (bookRack != nil) {
                
                [dataManager removeBookRackWithBook:bookRack.bookid];
            }
            [array removeObject:bookRack];
            [selectArray removeObject:bookRack];
            
            
            
            NSString *index = self.indexArray[i];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index integerValue] inSection:0];
            BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.isSelectBtn.selected = NO;
            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
            [_deleteDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [newIndexArray removeObject:@([index integerValue])];
        }
        
        _bookManageArray = array;
        _indexArray = newIndexArray;
        _selectBookArray = selectArray;
        
        if (!_bookManageArray.count) {
            
            self.oneBookV.hidden = YES;
            self.bookManageView.hidden = YES;
        } else {
            self.oneBookV.hidden = NO;
            self.bookManageView.hidden = YES;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
        //删除多本书回复删除按钮颜色
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(221, 221, 221);
        
        [self.tableView reloadData];
    } else {
        
        [self.view showAlertTextWith:@"请您选择一本书籍"];
    }
}


#pragma mark - 多本书的时候点击全选
- (void)setupDeleteAllSelectCell{
    [self.bookManageView.allButton setTitle:@"全选" forState:UIControlStateNormal];
    
    if (self.selectBookArray.count < _bookManageArray.count) {//勾选超过2本小于总共书
        
        [self setupSaveAllCell];
        
    } else {//全部选中
        for (int i = 0; i < _bookManageArray.count; i++) {//循环把所有cell从selectBookArray删掉
  
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.isSelectBtn.selected = NO;
            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
            
            BookInforModel *bookRack = _bookManageArray[indexPath.row];
            
            [self.selectBookArray removeObject:bookRack];
            [self.indexArray removeObject:@(indexPath.row)];
            [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        self.bookManageView.hidden = YES;
        self.oneBookV.hidden = NO;
        
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(221, 221, 221);
    }
}


#pragma mark - TableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _bookManageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookManageCell *cell = [BookManageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _bookManageArray[indexPath.row];
    
    if ([[_deleteDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"YES"]) {
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateSelected];
        cell.isSelectBtn.selected = YES;
    }else if ([[_deleteDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqualToString:@"NO"]){
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
        cell.isSelectBtn.selected = NO;
    }
    
//    for (int i = 0; i < self.indexArray.count; i ++) {
//        int index = [self.indexArray[i] intValue];
//        
//        if (index == indexPath.row) {
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateNormal];
//            break ;
//        } else {
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
//        }
//    }
    
    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookManageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelectBtn.selected == NO) {//没选中点击过后为选中状态
        cell.isSelectBtn.selected = YES;
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_s"] forState:UIControlStateNormal];
        
        BookInforModel *bookRack = _bookManageArray[indexPath.row];
        
        [self.indexArray addObject:@(indexPath.row)];
        
        [self.selectBookArray addObject:bookRack];
        [_deleteDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    } else {//选中点击过后为没选中状态
        cell.isSelectBtn.selected = NO;
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"bookshelf_btn_n"] forState:UIControlStateNormal];
        [self.indexArray removeObject:@(indexPath.row)];

        BookInforModel *bookRack = _bookManageArray[indexPath.row];
        [self.selectBookArray removeObject:bookRack];
        [_deleteDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    if (self.selectBookArray.count) {//有选中的书籍
        
        if (self.selectBookArray.count > 1) {//显示bookManageView
            
            if (self.selectBookArray.count == _bookManageArray.count) {
                [self.bookManageView.allButton setTitle:@"取消全选" forState:UIControlStateNormal];
            } else {
                [self.bookManageView.allButton setTitle:@"全选" forState:UIControlStateNormal];
            }
            self.bookManageView.hidden = NO;
            self.bookManageView.selectLabel.text = [NSString stringWithFormat:@"已选%lu本",(unsigned long)self.selectBookArray.count];
            self.oneBookV.hidden = YES;
        } else if (self.selectBookArray.count == 1) {//显示oneBookV
            if (self.selectBookArray.count == _bookManageArray.count) {
            
                [self.oneBookV.allButton setTitle:@"取消全选" forState:UIControlStateNormal];
            } else {
                [self.oneBookV.allButton setTitle:@"全选" forState:UIControlStateNormal];
            
            }
            self.bookManageView.hidden = YES;
            self.oneBookV.hidden = NO;
            
        }
        
        if (self.oneBookV.isRed == NO) {
            self.oneBookV.isRed = YES;
            [self.oneBookV.deleteBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.oneBookV.deleteBtn.backgroundColor = ADColor(216, 69, 60);
        }
        
    } else {//没有选中的书籍
        [self.oneBookV.allButton setTitle:@"全选" forState:UIControlStateNormal];
        self.oneBookV.isRed = NO;
        [self.oneBookV.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.oneBookV.deleteBtn.backgroundColor = ADColor(220, 220, 220);
    }
}

#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}



@end
