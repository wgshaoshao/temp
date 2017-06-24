//
//  LaunchViewCell.h
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewModel : NSObject

@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, assign) BOOL isExpanded;

@end
typedef void (^LaunchViewBlock)(NSIndexPath *indexPath);

@interface LaunchViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *introductLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) LaunchViewBlock block;

- (void)configCellWithModel:(LaunchViewModel *)model;

+ (CGFloat)heightWithModel:(LaunchViewModel *)model;


@end
