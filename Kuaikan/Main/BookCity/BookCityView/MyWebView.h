//
//  MyWebView.h
//  Kuaikan
//
//  Created by CloudJson on 2017/2/24.
//  Copyright © 2017年 DZKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebView : UIWebView


@property (nonatomic,assign)BOOL isFirstShow;

-(instancetype)initWithFrame:(CGRect)frame andCacheProcliy:(NSURLRequestCachePolicy)policy;

@end
