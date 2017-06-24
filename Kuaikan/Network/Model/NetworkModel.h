//
//  NetworkModel.h
//  Kuaikan
//
//  Created by 少少 on 16/3/21.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "Model.h"

@interface NetworkModel : Model

- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData;
//同步请求数据
- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData Snyc:(BOOL)sync;

@end
