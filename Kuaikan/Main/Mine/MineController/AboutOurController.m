//
//  AboutOurController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AboutOurController.h"
#import "AboutFirstCell.h"
#import "SettingSecondCell.h"
#import "SettingThirdCell.h"
#import "AbountSecondCell.h"
#import "UserDealController.h"
#import "ErrorViewController.h"
#import "EnvironmentVController.h"

@interface AboutOurController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *thirdArray;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, assign) NSInteger pickViewIndex;

@end

@implementation AboutOurController

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
    
    self.view.backgroundColor = BackViewColor;
    
    _firstArray = @[@"使用协议"];
    _secondArray = @[@"客服热线",@"QQ/QQ群",@"微信",@"网址"];
    _thirdArray = @[@"400-118-0066",@"1329139338/179686501",@"kuaikanxiaoshuo",@"ishugui.com"];
    _selectArray = @[@"崩溃日志",@"切换环境"];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableView.backgroundColor = BackViewColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0.f, 0.f, 0.f));
    }];

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
    titleMainLabel.text = [NSString stringWithFormat:@"关于我们"];
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

#pragma mark - 返回上一级
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 4;
    } else if (section == 3) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 || section == 2 ) {
        return 10;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        AboutFirstCell *cell = [AboutFirstCell cellWithTableView:tableView];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [cell addGestureRecognizer:doubleTapGestureRecognizer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        SettingSecondCell *cell = [SettingSecondCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_firstArray[indexPath.row]];
        cell.arrowImageView.image = [UIImage imageNamed:@"me_def_icon"];
        return cell;
        
    } else if (indexPath.section == 2) {
        
        SettingThirdCell *cell = [SettingThirdCell cellWithTableView:tableView];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_secondArray[indexPath.row]];
        cell.cacheLabel.text = [NSString stringWithFormat:@"%@",_thirdArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 3) {
        
        AbountSecondCell *cell = [AbountSecondCell cellWithTableView:tableView];
        cell.backgroundColor = BackViewColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark - 快速点击快看阅读
- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer{
    
    ErrorViewController *errorView = [[ErrorViewController alloc] init];
    [self.navigationController pushViewController:errorView animated:YES];
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 185;
    } else if (indexPath.section == 1) {
        return 54;
    } else if (indexPath.section == 2) {
        return 54;
    } else {
        return 105;
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UserDealController *userDealVC = [[UserDealController alloc] init];
            [self.navigationController pushViewController:userDealVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self phoneBtnClick];
        } else {
            [self setupPastebord:indexPath.row];
        }
    }
}

//点击复制
- (void)setupPastebord:(NSInteger)index{

    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *text = [NSString stringWithFormat:@"%@",_thirdArray[index]];
    [pab setString:text];
    if (pab != nil) {
        if (index == 1) {

            [self.view showAlertTextWith:@"QQ号码已复制到手机剪切板"];
        } else if (index == 2) {

            [self.view showAlertTextWith:@"微信号码已复制到手机剪切板"];
        } else if (index == 3) {

            [self.view showAlertTextWith:@"网址已复制到手机剪切板"];
        }
    }
}

- (void)phoneBtnClick {
    
    NSString *phoneStr = _thirdArray[0];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:phoneStr otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSString *phoneStr = _thirdArray[0];
        NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = 2;//根据数组的元素个数返回几行数据
            break;
            
        default:
            break;
    }
    return result;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = nil;
    _pickViewIndex = row;
   
    switch (component) {
        case 0:
            title = _selectArray[row];
            break;
        default:
            break;
    }
    return title;
}


- (void)coverClick{

    [_cover removeFromSuperview];
}

- (void)buttonclick{
    
    [self coverClick];

    if (_pickViewIndex == 0) {//崩溃日志
        ErrorViewController *errorView = [[ErrorViewController alloc] init];
        [self.navigationController pushViewController:errorView animated:YES];
    } else if (_pickViewIndex == 1) {//切换环境
    
        EnvironmentVController *environmentVC = [[EnvironmentVController alloc] init];
        [self.navigationController pushViewController:environmentVC animated:YES];
    }
}

@end
