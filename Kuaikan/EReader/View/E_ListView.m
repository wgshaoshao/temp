//
//  E_ListView.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/15.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_ListView.h"
#import "E_ReaderDataSource.h"
#import "E_MarkTableViewCell.h"
#import "RechargeController.h"
#import "MJRefresh.h"

@implementation E_ListView
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//}

- (void)viewWillAppear:(BOOL)animated{
    
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}


- (id)initWithFrame:(CGRect)frame andDataArray:(NSArray *)dataArray{
    
    if (self = [super initWithFrame:frame]) {
                
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _dataSource = dataArray;
        _markDataSource = [NSArray new];
        [self configListView];
       
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEListView:)];
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

- (void)panEListView:(UIPanGestureRecognizer *)recongnizer{
    CGPoint touchPoint = [recongnizer locationInView:self];
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartX = touchPoint.x;
           }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGFloat offSetX = touchPoint.x - _panStartX;
            CGRect newFrame = self.frame;

            newFrame.origin.x += offSetX;
            if (newFrame.origin.x >= 0){//试图向上滑动 阻止
               
                newFrame.origin.x = 0;
                self.frame = newFrame;
                return;
            }else{
                self.frame = newFrame;
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            float duringTime = (self.frame.size.width + self.frame.origin.x)/self.frame.size.width * 0.25;
            if (self.frame.origin.x < 0) {
                [UIView animateWithDuration:duringTime animations:^{
                    self.frame = CGRectMake(-self.frame.size.width , 0,  self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [_delegate removeE_ListView];
                }];
                
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }
}



- (void)configListView{
    
    _isMenu = YES;
    _isMark = NO;
    _isNote = NO;
    
    _isFooterRefresh = NO;
    
    [self configListViewHeader];
   
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height - 80 - 60)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor clearColor];
    [self addSubview:_listView];
    
    [self setupRefresh];
}


#pragma mark - UITableView下拉刷新
- (void)setupRefresh{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_listView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

#pragma mark - 头部刷新
- (void)headerRefreshing{
    
    _isFooterRefresh = NO;
    [_listView headerEndRefreshing];
}

#pragma mark - 尾部刷新
- (void)footerRefreshing{
    
    _isFooterRefresh = YES;
    
    if (_isMark) {
        [SVProgressHUD showImage:nil status:@"暂无最新书签"];
    } else {
    
        [SVProgressHUD showImage:nil status:@"已是最后一章"];
    }
    

    

    
    if (_isFooterRefresh) {
        [_listView footerEndRefreshing];
    } else {
        [_listView headerEndRefreshing];
    }
}


- (void)configListViewHeader{

    NSArray *segmentedArray = @[@"目录",@"书签"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentControl.frame = CGRectMake(15, 30, self.bounds.size.width - 30 , 40);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    [self addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:dict forState:0];
    
    _timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction{
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    [_listView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
}

- (void)segmentAction:(UISegmentedControl *)sender{
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:{
                _isMenu = YES;
                _isMark = NO;
                _isNote = NO;
//                dataCount = [E_ReaderDataSource shareInstance].totalChapter;
                [_listView reloadData];
            }
            break;
        case 1:{
                _isMenu = NO;
                _isMark = YES;
                _isNote = NO;
                _markDataSource = [E_CommonManager Manager_getMark];
                [_listView reloadData];
            }
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (_isMark) {
        return 100;
    }
    
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isMark) {
        
        return _markDataSource.count;
    }
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMark) {
        [_delegate clickMark:[_markDataSource objectAtIndex:indexPath.row]];
        return;
    }
    
    [_delegate clickChapter:indexPath.row];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMenu == YES) {
        static NSString *cellStr = @"menuCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        CatelogInforModel *chapter = nil;
        if (indexPath.row<_dataSource.count) {
           chapter = _dataSource[indexPath.row];
        }

        if (indexPath.row == _index) {
            cell.textLabel.textColor = NavigationColor;
        } else {
            
            //NSString *chapterId = [E_ReaderDataSource shareInstance].chapterIdListArray[indexPath.row];
            //JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
            
            
            if ((chapter.isDownload == nil)||(chapter.isDownload.integerValue==0)) {
                cell.textLabel.textColor = ADColor(135, 135, 135);
            } else {
                cell.textLabel.textColor = [UIColor blackColor];
            }
        }
        
        if ([E_ReaderDataSource shareInstance].totalTitlArray.count > (long)indexPath.row) {
            cell.textLabel.text = chapter.catelogName;
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;

    }else if(_isMark){
        
        static NSString *cellStr = @"markCell";
        E_MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[E_MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
//        NSString *indexStr = [(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markChapter];
//        NSInteger indexInt = [indexStr integerValue];
//        cell.chapterLbl.text = [NSString stringWithFormat:@"第%ld章",(long)indexInt + 1];
        cell.timeLbl.text    = [(E_Mark *)[_markDataSource objectAtIndex:indexPath.row] markTime];
        cell.contentLbl.text = [(E_Mark *)[_markDataSource objectAtIndex:indexPath.row] markContent];
        return cell;
    
    }else{
        static NSString *cellStr = @"noteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
        return cell;
    }
    return nil;
}



@end
