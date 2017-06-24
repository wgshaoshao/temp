//
//  SpecialController.m
//  Kuaikan
//
//  Created by 少少 on 16/8/17.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SpecialController.h"

@interface SpecialController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SpecialController

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
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"specialCell"];

}

#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//
////        return _secondArray.count;
//   
//}



@end
