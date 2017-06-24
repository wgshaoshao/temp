//
//  AccountController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/11.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "AccountController.h"
#import "AccountHeadCell.h"
#import "AccountOtherCell.h"
#import "AccountLongCell.h"
#import "PersonalSignController.h"

@interface AccountController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *btnImageArray;
@property (nonatomic, strong) UIView *navigationBarView;

@end

@implementation AccountController

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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableView.backgroundColor = LineLabelColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0.f, 0.f, 0.f));
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _titleArray = @[@"昵称",@"密码"];
    _btnImageArray = @[@"My-account_icon_nickname",@"My-account_icon_password"];
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
    titleMainLabel.text = [NSString stringWithFormat:@"我的账户"];
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
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2 || section == 3) {
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
        AccountHeadCell *cell = [AccountHeadCell cellWithTableView:tableView];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        AccountOtherCell *cell = [AccountOtherCell cellWithTableView:tableView];
        cell.titleLab.text = _titleArray[indexPath.row];
        cell.contentLab.text = @"3232a";
        cell.btnImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_btnImageArray[indexPath.row]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        AccountLongCell *cell = [AccountLongCell cellWithTableView:tableView];
        cell.titleLab.text = @"绑定手机";
        cell.btnImageView.image = [UIImage imageNamed:@"My-account_icon_Bound-phone"];

//        cell.contentLab.text = @"未绑定";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3) {
        AccountLongCell *cell = [AccountLongCell cellWithTableView:tableView];
        cell.titleLab.text = @"切换用户";
        cell.btnImageView.image = [UIImage imageNamed:@"My-account_icon_switch"];
//        cell.contentLab.text = @"微信登录";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"退出登陆" forState:UIControlStateNormal];
        button.titleLabel.font = Font14;
        [button setTitleColor:ADColor(153, 153, 153) forState:UIControlStateNormal];
        button.frame = CGRectMake((ScreenWidth - 200) / 2, 20, 200, 40);
        button.backgroundColor = ADColor(221, 221, 221);
        [cell addSubview:button];
        return cell;
    }
    return nil;
}

#pragma mark - 退出登录
- (void)buttonClick{

}

#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 78;
    } else if (indexPath.section == 4) {
    
        return 100;
    } else {
        return 54;
    }
}


#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self setupPicker];//修改头像
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self setupUserName];//修改昵称
        } else if (indexPath.row == 1) {
            [self setupPsword];//修改密码
        }
    } else if (indexPath.section == 2) {
        [self setupBindingPhone];//绑定手机
    } else if (indexPath.section == 3) {
        [self setupCutUser];//切换用户
    }
}

#pragma mark - 切换用户
- (void)setupCutUser{
    
}

#pragma mark - 绑定手机
- (void)setupBindingPhone{
    
}

#pragma mark - 修改密码
- (void)setupPsword{

}

#pragma mark - 修改昵称
- (void)setupUserName{

    PersonalSignController *personVC = [[PersonalSignController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
}

//进入头像选择
- (void)setupPicker{
    
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相机中选择", nil];
    }else{
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机中选择", nil];
    }
    [sheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSUInteger sourceType = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
                
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            case 2:
                return;
                
            default:
                break;
        }
    }else{
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            
            return;
        }
    }
    UIImagePickerController *imagePic = [[UIImagePickerController alloc] init];
    imagePic.delegate = self;
    imagePic.allowsEditing = YES;
    imagePic.sourceType = sourceType;
    [self presentViewController:imagePic animated:YES completion:nil];
}

#pragma mark - 更改头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSData *data;
    if (UIImageJPEGRepresentation(image, 0.5)) {
        data = UIImageJPEGRepresentation(image, 0.5);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
