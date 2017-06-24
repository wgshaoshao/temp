//
//  CatalogViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/22.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "CatalogViewController.h"
#import "E_ScrollViewController.h"
#import "OrderView.h"
#import "RechargeController.h"
#import "EnsureButton.h"
#import "CatelogViewCell.h"
#import "NewOrderView.h"
#import "NewThreeOrderView.h"
#import "NewTwoOrderView.h"
#import "CatalogTopView.h"
#import "ChapterListView.h"
#include "uchardet.h"
#define NUMBER_OF_SAMPLES   (2048)

@interface CatalogViewController ()<OrderViewDelegate,UITableViewDataSource,UITableViewDelegate,NewOrderViewDelegate,NewTwoOrderViewDelegate,NewThreeOrderViewDelegate,CatalogTopViewDelegate,ChapterListDelegate>

@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) NSArray *chapterNameList;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSArray *chapterIdListArray;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, assign) NSInteger myIndex;
@property (nonatomic, strong) NetworkModel *payCheckmodel;
@property (nonatomic, strong) OrderView *orderView;
@property (nonatomic, strong) NewOrderView *neworderView;
@property (nonatomic, strong) NewThreeOrderView *newthreeOrderView;
@property (nonatomic, strong) NewTwoOrderView *newtwoOrderView;
@property (nonatomic, strong) NSString *afterNum;
@property (nonatomic, strong) NetworkModel *consumeModel;
@property (nonatomic, strong) NSString *consumeChapterID;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYS_SqlManager *ABModel;
@property (nonatomic, assign) BOOL isAutoBuy;
@property (nonatomic, strong) NSNumber *action;
@property (nonatomic, strong) NSNumber *twoAction;
@property (nonatomic, strong) NSNumber *threeAction;
@property (nonatomic, strong) NSNumber *fourAction;
@property (nonatomic, strong) NSNumber *fiveAction;
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *priceUnit;
@property (nonatomic, strong) CatalogTopView *catalogTopView;
@property (nonatomic, strong) NSMutableArray *blockList;
@property (nonatomic, strong) ChapterListView *chapterListView;
@property (nonatomic, strong) NSMutableArray *chargeListArray;
@property (nonatomic, assign) BOOL haveBookRack;
@property (nonatomic, strong) ZipArchive *za;
@property (nonatomic, assign) const char *encode;//编码类型

@end

@implementation CatalogViewController

- (CatalogTopView *)catalogTopView{
    
    if (_catalogTopView == nil) {
        _catalogTopView = [[CatalogTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        _catalogTopView.delegate = self;
    }
    return _catalogTopView;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createNavigationBarView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_navigationBarView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestStoryMuenCall110];
    [self.view addSubview:self.catalogTopView];
    
    _isAutoBuy = YES;
    self.view.backgroundColor = WhiteColor;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(60.f, 0.f, 0.f, 0.f));
    }];
}

#pragma mark - 设置导航条
- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"目录"];
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
}



#pragma mark - 返回到上一级
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 请求小说的目录
- (void)requestStoryMuenCall110{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    BookInforModel *book = [dataManager getBookWithBookId:_bookIDCatalog];
    
    if (![book.isparkCatalog isEqualToNumber:@(1)]) {//没有数据缓存过本地数据库
        
        [SVProgressHUD showWithStatus:@"加载目录中，请耐心等候" maskType:SVProgressHUDMaskTypeClear];
        
        self.networkModel = [[NetworkModel alloc]initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"v"] = @"2";
        requestData[@"chapterStatus"] = @"9999";
        requestData[@"defbook"] = @"1";
        requestData[@"payWay"] = @"2";
        requestData[@"bookId"] = _bookIDCatalog;
        requestData[@"needBlockList"] = @"1";
        [self.networkModel registerAccountAndCall:110 andRequestData:requestData];
    } else {
        //存放的是Catelog类型
        NSArray *parkCatalogType = book.parkCatalog;
        if (parkCatalogType.count) {
            parkCatalogType = [parkCatalogType sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [((ParkCatelogModel *)obj1).entityid compare:((ParkCatelogModel *)obj2).entityid options:NSNumericSearch];
            }];
        }
        //存放的是catelogID数组
        NSMutableArray *blockList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < parkCatalogType.count; i ++) {
            ParkCatelogModel *parkCatalog = parkCatalogType[i];
            NSMutableDictionary *blockDict = [[NSMutableDictionary alloc] init];
            [blockDict setObject:parkCatalog.tips forKey:@"tips"];
            [blockList addObject:blockDict];
//            [chapterNameList addObject:catelog.c];
        }
        
        _blockList = blockList;
      
//        NSDictionary *firstDict = parkCatalogType[0];
        //存放的是Catelog类型
        NSArray *chapterType = [dataManager getAllCatelogFromBook:_bookIDCatalog];
        
        //存放的是catelogID数组
        NSMutableArray *chapterIdList = [[NSMutableArray alloc] init];
        
        //目录列表名
        NSMutableArray *chapterNameList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < chapterType.count; i ++) {
            CatelogInforModel *catelog = chapterType[i];
            
            [chapterIdList addObject:catelog.chaterId];
            [chapterNameList addObject:catelog.catelogName];
        }
        
        NSDictionary *firstDict = blockList[0];
        self.catalogTopView.chapterStr = firstDict[@"tips"];
        self.catalogTopView.totalStr = [NSString stringWithFormat:@"%lu",(unsigned long)chapterIdList.count];
        [self.catalogTopView creatView];
        
        _chapterIdListArray = chapterIdList;
        _chapterNameList = chapterNameList;
        [self.tableView reloadData];
    }
}

- (void)createCatalogTopView:(NSDictionary *)dict{
    
    _blockList = dict[@"blockList"];
    NSDictionary *firstDict = _blockList[0];
    NSArray *chapterIDList = dict[@"chapterIdList"];
    self.catalogTopView.chapterStr = firstDict[@"tips"];
    self.catalogTopView.totalStr = [NSString stringWithFormat:@"%lu",(unsigned long)chapterIDList.count];
    [self.catalogTopView creatView];
}


- (void)clickOneTwoThreeOrFour:(UIButton *)button{

    if (button.tag == 10) {
        _fiveAction = _action;
    } else if (button.tag == 11) {
        _fiveAction = _twoAction;
    } else if (button.tag == 12) {
        _fiveAction = _threeAction;
    } else if (button.tag == 13) {
        _fiveAction = _fourAction;
    } else {
        _fiveAction = _action;
    }
}

#pragma mark - 分章节目录点击
- (void)catalogTopViewBtnClick{

    _chapterListView = [[ChapterListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chapterListView.dataSource = _blockList;
    _chapterListView.delegate = self;
    [[AppDelegate sharedApplicationDelegate].window addSubview:_chapterListView];
}

#pragma mark - 移除弹出的分目录页面
- (void)removeChapterListView{

    [_chapterListView removeFromSuperview];
}

#pragma mark - 分章节目录点击的位置
- (void)clickParkChapter:(NSInteger)chaperIndex{
    
    [_chapterListView removeFromSuperview];
    
    NSDictionary *firstDict = _blockList[chaperIndex];
    self.catalogTopView.chapterStr = firstDict[@"tips"];
    self.catalogTopView.totalStr = [NSString stringWithFormat:@"%lu",(unsigned long)_chapterIdListArray.count];
    [self.catalogTopView creatView];
    
    NSInteger index = chaperIndex * 50 ;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
    if (message.call == 110) {
                
        if (message.resultCode == 0) {
            
            NSString *isPay = @"";
            NSString *isChargeList = [NSString stringWithFormat:@"%@",message.responseData[@"isChargeList"]];
            NSMutableArray *chargeListArray = [[NSMutableArray alloc] init];
            NSArray *chapterIdListArray = message.responseData[@"chapterIdList"];
            for (int i = 0; i < chapterIdListArray.count; i ++) {
                
                isPay = [isChargeList substringWithRange:NSMakeRange(i,1)];
                [chargeListArray addObject:isPay];
            }
            _chargeListArray = chargeListArray;
            
            [self createCatalogTopView:message.responseData];
            _chapterIdListArray = message.responseData[@"chapterIdList"];
            _chapterNameList = message.responseData[@"chapterNameList"];
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];

            JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
            [DBModel insertCatelogAndParkToDataBase:message.responseData andIsEnd:YES];
        }
        
    } else if (message.call == 197) {

        if (message.resultCode == 0) {
            
            NSString *statusStr = [NSString stringWithFormat:@"%@",message.responseData[@"status"]];
            if ([statusStr isEqualToString:@"3"]) {//余额不足
                
                self.ABModel = [JYS_SqlManager shareManager];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_bookIDCatalog forKey:@"bookID"];
                [dict setObject:@(0) forKey:@"isAutoBuy"];
                
                [self.ABModel amendAutoBuy:dict];
                
            }
            
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
            if (!(remainSum == nil || [remainSum isEqualToString:@""])) {
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            }
            
            self.DBModel = [JYS_SqlManager shareManager];
            if ([_afterNum isEqualToString:@"1"]) {//一章一章购买
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
                [dict setObject:_afterNum forKey:@"afterNum"];
                [dict setObject:_bookIDCatalog forKey:@"bookID"];
                [self.DBModel amendPayRecord:dict];
                
            } else {//多个章节一起购买
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(_myIndex) forKey:@"consumeChapterIndex"];
                [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
                [dict setObject:_afterNum forKey:@"afterNum"];
                [dict setObject:_chapterIdListArray forKey:@"chapterIdListArray"];
                [dict setObject:_bookIDCatalog forKey:@"bookID"];
                [self.DBModel amendPayRecord:dict];
            }
        }
        
    } else if (message.call == 196) {//消费检查接口
        
        [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
  
        if (message.resultCode == 0) {
            
            NSString *status = message.responseData[@"status"];
            if ([status isEqualToString:@"4"]) {
                [self gotoScrollView:_myIndex];
            } else {
                NSString *chapterId = _chapterIdListArray[_myIndex];
                
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookIDCatalog];
                if ([catelog.isPay isEqualToNumber:@1]) {//需要付费
                    [self needPayData:message.responseData];
                } else if (!catelog.isPay){//需要付费
                    [self needPayData:message.responseData];
                }
            }
            
        } else if (message.resultCode == 4) {//不需要弹框扣费
            NSDictionary *dict = nil;
            [self requestConsume197:dict];
            
            [self gotoScrollView:_myIndex];
        }
    }
}


#pragma mark - 批量下载章节内容
- (void)downloadManyCaputerWithArray:(NSArray *)chaputerArray{
    
    NSInteger totalCount = chaputerArray.count;
    int i = 0;
    while (i<totalCount) {
        NSString *chapterId = chaputerArray[i];
        if ([self isChaputerDownWithId:chapterId]) {
            i++;
            continue;
        }
        [self downloadZipWithChaputerId:chapterId];
        i++;
    }
    //171  iOS目前自有不需要走接口可以直接
    //    [self requestBatch171:idStr];
}

- (void)downloadZipWithChaputerId:(NSString *)chaputerId
{//本地数据库没有存过此章节的路径
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[self componentPathWithChaputerId:chaputerId]];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if(!error){
        //保存到应用的caches目录。现在你已经把文件下载到了本地磁盘
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"MyCache"];
        BOOL isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir ]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
        [data writeToFile:zipPath options:0 error:&error];
        //        LRLog(@"data--%@",data);
        
        if(!error){
            
            if ([self.za UnzipOpenFile:zipPath]) {
                //
                BOOL ret = [self.za UnzipFileTo:path overWrite:YES];
                if (NO == ret){} [self.za UnzipCloseFile];
                // 把解压出的内存写入caches目录
                NSString *componentStr = [NSString stringWithFormat:@"%@.txt",chaputerId];//存入的名字
                NSString *textFilePath = [path stringByAppendingPathComponent:componentStr];
                int result= [self haveTextBianMa:[textFilePath UTF8String]];
                CFStringEncoding cfEncode = [self textEncodingTypeWithResult:result];
                NSError *err;
                NSString *contentString=[NSString stringWithContentsOfFile:textFilePath encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&err];
                //                LRLog(@"contentString--%@",contentString);
                if (contentString.length) {//有内容
                    if(!contentString){
                        contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000632 error:nil];
                    }
                    
                    if(!contentString){
                        contentString = [NSString stringWithContentsOfFile:textFilePath encoding:0x80000631 error:nil];
                    }
                    
                    
                    contentString = [self serializationString:contentString];
                    
                    CatelogInforModel *chapter = [[JYS_SqlManager shareManager] getCatelogWithCatelogId:chaputerId andFromBook:_bookIDCatalog];
                    if(chapter == nil)
                    {
                        chapter = [CatelogInforModel new];
                        chapter.entityid = [NSString stringWithFormat:@"%@%@",_bookIDCatalog,chaputerId];
                        chapter.chaterId = chaputerId;
                        chapter.path = textFilePath;
                        [WHC_ModelSqlite insert:chapter];
                        return;
                    }
                    
                    chapter.path = textFilePath;
//                    LRLog(@"chapter--%@",chapter.chapterPath);
                    [WHC_ModelSqlite update:chapter where:[NSString stringWithFormat:@"entityid = %@",chapter.entityid]];
                    
                } else {//没有内容
                    
//                    static dispatch_once_t onceToken;
//                    dispatch_once(&onceToken, ^{
//                        
//                        [self requestStoryContent:chaputerId andIs:NO andIsCache:NO];
//                    });
                }
            }
        }else{
            
        }
    }else{
        
    }
}



//判断章节是否存在
- (BOOL)isChaputerDownWithId:(NSString *)chaputerId
{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    CatelogInforModel *chapter = [dataManager getCatelogWithCatelogId:chaputerId andFromBook:_bookIDCatalog];
    return chapter.path.length>0?YES:NO;
}
//组装章节路径
- (NSString *)componentPathWithChaputerId:(NSString *)chaputerId
{
    NSString *downloadUrl = [NSString stringWithFormat:@"%@bookId=%@&chapterId=%@",ZIP_URL,_bookIDCatalog,chaputerId];
    return downloadUrl;
}

#pragma mark - 编码判断
-(int)haveTextBianMa:(const char*)strTxtPath{
    FILE* file;
    char buf[NUMBER_OF_SAMPLES];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    file = fopen(strTxtPath, "rt");
    if (file==NULL) {
        //        printf("文件打开失败！\n");
        return 1;
    }
    len = fread(buf, sizeof(char), NUMBER_OF_SAMPLES, file);
    fclose(file);
    
    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0)
    {
        //        printf("分析编码失败！\n");
        return -1;
    }
    uchardet_data_end(ud);
    //    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));
    _encode=uchardet_get_charset(ud);
    
    uchardet_delete(ud);
    
    return 0;
}

- (CFStringEncoding)textEncodingTypeWithResult:(int)result{
    CFStringEncoding cfEncode = 0;
    if (result==0) {
        
        NSString *encodeStr=[[NSString alloc] initWithCString:_encode encoding:NSUTF8StringEncoding];
        
        if ([encodeStr isEqualToString:@"gb18030"]) {
            
            cfEncode= kCFStringEncodingGB_18030_2000;
            
        }else if([encodeStr isEqualToString:@"Big5"]){
            
            cfEncode= kCFStringEncodingBig5;
            
        }else if([encodeStr isEqualToString:@"UTF-8"]){
            
            cfEncode= kCFStringEncodingUTF8;
            
        }else if([encodeStr isEqualToString:@"Shift_JIS"]){
            
            cfEncode= kCFStringEncodingShiftJIS;
            
        }else if([encodeStr isEqualToString:@"windows-1252"]){
            
            cfEncode= kCFStringEncodingWindowsLatin1;
            
        }else if([encodeStr isEqualToString:@"x-euc-tw"]){
            
            cfEncode= kCFStringEncodingEUC_TW;
            
        }else if([encodeStr isEqualToString:@"EUC-KR"]){
            
            cfEncode= kCFStringEncodingEUC_KR;
            
        }else if([encodeStr isEqualToString:@"EUC-JP"]){
            
            cfEncode= kCFStringEncodingEUC_JP;
            
        }
        
    }
    return cfEncode;
}

#pragma mark - 字符串替换
- (NSString *)serializationString:(NSString *)contentString{
    while([contentString containsString:@"\n"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
    }
    while([contentString containsString:@"\r\r"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r\r" withString:@"\r"];
    }
    while([contentString containsString:@"    "]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"    " withString:@""];
    }
    while([contentString containsString:@"\r "]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r " withString:@"\r"];
    }
    while([contentString containsString:@"\r　"]){
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\r　" withString:@"\r"];
    }
    
    
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\r" withString:@"\r\n　　"];
    return contentString;
}




- (void)needPayData:(NSDictionary *)dict{

    NSArray *lotsTips = dict[@"lotsTips"];
    
    if (lotsTips.count == 4) {
        
        [self setupFourOrderView:dict];
        
    } else if (lotsTips.count == 3) {
        
        [self setupThreeOrderView:dict];
        
    } else if (lotsTips.count == 2) {
        
        [self setupTwoOrderView:dict];
        
    } else if (lotsTips.count == 1) {
        
        [self setupOneOrderView:dict];
    } else {
        
        NSArray *lotsTips = dict[@"lotsTips"];
        
        NSDictionary *dictNew = lotsTips[0];
        
        [self requestConsume197:dictNew];
    }
}

- (void)setupFourOrderView:(NSDictionary *)dict{
    
    _orderView = [[OrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _orderView.delegate = self;
    [_orderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _orderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _orderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _orderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _orderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _orderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *fourLotTip = lotsTips[3];
    _orderView.fiftyBtn.moneyLabel.text = fourLotTip[@"lotsTips"];
    _orderView.fiftyBtn.bottomLabel.text = fourLotTip[@"discountTips"];
    _orderView.fiftyBtn.titleLab.text = fourLotTip[@"discount"];
    _orderView.fiftyBtn.firstLabel.text = fourLotTip[@"totalPriceTips"];
    _orderView.fiftyBtn.hidden = NO;
    _orderView.fiftyBtn.oneDict = fourLotTip;
    _fourAction = fourLotTip[@"action"];
    
    NSDictionary *threeLotTip = lotsTips[2];
    _orderView.thirtyBtn.moneyLabel.text = threeLotTip[@"lotsTips"];
    _orderView.thirtyBtn.bottomLabel.text = threeLotTip[@"discountTips"];
    _orderView.thirtyBtn.titleLab.text = threeLotTip[@"discount"];
    _orderView.thirtyBtn.firstLabel.text = threeLotTip[@"totalPriceTips"];
    _orderView.thirtyBtn.hidden = NO;
    _orderView.thirtyBtn.oneDict = threeLotTip;
    _threeAction = threeLotTip[@"action"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    _orderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _orderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _orderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _orderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _orderView.tenBtn.hidden = NO;
    _orderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _orderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _orderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _orderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _orderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _orderView.fiveBtn.oneDict = oneLotTip;
    _orderView.orderDict = oneLotTip;
    _orderView.fiveBtn.hidden = NO;
    _action = oneLotTip[@"action"];
    _fiveAction = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookIDCatalog];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupThreeOrderView:(NSDictionary *)dict{
    
    _newthreeOrderView = [[NewThreeOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _newthreeOrderView.delegate = self;
    [_newthreeOrderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _newthreeOrderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _newthreeOrderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _newthreeOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _newthreeOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _newthreeOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *threeLotTip = lotsTips[2];
    _newthreeOrderView.thirtyBtn.moneyLabel.text = threeLotTip[@"lotsTips"];
    _newthreeOrderView.thirtyBtn.bottomLabel.text = threeLotTip[@"discountTips"];
    _newthreeOrderView.thirtyBtn.titleLab.text = threeLotTip[@"discount"];
    _newthreeOrderView.thirtyBtn.firstLabel.text = threeLotTip[@"totalPriceTips"];
    _newthreeOrderView.thirtyBtn.hidden = NO;
    _newthreeOrderView.thirtyBtn.oneDict = threeLotTip;
    _threeAction = threeLotTip[@"action"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    _newthreeOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
    _newthreeOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
    _newthreeOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
    _newthreeOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
    _newthreeOrderView.tenBtn.hidden = NO;
    _newthreeOrderView.tenBtn.oneDict = twoLotTip;
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _newthreeOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _newthreeOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _newthreeOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _newthreeOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _newthreeOrderView.fiveBtn.oneDict = oneLotTip;
    _newthreeOrderView.orderDict = oneLotTip;
    _newthreeOrderView.fiveBtn.hidden = NO;
    _action = oneLotTip[@"action"];
    _fiveAction = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookIDCatalog];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupTwoOrderView:(NSDictionary *)dict{
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *twoLotTip = lotsTips[1];
    
    _newtwoOrderView = [[NewTwoOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 400, ScreenWidth, 400)];
    _newtwoOrderView.delegate = self;
    
    NSInteger afterNum = [twoLotTip[@"afterNum"] integerValue];
    if (afterNum < 10) {
        _newtwoOrderView.istenChapter = YES;
    }
    [_newtwoOrderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _newtwoOrderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _newtwoOrderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _newtwoOrderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _newtwoOrderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];;
    }
    
    _newtwoOrderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    if (afterNum < 10) {
        _newtwoOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
        _newtwoOrderView.tenBtn.bottomLabel.text = twoLotTip[@"totalPriceTips"];
        _newtwoOrderView.tenBtn.hidden = NO;
        _newtwoOrderView.tenBtn.isFirstBtn = YES;
        _newtwoOrderView.tenBtn.oneDict = twoLotTip;
    } else {
        _newtwoOrderView.tenBtn.moneyLabel.text = twoLotTip[@"lotsTips"];
        _newtwoOrderView.tenBtn.bottomLabel.text = twoLotTip[@"discountTips"];
        _newtwoOrderView.tenBtn.titleLab.text = twoLotTip[@"discount"];
        _newtwoOrderView.tenBtn.firstLabel.text = twoLotTip[@"totalPriceTips"];
        _newtwoOrderView.tenBtn.hidden = NO;
        _newtwoOrderView.tenBtn.oneDict = twoLotTip;
    }
    _twoAction = twoLotTip[@"action"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _newtwoOrderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _newtwoOrderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _newtwoOrderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _newtwoOrderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _newtwoOrderView.fiveBtn.oneDict = oneLotTip;
    _newtwoOrderView.orderDict = oneLotTip;
    _newtwoOrderView.fiveBtn.hidden = NO;
    _action = oneLotTip[@"action"];
    _fiveAction = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookIDCatalog];
    
    _chapterName = dict[@"chapterName"];
}

- (void)setupOneOrderView:(NSDictionary *)dict{
    
    _neworderView = [[NewOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 340, ScreenWidth, 340)];
    
    _neworderView.delegate = self;
    [_neworderView creatView];
    
    NSString *chapterNameStr = dict[@"chapterName"];
    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];
    if (chapterNameStr.length) {
        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
        if (isNightView) {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
        } else {
            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
        }
        
        _neworderView.chaperNameLab.attributedText = oneLabelStrs;
    } else {
        _orderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",dict[@"chapterName"]];;
    }
    
    
    
    NSString *chapterUnitStr = dict[@"chapterUnit"];
    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    _priceStr = [NSString stringWithFormat:@"%@",dict[@"price"]];
    _priceUnit = [NSString stringWithFormat:@"%@",dict[@"chapterUnit"]];
    if (priceLabelStr.length > 3) {
        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
        if (isNightView) {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        } else {
            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
        }
        
        _neworderView.priceLabel.attributedText = priceLabelStrs;
    } else {
        _neworderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",dict[@"price"],dict[@"priceUnit"],dict[@"chapterUnit"]];
    }
    
    _neworderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",dict[@"remainSum"],dict[@"priceUnit"]];
    
    NSArray *lotsTips = dict[@"lotsTips"];
    
    NSDictionary *oneLotTip = lotsTips[0];
    _neworderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
    _neworderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
    _neworderView.remarkLabel.text = oneLotTip[@"actionTips"];
    _neworderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
    _neworderView.fiveBtn.oneDict = oneLotTip;
    _neworderView.orderDict = oneLotTip;
    
    _action = oneLotTip[@"action"];
    _fiveAction = oneLotTip[@"action"];
    
    [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookIDCatalog];
    
}



#pragma mark - TableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _chapterNameList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
    
    cell.titleLabel.text = _chapterNameList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *chapterId = _chapterIdListArray[indexPath.row];
    _consumeChapterID = chapterId;
    _myIndex = indexPath.row;
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    
    CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookIDCatalog];
    BookInforModel *book = [dataManager getBookWithBookId:_bookIDCatalog];
    
    if ([book.marketStatus isEqualToNumber:@(3)]) {//限免
        [self gotoScrollView:indexPath.row];
    } else {//非限免
        if ([catelog.isPay isEqualToNumber:@1]) {//需要付费
            
            if ([book.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
                NSDictionary *dict = nil;
                [self requestConsume197:dict];
                
                [self gotoScrollView:indexPath.row];
                
            } else {//需要弹框确认购买
                //支付检查
                [self requestPayCheck196:chapterId];
            }
            
        } else if (!catelog.isPay) {
            NSString *isChapter = _chargeListArray[indexPath.row];
            if ([isChapter isEqualToString:@"1"]) {//需要付费
                //支付检查
                [self requestPayCheck196:chapterId];
            } else {
                [self gotoScrollView:indexPath.row];
            }
        } else {//不需付费
            [self gotoScrollView:indexPath.row];
        }
    }
}

#pragma mark - 进入阅读器页面
- (void)gotoScrollView:(NSInteger)index{

    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = _bookIDCatalog;
    readVC.haveBookRack = _haveBookRack;
    readVC.allChapterOne = _chapterIdListArray[index];
    readVC.bookName = _bookName;
    readVC.allChapterIndex = index;
    readVC.bookIcon = _bookIcon;
    readVC.author = _author;
    readVC.introude = _introuce;
    readVC.totalChapter = _chapterNameList.count;
    readVC.totalTitlArray = _chapterNameList;
    readVC.chapterIdListArray = _chapterIdListArray;
    readVC.lastChapterCount = _chapterIdListArray.count;
    readVC.lastChapterID = [NSString stringWithFormat:@"%@",_chapterIdListArray[_chapterIdListArray.count - 1]];
    [self presentViewController:readVC animated:YES completion:nil];
}

#pragma mark - 支付检查
- (void)requestPayCheck196:(NSString *)chapterID{
    
    [[AppDelegate sharedApplicationDelegate].window showLoadingView];
    
    NSString *lastChapterId = _chapterIdListArray.lastObject;
    
    self.payCheckmodel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookIDCatalog;
    requestData[@"baseChapterId"] = chapterID;
    requestData[@"readAction"] = @"3";
    requestData[@"lastChapterId"] = lastChapterId;
    [self.payCheckmodel registerAccountAndCall:196 andRequestData:requestData];
}

#pragma mark - NewTwoOrderView自动订购下一章
- (void)newTwoOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}


#pragma mark - NewTwoOrderView确认购买
- (void)newTwoOrderViewEnsureBtnClick:(EnsureButton *)button{
    
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        rechargeVC.chapterName = _chapterName;
        rechargeVC.bookName = _bookName;
        rechargeVC.priceStr = _priceStr;
        rechargeVC.priceUnit = _priceUnit;
        rechargeVC.isRechare = YES;
        [self presentViewController:rechargeVC animated:YES completion:nil];

    } else {//余额充足
        [self requestConsume197:button.ensureDict];

        [self gotoScrollView:_myIndex];

        if (_isAutoBuy) {
            self.ABModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_bookIDCatalog forKey:@"bookID"];
            [dict setObject:@(1) forKey:@"isAutoBuy"];

            [self.ABModel amendAutoBuy:dict];
        }
    }
}

#pragma mark - NewThreeOrderView自动订购下一章
- (void)newThreeOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}



#pragma mark - NewThreeOrderView确认购买
- (void)newThreeOrderViewEnsureBtnClick:(EnsureButton *)button{
    
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        rechargeVC.chapterName = _chapterName;
        rechargeVC.bookName = _bookName;
        rechargeVC.priceStr = @"";
        rechargeVC.isRechare = YES;
        [self presentViewController:rechargeVC animated:YES completion:nil];
        
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        [self gotoScrollView:_myIndex];
        
        if (_isAutoBuy) {
            self.ABModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_bookIDCatalog forKey:@"bookID"];
            [dict setObject:@(1) forKey:@"isAutoBuy"];
            
            [self.ABModel amendAutoBuy:dict];
        }
    }
}

#pragma mark - NewOrderView自动订购下一章
- (void)newOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}



#pragma mark - NewOrderView确认购买
- (void)newOrderViewEnsureBtnClick:(EnsureButton *)button{
    
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        rechargeVC.chapterName = _chapterName;
        rechargeVC.bookName = _bookName;
        rechargeVC.priceStr = @"";
        rechargeVC.isRechare = YES;
        [self presentViewController:rechargeVC animated:YES completion:nil];
        
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        [self gotoScrollView:_myIndex];
        
        if (_isAutoBuy) {
            self.ABModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_bookIDCatalog forKey:@"bookID"];
            [dict setObject:@(1) forKey:@"isAutoBuy"];
            
            [self.ABModel amendAutoBuy:dict];
        }
    }
}

#pragma mark - 自动订购下一章
- (void)autoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}




#pragma mark - 确认购买
- (void)ensureBtnClick:(EnsureButton *)button{
    
    if ([_fiveAction isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        rechargeVC.chapterName = _chapterName;
        rechargeVC.bookName = _bookName;
        rechargeVC.priceStr = @"";
        rechargeVC.isRechare = YES;
        [self presentViewController:rechargeVC animated:YES completion:nil];
        
    } else {//余额充足
        [self requestConsume197:button.ensureDict];
        
        [self gotoScrollView:_myIndex];
        
        if (_isAutoBuy) {
            self.ABModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_bookIDCatalog forKey:@"bookID"];
            [dict setObject:@(1) forKey:@"isAutoBuy"];
            
            [self.ABModel amendAutoBuy:dict];
        }
    }
}




#pragma mark - 消费（扣费）接口
- (void)requestConsume197:(NSDictionary *)dict{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSMutableDictionary *dicta = [[NSMutableDictionary alloc] init];
    [dicta setObject:_bookIDCatalog forKey:@"bookId"];
    [dicta setObject:_bookIcon forKey:@"coverWap"];
    [dicta setObject:_author forKey:@"author"];
    [dicta setObject:_introuce forKey:@"introduction"];
    [dicta setObject:_bookName forKey:@"bookName"];
    
    NSString *chapterID = _chapterIdListArray[_myIndex];
    NSMutableDictionary *chapterListDict = [[NSMutableDictionary alloc] init];
    [chapterListDict setObject:chapterID forKey:@"chapterId"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:chapterListDict];
    
    NSString *lastChapterID = _chapterIdListArray[_chapterIdListArray.count - 1];
    
    NSMutableDictionary *lastChapter = [[NSMutableDictionary alloc] init];
    [lastChapter setObject:lastChapterID forKey:@"chapterId"];
    
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    [mutableDict setObject:dateString forKey:@"dateTime"];
    [mutableDict setObject:dicta forKey:@"book"];
    [mutableDict setObject:array forKey:@"chapterList"];
    [mutableDict setObject:lastChapter forKey:@"lastChapterInfo"];
    
    JYS_SqlManager *DBModel = [JYS_SqlManager shareManager];
    [DBModel insertData:mutableDict];
    _haveBookRack = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLogo" object:self];
    
    NSString *totalPrice = nil;
    NSString *discountPrice = nil;
    NSString *discountRate = nil;
    if (dict.count) {
        totalPrice = [NSString stringWithFormat:@"%@",dict[@"totalPrice"]];
        _afterNum = [NSString stringWithFormat:@"%@",dict[@"afterNum"]];
        discountPrice = [NSString stringWithFormat:@"%@",dict[@"discountPrice"]];
        discountRate = dict[@"discountRate"];
    } else {
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
        BookInforModel *book = [dataManager getBookWithBookId:_bookIDCatalog];
        discountPrice = book.price;
        _afterNum = @"1";
        totalPrice = book.sourceFrom;
        discountRate = book.marketId;
    }
    
    NSString *lastChapterId = _chapterIdListArray.lastObject;
    
    self.consumeModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"bookId"] = _bookIDCatalog;
    requestData[@"totalPrice"] = totalPrice;
    requestData[@"afterNum"] = _afterNum;
    if (![_afterNum isEqualToString:@"1"]) {
        requestData[@"discountRate"] = discountRate;
    }
    requestData[@"discountPrice"] = discountPrice;
    requestData[@"baseChapterId"] = _consumeChapterID;
    requestData[@"position"] = @"0";
    requestData[@"readAction"] = @"1";
    requestData[@"lastChapterId"] = lastChapterId;
    requestData[@"marketStatus"] = @"";
    [self.consumeModel registerAccountAndCall:197 andRequestData:requestData];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
