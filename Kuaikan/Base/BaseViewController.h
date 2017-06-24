//
//  BaseViewController.h
//  Kuaikan
//
//  Created by fangshufeng on 16/9/10.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface BaseViewController : UIViewController
@property (strong, nonatomic) Reachability *reach;  
@end
