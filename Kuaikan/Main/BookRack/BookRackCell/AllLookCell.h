//
//  AllLookCell.h
//  Kuaikan
//
//  Created by 少少 on 16/6/14.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllLookCellDelegate <NSObject>

@optional
- (void)allLookCellFirstBtnClick;
- (void)allLookCellSecondBtnClick;
- (void)allLookCellThirdBtnClick;
@end

@interface AllLookCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<AllLookCellDelegate> delegate;


@property (nonatomic, strong) UIImageView *firstImage;
@property (nonatomic, strong) UIImageView *secondImagbe;
@property (nonatomic, strong) UIImageView *thirdImage;

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

@end
