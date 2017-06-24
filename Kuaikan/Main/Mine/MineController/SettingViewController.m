//
//  SettingViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/13.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingFirestCell.h"
#import "SettingSecondCell.h"
#import "SettingThirdCell.h"
#import "IdeaFeedBackController.h"
#import "CancelAutoBuyController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,SettingFirestCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign) float cacheNumber;

@end

@implementation SettingViewController

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
    _tableView.backgroundColor = BackViewColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0.f, 0.f, 0.f));
    }];
    _firstArray = @[@"白天/夜间模式"];
    _secondArray = @[@"意见反馈"];
//暂时不清除书籍缓存只清楚sdWebImage的缓存
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"MyCache"];
//    _cacheNumber = [self folderSizeAtPath:documentsDirectory];
    _cacheNumber = [[SDImageCache sharedImageCache] getSize] / 1024.00 /1024.0;
    
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
    titleMainLabel.text = [NSString stringWithFormat:@"设置"];
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
        return 1;
    } else if (section == 3) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 || section == 2 || section == 3) {
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
        SettingFirestCell *cell = [SettingFirestCell cellWithTableView:tableView];
        cell.iconImageView.image = [UIImage imageNamed:@""];
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_firstArray[indexPath.row]];
        return cell;
    } else if (indexPath.section == 1) {
        SettingSecondCell *cell = [SettingSecondCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"取消自动订购下章";
        cell.arrowImageView.image = [UIImage imageNamed:@"me_def_icon"];
        return cell;

    } else if (indexPath.section == 2) {
        SettingSecondCell *cell = [SettingSecondCell cellWithTableView:tableView];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",_secondArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrowImageView.image = [UIImage imageNamed:@"me_def_icon"];
        return cell;

    } else if (indexPath.section == 3) {
        SettingThirdCell *cell = [SettingThirdCell cellWithTableView:tableView];
        cell.titleLabel.text = @"清除缓存";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_cacheNumber) {
            cell.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",_cacheNumber];
        } else {
            cell.cacheLabel.text = @"已清理";
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
        [self setupCancelAutoBuy];
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            [self setupIdeaFeed];
        }
    } else if (indexPath.section == 3) {
        [self setupClearCache];
    }
}


#pragma mark - 取消自动订购下章
- (void)setupCancelAutoBuy{
    
    CancelAutoBuyController *cancelAutoVC = [[CancelAutoBuyController alloc] init];
    [self.navigationController pushViewController:cancelAutoVC animated:YES];

}

#pragma mark - 清除缓存
- (void)setupClearCache{
    
    UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"清除缓存" message:@"确定清除缓存" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alvertView.delegate = self;
    
    if (_cacheNumber > 0) {
        [alvertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"MyCache"];
        //清理缓存
        [self clearCache:documentsDirectory];
        
        _cacheNumber = 0;
        
        [SVProgressHUD showWithStatus:@"清理缓存中" maskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        });
        
    }
}

#pragma mark - 意见反馈
- (void)setupIdeaFeed{

    IdeaFeedBackController *ideaFeedVC = [[IdeaFeedBackController alloc] init];
    [self.navigationController pushViewController:ideaFeedVC animated:YES];
}

#pragma mark - 开关的点击事件
- (void)settingFirstBtnClick:(UISwitch *)mySwitch{

    if (mySwitch.tag == 0) {//白天/夜间模式
        
        if (mySwitch.isOn) {
            [AppDelegate sharedApplicationDelegate].nightView.alpha = NightAlpha;
        } else {
            [AppDelegate sharedApplicationDelegate].nightView.alpha = 0.0;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:@([AppDelegate sharedApplicationDelegate].nightView.alpha) forKey:@"NightAlpha"];
    }
}

/**
 *  计算单个文件大小
 */
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

/**
 *  计算目录大小  遍历文件夹获得文件夹大小，返回多少M
 */
-(float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.000;
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];

        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}


/**
 *  清理缓存文件
 */
-(void)clearCache:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        
//        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
//        NSString *chapterId = nil;
//        
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//            
//            if ([fileName rangeOfString:@".txt"].location != NSNotFound) {
//                
//                chapterId = [fileName stringByReplacingOccurrencesOfString:@".txt" withString:@""];
//                dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    Chapter *chapter = [dataManager FetchEntitysWithName:@"Chapter" entityId:chapterId];
//                    
//                    [dataManager deleteObject:chapter];
//                    [dataManager save];
//                });
//                
//            }
//        }
        NSArray *subpaths = [fileManager contentsOfDirectoryAtPath:path error:nil];
        
        for (NSString *subPath in subpaths) {
            NSString *filePath = [path stringByAppendingPathComponent:subPath];
            [fileManager removeItemAtPath:filePath error:nil];
        }
        
    }
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] cleanDisk];
}
@end
