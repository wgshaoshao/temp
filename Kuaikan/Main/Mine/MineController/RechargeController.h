//
//  RechargeController.h
//  Kuaikan
//
//  Created by 少少 on 16/4/26.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeController : BaseViewController
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *priceUnit;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, assign) BOOL isRechare;
@end
