//
//  BookDetailController.m
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "BookDetailController.h"
#import "BackGroundView.h"
#import "LaunchViewCell.h"
#import "CatalogView.h"
#import "CatelogViewCell.h"
#import "CommentFirstViewCell.h"
#import "CommentModel.h"
#import "CommentViewCell.h"
#import "CommentAndCatelogCell.h"
#import "SimilarBookViewCell.h"
#import "SimilarBookModel.h"
#import "MoreBookInfoCell.h"
#import "CommentViewController.h"
#import "CatalogViewController.h"
#import "E_ScrollViewController.h"
#import "AllLookCell.h"
#import "E_ScrollViewController.h"
#import "NewOrderView.h"
#import "RechargeController.h"
#import "WXShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface BookDetailController ()<UITableViewDataSource, UITableViewDelegate,BackGroundViewDelegate,AllLookCellDelegate,NewOrderViewDelegate,WXShareViewDelegate>

@property (nonatomic, strong) NetworkModel *networkModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BackGroundView *backGroundView;
@property (nonatomic, strong) LaunchViewModel *model;
@property (nonatomic, strong) CatalogView *catalogView;
@property (nonatomic, strong) NSArray *chapterList;
@property (nonatomic, strong) NSArray *commentModelArray;
@property (nonatomic, strong) NSMutableArray *similarModelArray;
@property (nonatomic, strong) NSArray *simliarModelThree;
@property (nonatomic, strong) NSArray *userOtherModel;
@property (nonatomic, assign) NSInteger indexInt;
@property (nonatomic, strong) JYS_SqlManager *DBModel;
@property (nonatomic, strong) NSMutableDictionary *bookRackDict;
@property (nonatomic, strong) NSDictionary *bookDict;
@property (nonatomic, strong) NetworkModel *consumeModel;
@property (nonatomic, strong) NetworkModel *payCheckmodel;
@property (nonatomic, strong) NSString *consumeChapterID;
@property (nonatomic, strong) NSString *consumeChapterName;
@property (nonatomic, strong) NewOrderView *orderView;
@property (nonatomic, strong) JYS_SqlManager *ABModel;
@property (nonatomic, strong) NSNumber *action;
@property (nonatomic, assign) BOOL isAutoBuy;
@property (nonatomic, assign) BOOL isStartRead;
@property (nonatomic, assign) BOOL isFirstThree;
@property (nonatomic, assign) NSInteger firstThree;
@property (nonatomic, strong) NSString *chapterUnit;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *priceUnit;

@property (nonatomic, strong) NSArray *totalTitlArray;//设置总章节的标题
@property (nonatomic, strong) NSArray *chapterIdListArray;//设置章节列表数组
@property (nonatomic, strong) NSDictionary *myDict;
@property (nonatomic, strong) WXShareView *shareView;


@end

@implementation BookDetailController

- (CatalogView *)catalogView{

    if (_catalogView == nil) {
        _catalogView = [[CatalogView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 88)];
    }
    return _catalogView;
}

- (BackGroundView *)backGroundView{

    if (_backGroundView == nil) {
        _backGroundView = [[BackGroundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        _backGroundView.delegate = self;
    }
    return _backGroundView;
}

- (void)viewWillDisappear:(BOOL)animated{
        
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _isAutoBuy = YES;
    
    [self.view addSubview:self.backGroundView];
    
    self.view.backgroundColor = WhiteColor;
    
//    self.navigationController.navigationBar.hidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self requestSearchHotWord157];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogo) name:@"changeLogo" object:nil];
    
    _indexInt = 0;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self ;
    _tableView.delegate = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(210.f, 0.f, 0.f, 0.f));
    }];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BackGroundcell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"catelogCell"];
}

#pragma mark - 修改是否加入书架状态
- (void)changeLogo{
    
    self.backGroundView.rackBtn.enabled = NO;
    [self.backGroundView.rackBtn setBackgroundImage:[UIImage imageNamed:@"Book-details_btn_d"] forState:UIControlStateNormal];
    [self.backGroundView.rackBtn setTitle:@"已添加" forState:UIControlStateNormal];
    [self.backGroundView.rackBtn.layer setBorderWidth:0];
    
}

#pragma mark - 请求获取书籍详情页
- (void)requestSearchHotWord157{
    
    [[AppDelegate sharedApplicationDelegate].window showLoadingView];

    self.networkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookID;
    requestData[@"defbook"] = @"1";

    [self.networkModel registerAccountAndCall:157 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
 
    if (message.call == 157) {
        if (message.resultCode == 0) {//resultCode==0 成功

            self.bookRackDict = message.responseData;
//            NSLog(@"bookDetail-----%@",message.responseData);
            
            if ([message.responseData isKindOfClass:[NSString class]]) {
                if (_sourceFrom.length) {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setValue:_sourceFrom forKey:@"source"];
                    [dict setValue:[NSString stringWithFormat:@"%@+%@",_sourceFrom,_bookID] forKey:@"path"];
                    [MobClick event:@"BookClick" attributes:dict];
                }
                [SVProgressHUD showErrorWithStatus:@"加载失败，请您重试"];
            } else {
                 JYS_SqlManager*bookModel = [JYS_SqlManager shareManager];
                [bookModel updateBookIsFree:message.responseData[@"book"]];
                if (_sourceFrom.length) {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setValue:_sourceFrom forKey:@"source"];
                    NSString *bookName = message.responseData[@"book"][@"bookName"];
                    if (bookName.length) {
                        [dict setValue:[NSString stringWithFormat:@"%@+%@+%@",_sourceFrom,_bookID,bookName] forKey:@"path"];
                    }else{
                        [dict setValue:[NSString stringWithFormat:@"%@+%@",_sourceFrom,_bookID] forKey:@"path"];
                    }
                    [MobClick event:@"BookClick" attributes:dict];
                }

                //初始化BackGroundView数据
                if ([message.responseData isKindOfClass:[NSDictionary class]]) {
                    [self setupBackGroundData:message.responseData];
                    
                    //初始化CatelogView数据
                    [self setupCatelogViewData:message.responseData[@"chapterList"]];
                }
            }
        }
        [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
        
    } else if (message.call == 197) {
    
        if (message.resultCode == 0) {
            
            NSString *remainSum = [NSString stringWithFormat:@"%@",message.responseData[@"remainSum"]];
            if (!(remainSum == nil || [remainSum isEqualToString:@""])) {
                [YFKeychainTool saveKeychainValue:remainSum key:BundleIDRemainSum];
            }
            
            self.DBModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
            [dict setObject:@"1" forKey:@"afterNum"];
            [dict setObject:_bookID forKey:@"bookID"];
            [dict setObject:_consumeChapterName forKey:@"chapterName"];
            [self.DBModel amendPayRecordBookDedail:dict];
            
            JYS_SqlManager *Model = [JYS_SqlManager shareManager];
            [Model insertCatelogToDataBase:_myDict andIsEnd:YES];
            
        }
    } else if (message.call == 196) {
        
        [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];
        
        if (message.resultCode == 0) {
            
            
            NSString *statusStr = [NSString stringWithFormat:@"%@",message.responseData[@"status"]];
            if ([statusStr isEqualToString:@"4"]) {
                
                [self gotoScroolView];
                self.DBModel = [JYS_SqlManager shareManager];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_consumeChapterID forKey:@"consumeChapterID"];
                [dict setObject:@"1" forKey:@"afterNum"];
                [dict setObject:_bookID forKey:@"bookID"];
                [self.DBModel amendPayRecord:dict];

            } else {
                _chapterUnit = message.responseData[@"chapterUnit"];
                
                NSArray *lotsTips = message.responseData[@"lotsTips"];
                if (lotsTips.count) {//需要确认购买框
                    
                    _orderView = [[NewOrderView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 340, ScreenWidth, 340)];
                    
                    _orderView.delegate = self;
                    [_orderView creatView];
                    
                    NSString *chapterNameStr = message.responseData[@"chapterName"];
                    NSString *oneLabelStr = [NSString stringWithFormat:@"章节：%@",message.responseData[@"chapterName"]];
                    if (chapterNameStr.length) {
                        NSMutableAttributedString *oneLabelStrs = [[NSMutableAttributedString alloc] initWithString:oneLabelStr];
                        if (isNightView) {
                            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, chapterNameStr.length)];
                        } else {
                            [oneLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, chapterNameStr.length)];
                        }
                        
                        _orderView.chaperNameLab.attributedText = oneLabelStrs;
                    } else {
                        _orderView.chaperNameLab.text = [NSString stringWithFormat:@"章节：%@",message.responseData[@"chapterName"]];;
                    }
                    
                    
                    NSString *chapterUnitStr = message.responseData[@"chapterUnit"];
                    NSString *priceLabelStr = [NSString stringWithFormat:@"价格：%@%@/%@",message.responseData[@"price"],message.responseData[@"priceUnit"],message.responseData[@"chapterUnit"]];
                    _priceStr = [NSString stringWithFormat:@"%@",message.responseData[@"price"]];
                    _priceUnit = [NSString stringWithFormat:@"%@",message.responseData[@"chapterUnit"]];
                    if (priceLabelStr.length > 3) {
                        NSMutableAttributedString *priceLabelStrs = [[NSMutableAttributedString alloc] initWithString:priceLabelStr];
                        if (isNightView) {
                            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(113, 71, 32) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
                        } else {
                            [priceLabelStrs addAttribute:NSForegroundColorAttributeName value:ADColor(228, 143, 57) range:NSMakeRange(3, priceLabelStr.length - 4 - chapterUnitStr.length)];
                        }
                        
                        _orderView.priceLabel.attributedText = priceLabelStrs;
                    } else {
                        _orderView.priceLabel.text = [NSString stringWithFormat:@"价格：%@%@/%@",message.responseData[@"price"],message.responseData[@"priceUnit"],message.responseData[@"chapterUnit"]];
                    }
                    
                    _orderView.balanceLabel.text = [NSString stringWithFormat:@"(余额：%@%@)",message.responseData[@"remainSum"],message.responseData[@"priceUnit"]];
                    
                    if (lotsTips.count > 0) {
                        
                        NSDictionary *oneLotTip = lotsTips[0];
                        _orderView.fiveBtn.moneyLabel.text = oneLotTip[@"lotsTips"];
                        _orderView.fiveBtn.bottomLabel.text = oneLotTip[@"totalPriceTips"];
                        _orderView.remarkLabel.text = oneLotTip[@"actionTips"];
                        _orderView.allLabel.text = [NSString stringWithFormat:@"合计：%@",oneLotTip[@"totalPriceTips"]];
                        _orderView.fiveBtn.oneDict = oneLotTip;
                        _orderView.orderDict = oneLotTip;
                        _action = oneLotTip[@"action"];
                        [self.ABModel bookChapterPrice:oneLotTip AndbookID:_bookID];
                    }
                }
            }
        }
    } else if (message.call == 110) {
        
        [[AppDelegate sharedApplicationDelegate].window hideLoadingImmediately];

        if (message.resultCode == 0) {
            
            //目录列表
            NSArray *chapterIdList = message.responseData[@"chapterIdList"];
            _chapterIdListArray = chapterIdList;
            
            //目录列表名
            NSArray *chapterNameList = message.responseData[@"chapterNameList"];
            _totalTitlArray = chapterNameList;
   
            
            if (_isStartRead) {
                
                NSArray *chapterIdListArray = message.responseData[@"chapterIdList"];
                NSString *isChargeList = [NSString stringWithFormat:@"%@",message.responseData[@"isChargeList"]];
                NSString *isPay = [isChargeList substringWithRange:NSMakeRange(chapterIdListArray.count - 1,1)];
                
                NSDictionary *lastChapterInfo = _bookDict[@"lastChapterInfo"];
            
                if (lastChapterInfo.count) {
            
                    NSString *chapterId = lastChapterInfo[@"chapterId"];
                    _consumeChapterID = chapterId;
                    _consumeChapterName = lastChapterInfo[@"chapterName"];
            
                    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];

                    BookInforModel *book = [dataManager getBookWithBookId:_bookID];
                    
                    if ([book.marketStatus isEqualToNumber:@(3)]) {//限免
                        [self gotoScrollview:chapterIdList and:chapterNameList];
                    } else {//不限免
                        if ([isPay isEqualToString:@"1"]) {//需要付费
                            if (book == nil || ![book.confirmStatus isEqualToNumber:@(0)] || (book.confirmStatus == nil)) {//不需要弹框
                                [self requestConsume197:chapterId];
                                
                                [self gotoScrollview:chapterIdList and:chapterNameList];
                                
                                if (_isAutoBuy) {
                                    self.ABModel = [JYS_SqlManager shareManager];
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                    [dict setObject:_bookID forKey:@"bookID"];
                                    [dict setObject:@(1) forKey:@"isAutoBuy"];
                                    [self.ABModel amendAutoBuy:dict];
                                }
                                
                                
                            } else {//需要弹框确认购买
                                _myDict = message.responseData;
                                
                                //支付检查
                                [self requestPayCheck196:chapterId];
                            }
                            
                        } else {//不需付费
                            
                            [self gotoScrollview:chapterIdList and:chapterNameList];
                            if (_isAutoBuy) {
                                self.ABModel = [JYS_SqlManager shareManager];
                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                [dict setObject:_bookID forKey:@"bookID"];
                                [dict setObject:@(1) forKey:@"isAutoBuy"];
                                
                                [self.ABModel amendAutoBuy:dict];
                            }
                        }
                    }
                }
                
            } else {
               
                if (_isFirstThree) {
                    NSDictionary *bookDict = _bookDict[@"book"];
                    NSString *bookName = bookDict[@"bookName"];
                    NSString *coverWap = bookDict[@"coverWap"];
                    NSString *author = bookDict[@"author"];
                    NSString *introduction = bookDict[@"introduction"];
                    
                    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
                    readVC.bookID = _bookID;
                    readVC.allChapterOne = chapterIdList[_firstThree];
                    readVC.bookName = bookName;
                    readVC.allChapterIndex =_firstThree;
                    readVC.bookIcon = coverWap;
                    readVC.author = author;
                    readVC.introude = introduction;
                    readVC.totalChapter =chapterIdList.count;
                    readVC.totalTitlArray = chapterNameList;
                    readVC.chapterIdListArray = chapterIdList;
                    readVC.lastChapterCount = [bookDict[@"totalChapterNum"] integerValue];
                    NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
                    readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
                    [self presentViewController:readVC animated:YES completion:nil];
                } else {
                    NSDictionary *dict = _bookDict[@"book"];
                    NSArray *array = _bookDict[@"chapterList"];
                    NSDictionary *chapterListDict = nil;
                    if (array.count) {
                        chapterListDict = array[0];
                    }
                    
                    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
                    readVC.bookID = _bookID;
                    readVC.chapterID = chapterListDict[@"chapterId"];
                    readVC.bookName = dict[@"bookName"];
                    readVC.bookIcon = dict[@"coverWap"];
                    readVC.author = dict[@"author"];
                    readVC.introude = dict[@"introduction"];
                    readVC.totalChapter = chapterIdList.count;
                    readVC.totalTitlArray = chapterNameList;
                    readVC.chapterIdListArray = chapterIdList;
                    readVC.lastChapterCount = [dict[@"totalChapterNum"] integerValue];
                    NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
                    readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
                    [self presentViewController:readVC animated:YES completion:nil];
                }
            }
        }
    }
}

- (void)gotoScrollview:(NSArray *)chapterIdList and:(NSArray *)chapterNameList{

    NSDictionary *bookDict = _bookDict[@"book"];
    NSString *bookName = bookDict[@"bookName"];
    NSString *coverWap = bookDict[@"coverWap"];
    NSString *author = bookDict[@"author"];
    NSString *introduction = bookDict[@"introduction"];
    
    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = _bookID;
    readVC.allChapterOne = _consumeChapterID;
    readVC.bookName = bookName;
    readVC.allChapterIndex =(chapterIdList.count - 1);
    readVC.bookIcon = coverWap;
    readVC.author = author;
    readVC.introude = introduction;
    readVC.totalChapter =chapterIdList.count;
    readVC.totalTitlArray = chapterNameList;
    readVC.chapterIdListArray = chapterIdList;
    readVC.lastChapterCount = [bookDict[@"totalChapterNum"] integerValue];
    NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
    readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
    [self presentViewController:readVC animated:YES completion:nil];
}

//跳转到阅读页
- (void)gotoScroolView{

    NSDictionary *bookDict = _bookDict[@"book"];
    NSString *bookName = bookDict[@"bookName"];
    NSString *coverWap = bookDict[@"coverWap"];
    NSString *author = bookDict[@"author"];
    NSString *introduction = bookDict[@"introduction"];
    
    E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
    readVC.bookID = _bookID;
    readVC.allChapterOne = _consumeChapterID;
    readVC.bookName = bookName;
    readVC.allChapterIndex =(_chapterIdListArray.count - 1);
    readVC.bookIcon = coverWap;
    readVC.author = author;
    readVC.introude = introduction;
    readVC.totalChapter =_chapterIdListArray.count;
    readVC.totalTitlArray = _totalTitlArray;
    readVC.chapterIdListArray = _chapterIdListArray;
    readVC.lastChapterCount = [bookDict[@"totalChapterNum"] integerValue];
    NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
    readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
    [self presentViewController:readVC animated:YES completion:nil];
    
}



#pragma mark - 自动订购下一章
- (void)newOrderViewAutoBuyBtnClick:(UIButton *)button{
    
    if (button.tag == 10) {
        _isAutoBuy = YES;
    } else {
        _isAutoBuy = NO;
    }
}

#pragma mark - 确认购买
- (void)newOrderViewEnsureBtnClick:(UIButton *)button{
    
    NSDictionary *bookDict = _bookDict[@"book"];
    NSString *bookName = bookDict[@"bookName"];
    
    if ([_action isEqualToNumber:@(3)]) {//余额不足，跳转充值页面
        RechargeController *rechargeVC = [[RechargeController alloc] init];
        rechargeVC.chapterName = _bookDict[@"lastChapterInfo"][@"chapterName"];
        rechargeVC.bookName = bookName;
        rechargeVC.priceStr = _priceStr;
        rechargeVC.priceUnit = _priceUnit;
        rechargeVC.isRechare = YES;
        [self presentViewController:rechargeVC animated:YES completion:nil];
        
    } else {//余额充足
        [self requestConsume197:_consumeChapterID];
        
        [self gotoScroolView];
        
        if (_isAutoBuy) {
            self.ABModel = [JYS_SqlManager shareManager];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_bookID forKey:@"bookID"];
            [dict setObject:@(1) forKey:@"isAutoBuy"];
            
            [self.ABModel amendAutoBuy:dict];
        }
    }
}

- (void)requestStoryMuenCall110NewChapter{

    [[AppDelegate sharedApplicationDelegate].window showLoadingView];
    
    
    NetworkModel *newChapterModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"v"] = @"2";
    requestData[@"chapterStatus"] = @"9999";
    requestData[@"defbook"] = @"1";
    requestData[@"payWay"] = @"2";
    requestData[@"bookId"] = _bookID;
    requestData[@"chapterEndId"] = @"";
    requestData[@"marketId"] = @"";
    requestData[@"needBlockList"] = @"";
    [newChapterModel registerAccountAndCall:110 andRequestData:requestData];
}


#pragma mark - 请求小说的目录
- (void)requestStoryMuenCall110:(BOOL)isEnd{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    NSArray *cateloArray = [dataManager getAllCatelogFromBook:_bookID];
        if (!cateloArray.count) {//没有数据缓存过本地数据库
        
        [[AppDelegate sharedApplicationDelegate].window showLoadingView];
        
        self.networkModel = [[NetworkModel alloc] initWithResponder:self];
        NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
        requestData[@"v"] = @"2";
        if (isEnd) {
           requestData[@"chapterStatus"] = @"9999";
        } else {
            requestData[@"chapterStatus"] = @"20";
        }
        
        requestData[@"defbook"] = @"1";
        requestData[@"payWay"] = @"2";
        requestData[@"bookId"] = _bookID;
        requestData[@"chapterEndId"] = @"";
        requestData[@"marketId"] = @"";
        requestData[@"needBlockList"] = @"";
           
        [self.networkModel registerAccountAndCall:110 andRequestData:requestData];

    } else {
        
        //存放的是Catelog类型
        JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
        NSArray *chapterType = [dataManager getAllCatelogFromBook:_bookID];
        
               
        //存放的是catelogID数组
        NSMutableArray *chapterIdList = [[NSMutableArray alloc] init];
        
        _chapterIdListArray = chapterIdList;
        
        //目录列表名
        NSMutableArray *chapterNameList = [[NSMutableArray alloc] init];
        _totalTitlArray = chapterNameList;
        
        for (int i = 0; i < chapterType.count; i ++) {
            CatelogInforModel *catelog = chapterType[i];
            
            [chapterIdList addObject:catelog.chaterId];
            [chapterNameList addObject:catelog.catelogName];
        }
        
        if (_isStartRead) {
            
            NSDictionary *lastChapterInfo = _bookDict[@"lastChapterInfo"];
            
            if (lastChapterInfo.count) {
                
                NSString *chapterId = lastChapterInfo[@"chapterId"];
                _consumeChapterID = chapterId;
                
                JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
                
                CatelogInforModel *catelog = [dataManager getCatelogWithCatelogId:chapterId andFromBook:_bookID];
                BookInforModel *book = [dataManager getBookWithBookId:_bookID];
                
                if ([book.marketStatus isEqualToNumber:@(3)]) {//限免
                    [self gotoScrollview:chapterIdList and:chapterNameList];
                } else {//非限免
                    if (catelog.isPay.integerValue == 1) {//需要付费
                        
                        if ([book.confirmStatus isEqualToNumber:@(1)]) {//不需要弹框
                            [self requestConsume197:chapterId];
                            
                            [self gotoScrollview:chapterIdList and:chapterNameList];
                            
                            if (_isAutoBuy) {
                                self.ABModel = [JYS_SqlManager shareManager];
                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                [dict setObject:_bookID forKey:@"bookID"];
                                [dict setObject:@(1) forKey:@"isAutoBuy"];
                                
                                [self.ABModel amendAutoBuy:dict];
                            }
                            
                        } else {//需要弹框确认购买
                            //支付检查
                            [self requestPayCheck196:chapterId];
                        }
                        
                    } else {//不需付费
                        
                        [self gotoScrollview:chapterIdList and:chapterNameList];
                        
                        if (_isAutoBuy) {
                            self.ABModel = [JYS_SqlManager shareManager];
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            [dict setObject:_bookID forKey:@"bookID"];
                            [dict setObject:@(1) forKey:@"isAutoBuy"];
                            
                            [self.ABModel amendAutoBuy:dict];
                        }
                    }
                }
            }
        } else {
            if (_isFirstThree) {
                NSDictionary *bookDict = _bookDict[@"book"];
                NSString *bookName = bookDict[@"bookName"];
                NSString *coverWap = bookDict[@"coverWap"];
                NSString *author = bookDict[@"author"];
                NSString *introduction = bookDict[@"introduction"];
                
                E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
                readVC.bookID = _bookID;
                readVC.allChapterOne = chapterIdList[_firstThree];
                readVC.bookName = bookName;
                readVC.allChapterIndex =_firstThree;
                readVC.bookIcon = coverWap;
                readVC.author = author;
                readVC.introude = introduction;
                readVC.totalChapter =chapterIdList.count;
                readVC.totalTitlArray = chapterNameList;
                readVC.chapterIdListArray = chapterIdList;
                readVC.lastChapterCount = [bookDict[@"totalChapterNum"] integerValue];
                NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
                readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
                [self presentViewController:readVC animated:YES completion:nil];
            } else {
                
                NSDictionary *dict = _bookDict[@"book"];
                NSArray *array = _bookDict[@"chapterList"];
                NSDictionary *chapterListDict = nil;
                if (array.count) {
                    chapterListDict = array[0];
                }
                
                E_ScrollViewController *readVC = [[E_ScrollViewController alloc] init];
                readVC.bookID = _bookID;
                readVC.chapterID = chapterListDict[@"chapterId"];
                readVC.bookName = dict[@"bookName"];
                readVC.bookIcon = dict[@"coverWap"];
                readVC.author = dict[@"author"];
                readVC.introude = dict[@"introduction"];
                readVC.totalChapter = chapterIdList.count;
                readVC.totalTitlArray = chapterNameList;
                readVC.chapterIdListArray = chapterIdList;
                readVC.lastChapterCount = [dict[@"totalChapterNum"] integerValue];
                NSDictionary *lastDict = _bookDict[@"lastChapterInfo"];
                readVC.lastChapterID = [NSString stringWithFormat:@"%@",lastDict[@"chapterId"]];
                [self presentViewController:readVC animated:YES completion:nil];
            }
        }
    }
}



#pragma mark - 初始化CatelogView数据
- (void)setupCatelogViewData:(NSArray *)array{
    
    self.chapterList = array;
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3, nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 初始化BackGroundView数据
- (void)setupBackGroundData:(NSDictionary *)dict{

    if (dict.count) {
        _bookDict = dict;
   
        NSDictionary *bookDict = dict[@"book"];
        
        //创建BackGroundView
        self.backGroundView.titleStr = bookDict[@"bookName"];
        self.backGroundView.authorStr = bookDict[@"author"];
        self.backGroundView.bookNumber = bookDict[@"totalWordSize"];
        self.backGroundView.backGroundImage = bookDict[@"coverWap"];
        self.backGroundView.status = [bookDict[@"status"] integerValue];
        self.backGroundView.bookTypeName = bookDict[@"bookTypeName"];
        self.backGroundView.clickNum = bookDict[@"clickNum"];
        [self.backGroundView creatView];
        [self.view addSubview:self.backGroundView];
        
        //创建CatalogView
        self.catalogView.totalStr = bookDict[@"totalChapterNum"];
        self.catalogView.lastChapterInfo = dict[@"lastChapterInfo"][@"chapterName"];
        [self.catalogView creatView];
        
        LaunchViewModel *model = [[LaunchViewModel alloc] init];
        model.introduction = bookDict[@"introduction"];
        self.model = model;
        
        //存评论数组模型
        self.commentModelArray = [CommentModel objectArrayWithKeyValuesArray:dict[@"commentList"]];
        
        //存同类作品数组模型
        self.similarModelArray = (NSMutableArray *)[SimilarBookModel objectArrayWithKeyValuesArray:dict[@"bookOtherList"]];
        if (self.similarModelArray.count > 2) {
            self.simliarModelThree = [self subArrayWithIndex:0 array:self.similarModelArray length:3];
        } else {
            self.simliarModelThree = self.similarModelArray;
        }
        
        
        //存作者其他作品数组模型
        self.userOtherModel = [SimilarBookModel objectArrayWithKeyValuesArray:dict[@"userBookOther"]];
        
        NSIndexSet *comment3 = [NSIndexSet indexSetWithIndex:3];
        NSIndexSet *comment4 = [NSIndexSet indexSetWithIndex:4];
        [self.tableView beginUpdates];
        
        [self.tableView reloadSections:comment3 withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:comment4 withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //刷新BackGroundView
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //刷新CatalogView
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
        //刷新评论
        if (self.commentModelArray.count > 2) {
            NSIndexSet *comment = [NSIndexSet indexSetWithIndex:2];
            [self.tableView reloadSections:comment withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath1, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
        
        //判断是否已经添加到书架
        [self setupGudgmentBookRack];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        return 0.01;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {//介绍
        return 1;
    } else if (section == 1) {//目录
        return 5;
    } else if (section == 2) {//评论
        
        if (self.commentModelArray.count > 2) {
            return 5;
        } else {
            return 1;
        }
    } else if (section == 3) {//同类作品
        if (self.simliarModelThree.count) {
            return 3;
        } else {
            return 1;
        }
    } else if (section == 4) {//作者其他作品
        if (self.userOtherModel.count) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.section == 0) {//介绍
        
        static NSString *cellIdentifier = @"introductCell";
        
        LaunchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[LaunchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.indexPath = indexPath;
        cell.block = ^(NSIndexPath *path) {
            [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        };
        [cell configCellWithModel:self.model];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (indexPath.section == 1) {//目录
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catelogCell" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"catelogCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.catalogView];
            return cell;
        } else if (indexPath.row == 4) {
            CommentAndCatelogCell *cell = [CommentAndCatelogCell cellWithTableView:tableView];
            cell.titleLabel.text = @"查看全部目录";
            return cell;
        } else {
            if (self.chapterList.count > indexPath.row - 1) {
                CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.chapterList[indexPath.row - 1][@"chapterName"]) {
                    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.chapterList[indexPath.row - 1][@"chapterName"]];
                }
                
                return cell;
            } else {
                CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"暂无章节";
                return cell;
            }
        }
    } else if (indexPath.section == 2) {//评论
        if (self.commentModelArray.count < 2) {
            CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"";
            return cell;
        } else {
            if (indexPath.row == 0) {
                CommentFirstViewCell *cell = [CommentFirstViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"评论";
                return cell;
            } else if (indexPath.row == 4) {
                CommentAndCatelogCell *cell = [CommentAndCatelogCell cellWithTableView:tableView];
                cell.titleLabel.text = @"查看全部评论";
                return cell;
            } else {
                if (self.commentModelArray.count > indexPath.row - 1) {
                    CommentModel *model = self.commentModelArray[indexPath.row - 1];
                    CommentViewCell *cell = [CommentViewCell cellWithTableView:tableView];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = model ;
                    return cell;
                } else {
                    CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"暂无评论";
                    return cell;
                }
            }
        }
        
    } else if (indexPath.section == 3) {//同类作品
        
        if (self.simliarModelThree.count) {
            if (indexPath.row == 0) {
                CommentFirstViewCell *cell = [CommentFirstViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"同类作品";
                return cell;
                
            } else if (indexPath.row == 2) {
                CommentAndCatelogCell *cell = [CommentAndCatelogCell cellWithTableView:tableView];
                cell.titleLabel.text = @"换一换";
                return cell;
            } else {
                AllLookCell *cell = [AllLookCell cellWithTableView:tableView];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                for (int i = 0; i < self.simliarModelThree.count; i ++) {
                    SimilarBookModel *model = self.simliarModelThree[i];
                    
                    if (i == 0) {
                        [cell.firstImage sd_setImageWithURL:[NSURL URLWithString:model.coverWap] placeholderImage:[UIImage imageNamed:@"common_bg"]];
                        cell.firstLabel.text = model.otherName;
                        
                    } else if (i == 1) {
                        [cell.secondImagbe sd_setImageWithURL:[NSURL URLWithString:model.coverWap] placeholderImage:[UIImage imageNamed:@"common_bg"]];
                        cell.secondLabel.text = model.otherName;
                        
                    } else {
                        [cell.thirdImage sd_setImageWithURL:[NSURL URLWithString:model.coverWap] placeholderImage:[UIImage imageNamed:@"common_bg"]];
                        cell.thirdLabel.text = model.otherName;
                    }
                }
                return cell;
            }
        } else {
            CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"";
            return cell;
        }
        
    } else if (indexPath.section == 4) {//作者其他作品
        
        if (self.userOtherModel.count) {
            if (indexPath.row == 0) {
                CommentFirstViewCell *cell = [CommentFirstViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"作者其他作品";
                return cell;
            } else {
                SimilarBookModel *model = self.userOtherModel[indexPath.row - 1];
                SimilarBookViewCell *cell = [SimilarBookViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model ;
                return cell;
            }
        } else {
            CatelogViewCell *cell = [CatelogViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"";
            return cell;
        }
        
    }  else {
    
        return nil;
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 4) {//查看全部目录
        [self setupSkipCatalog];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [self gotoNewChapter];
    } else if (indexPath.section == 1 ) {
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
            
            [self firstAndThree:indexPath.row];
        }
        
    } else if (indexPath.section == 2 && indexPath.row == 4) {//查看全部评论
        if (self.commentModelArray.count > 2) {
            [self setupSkipComment];
        }
        
    } else if (indexPath.section == 3 && indexPath.row == 2) {//换一换
        
        [MobClick event:@"ClickRecommend"];
        if (self.similarModelArray.count > 2) {
            _indexInt = _indexInt + 3;
            
            self.simliarModelThree = [self subArrayWithIndex:_indexInt array:self.similarModelArray length:3];
            
            //刷新同类作品
            NSIndexSet *comment = [NSIndexSet indexSetWithIndex:3];
            [self.tableView reloadSections:comment withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - 前3个章节
- (void)firstAndThree:(NSInteger)index{
    
    _firstThree = index - 1;

    _isStartRead = NO;
    
    _isFirstThree = YES;
    //请求小说的目录
    [self requestStoryMuenCall110:NO];
}

#pragma mark - 进入最新章节
- (void)gotoNewChapter{
    
    _isStartRead = YES;
    
    _isFirstThree = NO;
    //请求小说的目录
    [self requestStoryMuenCall110NewChapter];
    
}

#pragma mark - 消费（扣费）接口
- (void)requestConsume197:(NSString *)chapterID{
    
    [self setupSave];
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    BookInforModel *book = [dataManager getBookWithBookId:_bookID];
    NSString *discountPrice = book.price;
    NSString *totalPrice = book.sourceFrom;
    
    self.consumeModel = [[NetworkModel alloc] initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    
    requestData[@"bookId"] = _bookID;
    requestData[@"totalPrice"] = totalPrice;
    if ([_chapterUnit isEqualToString:@"本"]) {
        requestData[@"afterNum"] = @"";
    } else {
        requestData[@"afterNum"] = @"1";
    }
    
    requestData[@"discountPrice"] = discountPrice;
    requestData[@"baseChapterId"] = chapterID;
    requestData[@"position"] = @"0";
    requestData[@"readAction"] = @"1";
    requestData[@"lastChapterId"] = chapterID;
    requestData[@"marketStatus"] = @"";
    [self.consumeModel registerAccountAndCall:197 andRequestData:requestData];
}

#pragma mark - 支付检查
- (void)requestPayCheck196:(NSString *)chapterID{
    
    [[AppDelegate sharedApplicationDelegate].window showLoadingView];
    
//    NSString *lastChapterId = _chapterIdListArray.lastObject;
    
    self.payCheckmodel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"bookId"] = _bookID;
    requestData[@"baseChapterId"] = chapterID;
    requestData[@"readAction"] = @"3";
    requestData[@"lastChapterId"] = chapterID;
    [self.payCheckmodel registerAccountAndCall:196 andRequestData:requestData];
}

#pragma mark - 同类作品第一本书
- (void)allLookCellFirstBtnClick{
    
    if (self.simliarModelThree.count) {
        SimilarBookModel *model = self.simliarModelThree[0];
        if (model.otherId.length) {
            BookDetailController *bookVC = [[BookDetailController alloc] init];
            bookVC.bookID = model.otherId;
            bookVC.enterIndex = 100;
            [self.navigationController pushViewController:bookVC animated:YES];
            
            NSDictionary *dict = @{@"bookID" : model.otherId,@"bookName" : model.otherName};
            [MobClick event:@"ClickRecommend" attributes:dict];
        } else {
            [SVProgressHUD showWithStatus:@"请刷新获取书籍内容"];
        }
    }
}

#pragma mark - 同类作品第二本书
- (void)allLookCellSecondBtnClick{
    
    if (self.simliarModelThree.count > 1) {
        SimilarBookModel *model = self.simliarModelThree[1];
        if (model.otherId.length) {
            BookDetailController *bookVC = [[BookDetailController alloc] init];
            bookVC.enterIndex = 100;
            bookVC.bookID = model.otherId;
            NSDictionary *dict = @{@"bookID" : model.otherId,@"bookName" : model.otherName};
            [MobClick event:@"ClickRecommend" attributes:dict];
            [self.navigationController pushViewController:bookVC animated:YES];
        } else {
            [SVProgressHUD showWithStatus:@"请刷新获取书籍内容"];
        }
        
    }
}

#pragma mark - 同类作品第三本书
- (void)allLookCellThirdBtnClick{
    
    if (self.similarModelArray.count > 2) {
        SimilarBookModel *model = self.simliarModelThree[2];
        
        if (model.otherId.length) {
            BookDetailController *bookVC = [[BookDetailController alloc] init];
            bookVC.enterIndex = 100;
            bookVC.bookID = model.otherId;
            NSDictionary *dict = @{@"bookID" : model.otherId,@"bookName" : model.otherName};
            [MobClick event:@"ClickRecommend" attributes:dict];
            [self.navigationController pushViewController:bookVC animated:YES];
        } else {
            [SVProgressHUD showWithStatus:@"请刷新获取书籍内容"];
        }
    }
}

#pragma mark - 查看全部目录
- (void)setupSkipCatalog{

    //            NSLog(@"bookDetail-----%@",message.responseData);
    
    [MobClick event:@"ClickAllCatelog"];

    if ([self.bookRackDict isKindOfClass:[NSString class]]) {
        [SVProgressHUD showErrorWithStatus:@"书籍获取失败，请您从新加载"];
    } else {
        NSDictionary *bookDict = _bookDict[@"book"];
        
        CatalogViewController *catalogVC = [[CatalogViewController alloc] init];
        catalogVC.bookIDCatalog = _bookID;
        catalogVC.bookName = bookDict[@"bookName"];
        catalogVC.bookIcon = bookDict[@"coverWap"];
        catalogVC.author = bookDict[@"author"];
        catalogVC.introuce = bookDict[@"introduction"];
        
        [catalogVC.navigationItem setHidesBackButton:YES];
        
        [self.navigationController pushViewController:catalogVC animated:YES];
    }
}

#pragma mark - 查看全部评论
- (void)setupSkipComment{
    
    if (_bookID.length) {
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.bookIDComment = _bookID;
        
        [commentVC.navigationItem setHidesBackButton:YES];
        
        [self.navigationController pushViewController:commentVC animated:YES];
    } else {
        
        [SVProgressHUD showErrorWithStatus:@"书籍获取失败，请您从新加载"];
    }
}

#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//介绍
        
        return [LaunchViewCell heightWithModel:self.model];
    } else if (indexPath.section == 1 && indexPath.row == 0) {//目录
        return 88;
    } else if ((indexPath.section == 2 && indexPath.row == 0)) {//评论view
        if (self.commentModelArray.count > 2) {
            return 35;
        } else {
            return 0.01;
        }
        
    } else if (indexPath.section == 2 && indexPath.row != 0 && indexPath.row != 4) {//评论cell
        if (self.commentModelArray.count > 2) {
            return 60;
        } else {
            return 0.01;
        }
        
    } else if (indexPath.section == 3 && indexPath.row != 0 && indexPath.row != 2) {//同类作品
        if (self.simliarModelThree.count) {
            return 183;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 4 && indexPath.row == 1) {//作者其他书籍第二行
        if (self.userOtherModel.count) {
            return 153;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 4 && indexPath.row == 0) {//作者其他书籍第一行
        if (self.userOtherModel.count) {
            return 44;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 5 && indexPath.row == 1) {//更多图书信息
        return 60;
    } else {
        return 44;
    }
}


#pragma mark - 返回，分享，加书架，开始阅读
- (void)backGroundViewBtnClick:(UIButton *)button{

    if (button.tag == 10) {//返回
        
        if (_enterIndex == 100) {
        
      
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.navigationController.navigationBar.hidden = NO;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    
    } else if (button.tag == 11) {//分享
    
        self.backGroundView.shareBtn.enabled = NO;
        [self setupWXShare];
        
    } else if (button.tag == 12) {//加书架
        
        [self setupSave];
        
    } else if (button.tag == 13) {//开始阅读
        
        [self setupStartRead];
    }
}

#pragma mark - 分享菜单栏3个点击事件
- (void)WXShareBtnClick:(UIButton *)button{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backGroundView.shareBtn.enabled = YES;
    });
    
//
    NSString *str = nil;
    if (button.tag == 10) {
        str = @"取消";
    } else if (button.tag == 11) {
        str = @"微信朋友圈分享";
    } else if (button.tag == 12) {
        str = @"微信好友分享";
    }
    NSDictionary *dict = @{@"location" : str};
    [MobClick event:@"CollapseLog" attributes:dict];
    if (button.tag == 10) {//取消和背景点击
        
        [_shareView dissShareView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_shareView removeFromSuperview];
        });
        
    } else if (button.tag == 11) {//微信朋友圈分享
        
        [_shareView dissShareView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_shareView removeFromSuperview];
        });
        
        if ([WXApi isWXAppInstalled]) {//安装了微信
            
            [self gotoWXShare:button.tag];
        } else {
            [self gotoWXError];
        }
        
    } else if (button.tag == 12) {//微信好友分享
        
        [_shareView dissShareView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_shareView removeFromSuperview];
        });
        if ([WXApi isWXAppInstalled]) {
            [self gotoWXShare:button.tag];
        } else {
            [self gotoWXError];
        }
    }
}

//未安装微信客户端
- (void)gotoWXError{

    [SVProgressHUD showWithStatus:@"检测未安装微信客户端"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

//分享
- (void)gotoWXShare:(NSInteger)index{

    NSDictionary *bookDict = _bookDict[@"book"];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bookDict[@"coverWap"]] options:NSDataReadingMappedIfSafe error:nil];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:bookDict[@"bookName"] descr:bookDict[@"introduction"] thumImage:data];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://m.kkyd.cn/book_content.html?bookId=%@&channelCode=%@",bookDict[@"bookId"],ChannelCode];

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    UMSocialPlatformType type = UMSocialPlatformType_WechatTimeLine;
    if (index == 11) {
        type = UMSocialPlatformType_WechatTimeLine;
    } else {
        type = UMSocialPlatformType_WechatSession;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            [SVProgressHUD showWithStatus:@"分享失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } else {
            [SVProgressHUD showWithStatus:@"分享成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
}



#pragma mark - 创建分享
- (void)setupWXShare{

    _shareView = [[WXShareView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    _shareView.delegate = self;
    [_shareView creatView];
    
    [_shareView showShareView];

}

#pragma mark - 开始阅读
- (void)setupStartRead{
    
    [MobClick event:@"ClickStartRead"];
    _isStartRead = NO;
    
    _isFirstThree = NO;
    
    //请求小说的目录
    [self requestStoryMuenCall110:NO];
}

#pragma mark - 判断是否已经添加到书架中
- (void)setupGudgmentBookRack{
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
   
    BookInforModel *book = [dataManager getBookWithBookId:_bookID];

    if (book.isAddBook.integerValue == 1) {

        self.backGroundView.rackBtn.enabled = NO;
        [self.backGroundView.rackBtn setBackgroundImage:[UIImage imageNamed:@"Book-details_btn_d"] forState:UIControlStateNormal];
        [self.backGroundView.rackBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.backGroundView.rackBtn.layer setBorderWidth:0];
    }
}


#pragma mark - 添加书到书架
- (void)setupSave{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"refreshBookRack"];
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:self.bookRackDict];
 
    [mutableDict setObject:dateString forKey:@"dateTime"];
    
    NSDictionary *dict = self.bookRackDict[@"book"];    
   
    BOOL isTrue = NO;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.DBModel = [JYS_SqlManager shareManager];
        isTrue  = [self.DBModel insertData:mutableDict];
    }
    
    if (isTrue) {
        
        [MobClick event:@"ClickAddRack"];
        self.backGroundView.rackBtn.enabled = NO;
        [self.backGroundView.rackBtn setBackgroundImage:[UIImage imageNamed:@"Book-details_btn_d"] forState:UIControlStateNormal];
        [self.backGroundView.rackBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.backGroundView.rackBtn.layer setBorderWidth:0];
    }else{
        [SVProgressHUD showWithStatus:@"添加书架失败！"];
    }
}

#pragma mark - 从数组循坏获取数据
- (NSMutableArray *)subArrayWithIndex:(NSInteger)index array:(NSMutableArray *)array length:(NSInteger)length{
    
    NSInteger count = array.count;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(NSInteger i = index; i < index+length; i++)
    {
        id object = [array objectAtIndex:i%count];
        [result addObject:object];
    }
    
    return result;
}


@end
