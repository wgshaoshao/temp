//
//  BookDetailController.h
//  Kuaikan
//
//  Created by 少少 on 16/4/6.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailController : BaseViewController


@property (nonatomic, strong) NSString *bookID;
/**所在位置 1:书城  2:书架*/
@property (nonatomic, strong) NSString *defbook;
@property (nonatomic, assign) NSInteger enterIndex;

@property (nonatomic, strong) NSString *sourceFrom;//标识书籍来源，从哪里点击进来的

@end
