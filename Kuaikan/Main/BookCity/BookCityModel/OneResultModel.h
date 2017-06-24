//
//  OneResultModel.h
//  Kuaikan
//
//  Created by 少少 on 16/4/19.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneResultModel : NSObject

@property (nonatomic, strong) NSString *coverWap;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *author;

@end
