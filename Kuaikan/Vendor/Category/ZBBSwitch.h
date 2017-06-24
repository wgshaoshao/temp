//
//  ZBBSwitch.h
//  ZBBSwitchDemo
//
//  Created by zhangbinbin on 16/2/24.
//  Copyright © 2016年 zhangbinbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBBSwitch : UIButton

@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, copy) NSString* leftName;
//@property (nonatomic, strong) UIColor* leftTextColor;
//@property (nonatomic, strong) UIColor* leftBgColor;

@property (nonatomic, copy) NSString* rightName;
//@property (nonatomic, strong) UIColor* rightTextColor;
//@property (nonatomic, strong) UIColor* rightBgColor;

@end
