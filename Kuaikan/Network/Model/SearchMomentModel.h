//
//  SearchMomentModel.h
//  Kuaikan
//
//  Created by 少少 on 16/4/15.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "Model.h"

@interface SearchMomentModel : Model

- (void)registerAccountAndCall:(NSInteger)call andRequestData:(NSMutableDictionary *)requestData;

@end
