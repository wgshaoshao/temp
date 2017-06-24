//
//  SearchResultController.m
//  Kuaikan
//
//  Created by 少少 on 16/3/31.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "SearchResultController.h"
#import "OneResultController.h"

@interface SearchResultController ()

@end

@implementation SearchResultController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = _resultArray[indexPath.row];
    cell.textLabel.text = dict[@"key"];
    return cell;
}



@end
