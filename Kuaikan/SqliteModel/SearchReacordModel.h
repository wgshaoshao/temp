//
//  SearchReacordModel.h
//  Kuaikan
//
//  Created by CloudJson on 2017/3/10.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchReacordModel : NSObject

@property (nonatomic,retain)NSString *searchstr;
@property (nonatomic,retain)NSString *recordTime;



+(NSString *)whc_SqliteVersion;

@end
