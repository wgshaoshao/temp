//
//  CatalogView.h
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogView : UIView

- (void)creatView;
/** 总章节数 */
@property (nonatomic, strong) NSString *totalStr;
/** 最后一章章节信息 */
@property (nonatomic, strong) NSString *lastChapterInfo;

@end
