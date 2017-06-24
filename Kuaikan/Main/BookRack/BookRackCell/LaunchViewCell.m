//
//  LaunchViewCell.m
//  Kuaikan
//
//  Created by 少少 on 16/4/7.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "LaunchViewCell.h"

#define IS_IPhone5S (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

@interface LaunchViewCell ()
@property (nonatomic, strong) LaunchViewModel *model;
@property (nonatomic, strong) UILabel *button;

@end

@implementation LaunchViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.introLabel = [[UILabel alloc] init];
        self.introLabel.frame = CGRectMake(0, 10, 2, 17);
        self.introLabel.backgroundColor = ADColor(53, 137, 238);;
        [self addSubview:self.introLabel];
        
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.text = @"简介";
        introLabel.frame =CGRectMake(10, 8, 50, 20);
        introLabel.font = Font14;
        [self.contentView addSubview:introLabel];

        
        self.introductLabel = [[UILabel alloc] init];
        self.introductLabel.textColor = LightTextColor;
        self.introductLabel.font = Font15;
        self.introductLabel.numberOfLines = 0;
//        self.introductLabel.backgroundColor = [UIColor blackColor];
        self.introductLabel.textAlignment = NSTextAlignmentLeft;
        // 兼容6.0
        self.introductLabel.preferredMaxLayoutWidth = ScreenWidth - 20;
        [self.contentView addSubview:self.introductLabel];
        [self.introductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(35);
        }];
        self.introductLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self.introductLabel addGestureRecognizer:tap];
        self.lineLabel = [[UILabel alloc] init];
        self.lineLabel.backgroundColor = LineLabelColor;
        [self.contentView addSubview:self.lineLabel];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        CGFloat buttonW = [AppDelegate sizeWithText:@"..." font:Font14 maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
        CGFloat lableW = [AppDelegate sizeWithText:@"读" font:Font14 maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
        
        self.button = [[UILabel alloc] init];
        self.button.text = @"...【展开】";
        self.button.textColor = ADColor(182, 182, 182);
//        self.button.backgroundColor = WhiteColor;
        self.button.backgroundColor = WhiteColor;
        self.button.font = Font14;
        [self.contentView addSubview:self.button];
        self.button.textAlignment = NSTextAlignmentRight;
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(70);
            make.right.mas_equalTo(self.contentView).offset(-10);
            if (IS_IPhone6) {
                make.size.mas_equalTo(CGSizeMake(lableW + 5.5 + (buttonW * 5), 20));
//                make.size.mas_equalTo(CGSizeMake((lableW * 5), 20));
            } else if (IS_IPhone6plus) {
                make.size.mas_equalTo(CGSizeMake(lableW - 1 + (buttonW * 5), 20));
//                make.size.mas_equalTo(CGSizeMake((lableW * 5), 20));
            } else {
//                make.size.mas_equalTo(CGSizeMake((lableW * 5), 20));
                make.size.mas_equalTo(CGSizeMake(lableW - 3 + (buttonW * 5), 20));
            }
        }];
    }
    return self;
}

- (void)configCellWithModel:(LaunchViewModel *)model {
    
    self.model = model;
    if (model.introduction.length) {
        self.introductLabel.text = model.introduction;
    }
    
    if (model.isExpanded) {
        [self.introductLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(40);
        }];
        self.button.hidden = YES;

    } else {
        
        [self.introductLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(35);
            make.height.mas_equalTo(54);
        }];
        self.button.hidden = NO;
    }
}

- (void)onTap {
    self.model.isExpanded = !self.model.isExpanded;
    
    if (self.block) {
        self.block(self.indexPath);
    }
    
    [self configCellWithModel:self.model];
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0 animations:^{
        [self.contentView layoutIfNeeded];
    }];
    
    
}

+ (CGFloat)heightWithModel:(LaunchViewModel *)model {
    
    LaunchViewCell *cell = [[LaunchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:model];
    
    [cell layoutIfNeeded];
    
    
    CGRect frame =  cell.introductLabel.frame;
    if (model.isExpanded){
        return frame.origin.y + frame.size.height + 15;
    } else {
        return frame.origin.y + frame.size.height + 10;
    }
}


@end


@implementation LaunchViewModel

@end



