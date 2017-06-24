//
//  MineHomeController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/29.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "MineHomeController.h"
#import "MineTopView.h"
#import "UserViewCell.h"
#import "AccountController.h"
#import "SettingViewController.h"
#import "MessageController.h"
#import "RechargeController.h"
#import "RechargeRecordController.h"
#import "ReadRecordController.h"
#import "ActivityController.h"
#import "UserHelpController.h"
#import "LoginAndRegistController.h"
#import "H5ViewController.h"
#import "AboutOurController.h"
#import "UIImageView+LBBlurredImage.h"
#import "FreeH5Controller.h"
#import "SignInH5Controller.h"
#import "DrawAwardController.h"
#import "AwardCenterController.h"
#import <AVFoundation/AVFoundation.h>
#import "AccountSafeController.h"
#import "Function.h"

@interface MineHomeController ()<UITableViewDataSource,UITableViewDelegate,MineTopViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineTopView *mineTopView;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *firstArrayImage;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *secondArrayImage;
@property (nonatomic, strong) NSArray *thirdArray;
@property (nonatomic, strong) NSArray *thirdArrayImage;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, assign) BOOL isRefresh;//是否点击刷新按钮
@end

@implementation MineHomeController

- (MineTopView *)mineTopView{
    
    if (_mineTopView == nil) {
        _mineTopView = [[MineTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, MineTopViewH)];
        _mineTopView.delegate = self;
    }
    return _mineTopView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self setupRemainSum];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = NavigationColor;
    [self setupMineTopViewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestRemainSum) name:@"requestRemainSum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAccount) name:@"Login" object:nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableView.backgroundColor = BackViewColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(MineTopViewH, 0.f, 0.f, 0.f));
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"catelogCell"];
    
    _firstArray = @[@"充值",@"充值记录",@"云书架"];
    _firstArrayImage = @[@"me_cion_Recharge",@"me_icon_Recharge-record",@"me_icon_Reading-record"];
    _secondArray = @[@"签到",@"抽奖",@"今日免费",@"活动中心",@"奖品中心"];
    _secondArrayImage = @[@"me_icon_Sign_n",@"me_icon_Prize_n@2",@"me_icon_Free-limit_n",@"me_icon_activity",@"me_icon_Prize-Center_n@2"];
    _thirdArray = @[@"设置",@"账户安全",@"用户帮助",@"关于我们"];
    _thirdArrayImage = @[@"me_icon_set-up",@"me_account_icon",@"me_icon_help",@"me_icon_contact"];
    
}

#pragma mark - 获取余额
- (void)requestRemainSum{
    
    self.netWorkModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    NSString *UUID = [self getDeviceId];
    requestData[@"apkversion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    requestData[@"deviceId"] = UUID;
    [self.netWorkModel registerAccountAndCall:101 andRequestData:requestData];
}

#pragma mark - 获取设备唯一标识
- (NSString *)getDeviceId{
    
    //从钥匙串读取UUID：
    NSString *deviceUUID = [YFKeychainTool readKeychainValue:@"UUID"];
    
    if ([deviceUUID isEqualToString:@"(null)"] || deviceUUID == nil || [deviceUUID isEqualToString:@""]){
        
        NSUUID *currentDeviceUUID = [UIDevice currentDevice].identifierForVendor;
        deviceUUID = currentDeviceUUID.UUIDString;
        deviceUUID = [deviceUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        deviceUUID = [deviceUUID lowercaseString];
        [YFKeychainTool saveKeychainValue:deviceUUID key:BundleID];
    }
    
    return deviceUUID;
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (_isRefresh) {
        
        _isRefresh = NO;
        [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
    }
    
    
    if (message.resultCode == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
        
        NSString *remainSumBen = [[NSUserDefaults standardUserDefaults] objectForKey:@"remainSumDefaults"];
        if (!(remainSum == nil || [remainSum isEqualToString:@""] || [remainSum isEqualToString:@"(null)"])) {
            [userDefaults setObject:remainSum forKey:@"remainSumDefaults"];
            [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
        } else {
            
            
            if ([remainSumBen isEqualToString:@"(null)"]) {
                remainSumBen = [YFKeychainTool readKeychainValue:BundleIDRemainSum];
            }
            if ([remainSumBen isEqualToString:@"(null)"]) {
                remainSumBen = @"0";
            }
            
            remainSum = remainSumBen;
        }
        self.mineTopView.balanceLab.text = [NSString stringWithFormat:@"余额：%@",remainSum];
    } else {
        [SVProgressHUD showErrorWithStatus:@"网络出现错误，请您检查"];
    }
 
}

#pragma mark - 更新余额
- (void)setupRemainSum{
    
    NSString *remainSum = [[NSUserDefaults standardUserDefaults] objectForKey:@"remainSumDefaults"];
    
    if ([remainSum isEqualToString:@"(null)"]) {
        remainSum = [YFKeychainTool readKeychainValue:BundleIDRemainSum];
    }
    if ([remainSum isEqualToString:@"(null)"]) {
        remainSum = @"0";
    }
    self.mineTopView.balanceLab.text = [NSString stringWithFormat:@"余额：%@",remainSum];
}

#pragma mark - 第三方登录
- (void)loginAccount{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *remainSum = [userDefaults objectForKey:@"remainSumDefaults"];
    NSString *userID = [userDefaults objectForKey:@"userIDDefaults"];
    NSString *name = [userDefaults objectForKey:@"LoginNickname"];
    BOOL userIdIsUpdate = [[userDefaults objectForKey:@"userIdIsUpdate"] boolValue];
    
    NSString *coverWap = [userDefaults objectForKey:@"LoginCoverWap"];

    if (coverWap.length) {
        [self.mineTopView.headImage sd_setImageWithURL:[NSURL URLWithString:coverWap] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.mineTopView.backGroundImage setImageToBlur:self.mineTopView.headImage.image blurRadius:45 completionBlock:nil];
        }];
    } else {
    
        self.mineTopView.headImage.image = [UIImage imageNamed:@"me_icon_def"];
        
        [self.mineTopView.backGroundImage sd_setImageWithURL:nil placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.mineTopView.backGroundImage setImageToBlur:self.mineTopView.headImage.image blurRadius:45 completionBlock:nil];
        }];
    }
    
    
    
    
    if (userIdIsUpdate) {//更换了usrID
        self.mineTopView.userIDLabel.text = [NSString stringWithFormat:@"用户：K%@",userID];
    }
    
    BOOL isLoginSuccess = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"] boolValue];
    if (isLoginSuccess) {//登录状态
        self.mineTopView.registBtn.hidden = YES;
        self.mineTopView.refreshBtn.hidden = NO;
        self.mineTopView.nameLabel.text = name;
    } else {
        self.mineTopView.refreshBtn.hidden = YES;
        self.mineTopView.nameLabel.text = @"用户信息";
    }
    self.mineTopView.balanceLab.text = [NSString stringWithFormat:@"余额：%@",remainSum];
    
}

#pragma mark - 初始化MineTopView数据
- (void)setupMineTopViewData{
    
    NSString *remainSum = [[NSUserDefaults standardUserDefaults] objectForKey:@"remainSumDefaults"];
    if ([remainSum isEqualToString:@"(null)"]) {
        remainSum = [YFKeychainTool readKeychainValue:BundleIDRemainSum];
    }
    if ([remainSum isEqualToString:@"(null)"]) {
        remainSum = @"0";
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIDDefaults"];
    if ([userID isEqualToString:@"(null)"]) {
        userID = [YFKeychainTool readKeychainValue:BundleIDUserID];
    }
    if ([userID isEqualToString:@"(null)"]) {
        userID = @"";
    }
    [self.mineTopView creatView];
    self.mineTopView.userIDLabel.text = [NSString stringWithFormat:@"用户：K%@",userID];
    self.mineTopView.balanceLab.text = [NSString stringWithFormat:@"余额：%@",remainSum];
    
    BOOL isLoginSuccess = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"] boolValue];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginNickname"];
    if (isLoginSuccess) {//登录状态
        self.mineTopView.registBtn.hidden = YES;
        self.mineTopView.refreshBtn.hidden = NO;
        self.mineTopView.nameLabel.text = name;
    } else {
        self.mineTopView.refreshBtn.hidden = YES;
        self.mineTopView.nameLabel.text = @"用户信息";
    }
    
    NSData *iconImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconImage"];
    if (iconImageData) {
        self.mineTopView.headImage.image = [UIImage imageWithData:iconImageData];
        [self.mineTopView.backGroundImage sd_setImageWithURL:nil placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.mineTopView.backGroundImage setImageToBlur:self.mineTopView.headImage.image blurRadius:45 completionBlock:nil];
        }];
    } else {
        self.mineTopView.headImage.image = [UIImage imageNamed:@"me_icon_def"];
        
        [self.mineTopView.backGroundImage sd_setImageWithURL:nil placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.mineTopView.backGroundImage setImageToBlur:self.mineTopView.headImage.image blurRadius:45 completionBlock:nil];
        }];
    }
    
    [self.view addSubview:self.mineTopView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _firstArray.count;
    } else if (section == 1){
        return _secondArray.count;
    } else if (section == 2) {
        return _thirdArray.count;
    }  else {
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserViewCell *cell = [UserViewCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.contentLabel.text = _firstArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_firstArrayImage[indexPath.row]]];
    } else if (indexPath.section == 1) {
        cell.contentLabel.text = _secondArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_secondArrayImage[indexPath.row]]];
    } else if (indexPath.section == 2) {
        cell.contentLabel.text = _thirdArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_thirdArrayImage[indexPath.row]]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    https://itunes.apple.com/app/id990510286
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//充值
            RechargeController *rechargeVC = [[RechargeController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        } else if (indexPath.row == 1) {//充值记录

            [MobClick event:@"ClickRechargeRecord"];
            RechargeRecordController *rechargeRecordVC = [[RechargeRecordController alloc] init];
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        } else if (indexPath.row == 2) {//阅读记录
            
            [MobClick event:@"ClickReadRecord" attributes:nil];
            ReadRecordController *readRecordVC = [[ReadRecordController alloc] init];
            [self.navigationController pushViewController:readRecordVC animated:YES];
        }
        
    } else if (indexPath.section == 1) {
//
        if (indexPath.row == 0) {//签到
            [MobClick event:@"ClickSignIn"];
            SignInH5Controller *signInVC = [[SignInH5Controller alloc] init];
            [self.navigationController pushViewController:signInVC animated:YES];
        } else if (indexPath.row == 1) {//抽奖
            [MobClick event:@"ClickAward"];
            DrawAwardController *drawAwardVC = [[DrawAwardController alloc] init];
            [self.navigationController pushViewController:drawAwardVC animated:YES];
        } else if (indexPath.row == 2) {//今日免费
            [MobClick event:@"ClickFree"];
            FreeH5Controller *freeH5VC = [[FreeH5Controller alloc] init];
            [self.navigationController pushViewController:freeH5VC animated:YES];
        } else if (indexPath.row == 3) {//活动中心
            [MobClick event:@"ClickActivityCenter"];
            ActivityController *activityVC = [[ActivityController alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        } else if (indexPath.row == 4) {//奖品中心
            [MobClick event:@"ClickAwardCenter"];
            AwardCenterController *awardCenterVC = [[AwardCenterController alloc] init];
            [self.navigationController pushViewController:awardCenterVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//设置
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        } else if (indexPath.row == 1) {//账户与安全
            
            BOOL isLoginSuccess = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginSuccess"] boolValue];
            if (isLoginSuccess) {//登录状态
                AccountSafeController *accountSafeVC = [[AccountSafeController alloc] init];
                [self.navigationController pushViewController:accountSafeVC animated:YES];
            } else {
                
                [self.view showAlertTextWith:@"请先登录"];
            }
            
        } else if (indexPath.row == 2) {//用户帮助
            UserHelpController *userHelpVC = [[UserHelpController alloc] init];
            [self.navigationController pushViewController:userHelpVC animated:YES];
        } else if (indexPath.row == 3) {//联系我们
            AboutOurController *abountOurVC = [[AboutOurController alloc] init];
            [self.navigationController pushViewController:abountOurVC animated:YES];
        }
    }
}

#pragma mark - 更换头像
- (void)iconButtonClick{
    
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相机中选择", nil];
    } else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机中选择", nil];
    }
    [sheet showInView:self.view];
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSUInteger sourceType = 0;
    switch (buttonIndex) {
        case 0:
            if ([self isCameraAvailable]&&[self doesCameraSupportTakingPhotos]) {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否允许快看小说打开相机？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                alert.tag = 1000;
                [alert show];
                return;
                
            }
            break;
            
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        case 2:
            return;
            
        default:
            break;
    }
    
    UIImagePickerController *imagePic = [[UIImagePickerController alloc] init];
    imagePic.delegate = self;
    imagePic.allowsEditing = YES;
    imagePic.sourceType = sourceType;
    [self presentViewController:imagePic animated:YES completion:nil];
}
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if (paramMediaType  == nil){
        
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                
            }
        }
    }
}

#pragma mark - 更改头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSData *data;
    if (UIImageJPEGRepresentation(image, 1)) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    self.mineTopView.headImage.image = [UIImage imageWithData:data];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"iconImage"];
    
    
    [self.mineTopView.backGroundImage sd_setImageWithURL:nil placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.mineTopView.backGroundImage setImageToBlur:[UIImage imageWithData:data] blurRadius:45 completionBlock:nil];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 登录按钮
- (void)registButtonClick{
    
    LoginAndRegistController *loginAndRegistVC = [[LoginAndRegistController alloc] init];
    [self.navigationController pushViewController:loginAndRegistVC animated:YES];
}

#pragma mark - 刷新按钮
- (void)refreshButtonClick{
    
    _isRefresh = YES;
    
    [SVProgressHUD showWithStatus:@"刷新余额中..." maskType:SVProgressHUDMaskTypeClear];
    
    [self requestRemainSum];
    
}

@end
