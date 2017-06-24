//
//  CatelogInforModel.h
//  Kuaikan
//
//  Created by CloudJson on 2017/3/10.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatelogInforModel : NSObject

/**
 章节所属的书籍id
 */
@property ( nonatomic, copy) NSString *bookid;

/**
 章节id
 */
@property ( nonatomic, copy) NSString *chaterId;

/**
 章节名称
 */
@property ( nonatomic, copy) NSString *catelogName;

/**
 章节是否购买 0未购买 1已购买
 */
@property ( nonatomic, copy) NSNumber *isAlreadyPay;

/**
 是否已下载
 */
@property ( nonatomic, copy) NSNumber *isDownload;

/**
 是否付费
 */
@property ( nonatomic, copy) NSNumber *isPay;

/**
 是否阅读过
 */
@property ( nonatomic, copy) NSNumber *isRead;

/**
 文件保存路径
 */
@property ( nonatomic, copy) NSString *path;

/**
 分段信息
 */
@property ( nonatomic, copy) NSString *tips;

/**
 书签位置（字段开头位置）
 */
@property ( nonatomic, copy) NSNumber *positionLeft;

/**
 操作时间
 */
@property ( nonatomic, copy) NSString *time;

/**
 书签结束的位置
 */
@property ( nonatomic, copy) NSNumber *positionRight;


/**
 章节唯一标识（主键）
 */
@property ( nonatomic, copy) NSString *entityid;


@property ( nonatomic, copy) NSString *catelogfrom;
@property ( nonatomic, copy) NSString *cmBookAttribute;
@property ( nonatomic, copy) NSString *cmConsumePrice;
@property ( nonatomic, copy) NSString *cmIsVip;
@property ( nonatomic, copy) NSString *cmMarketPrice;
@property ( nonatomic, copy) NSString *cmOrderRelationShip;
@property ( nonatomic, copy) NSNumber *currentPos;
@property ( nonatomic, copy) NSString *dlTime;
@property ( nonatomic, copy) NSString *errType;
@property ( nonatomic, copy) NSString *isNewPayUrl;
@property ( nonatomic, copy) NSString *ispayupload;
@property ( nonatomic, copy) NSString *isupload;
@property ( nonatomic, copy) NSString *next;
@property ( nonatomic, copy) NSString *nextPayUrl;
@property ( nonatomic, copy) NSString *payTime;
@property ( nonatomic, copy) NSString *payUrl;
@property ( nonatomic, copy) NSString *preIsdownload;
@property ( nonatomic, copy) NSString *prePayUrl;
@property ( nonatomic, copy) NSString *previous;
@property ( nonatomic, copy) NSString *url;

+(NSString *)whc_SqliteVersion;

@end
