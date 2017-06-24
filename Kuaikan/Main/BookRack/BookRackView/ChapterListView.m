//
//  ChapterListView.m
//  Kuaikan
//
//  Created by 少少 on 16/11/28.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "ChapterListView.h"

@implementation ChapterListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.5;
        cover.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
  
        [self configListView];
        
    }
    return self;
}

- (void)coverClick{

    if ([self.delegate respondsToSelector:@selector(removeChapterListView)]) {
        [self.delegate removeChapterListView];
    }
}

- (void)configListView{
    
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(60 * KKuaikan, 125 * KKuaikan, ScreenWidth - 120 * KKuaikan, ScreenHeight - 250 * KKuaikan)];
    _listView.delegate = self;
    _listView.dataSource = self;
    if (isNightView) {
        _listView.backgroundColor = ADColor(143, 143, 143);
        _listView.separatorColor = ADColor(157, 157, 157);
    }else{
        _listView.backgroundColor = BackViewColor;
    }
    [self addSubview:_listView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(clickParkChapter:)]) {
        [self.delegate clickParkChapter:indexPath.row];
    }
//    [_delegate clickChapter:indexPath.row];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellStr = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (isNightView) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = ADColor(143, 143, 143);
    }else{
        cell.backgroundColor = BackViewColor;
    }
    NSDictionary *dict = _dataSource[indexPath.row];
    cell.textLabel.text = dict[@"tips"];
    cell.textLabel.textColor = LightTextColor;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
        

}



@end
