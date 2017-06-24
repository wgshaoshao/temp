//
//  PlistViewController.m
//  Kuaikan
//
//  Created by 少少 on 16/11/9.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "PlistViewController.h"

@interface PlistViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *navigationBarView;

@end

@implementation PlistViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [_navigationBarView removeFromSuperview];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self createNavigationBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = Font18;
    textView.text = _content;
    textView.editable = NO;
    textView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40);
    [self.view addSubview:textView];
    self.textView = textView;

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [textView addGestureRecognizer:doubleTapGestureRecognizer];
}

- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.textView.text];
    if (pab != nil) {
        
        [self.view showAlertTextWith:@"全文已复制到手机剪切板"];
    }
}

- (void)createNavigationBarView{
    
    _navigationBarView = [self.navigationController.navigationBar viewWithTag:10];
    if (_navigationBarView != nil) {
        return;
    }
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _navigationBarView.tag = 10;
    [self.navigationController.navigationBar addSubview:_navigationBarView];
    
    UILabel *titleMainLabel = [UILabel new];
    titleMainLabel.text = [NSString stringWithFormat:@"崩溃日志(双击可复制)"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
    titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 50, 0, 50));
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton addTarget:self action:@selector(closeWindowClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBarView).with.offset(0.0f);
        make.left.equalTo(_navigationBarView).with.offset(0.0f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [closeButton setImage:[UIImage imageNamed:@"lodin_icon_return_-normal"] forState:UIControlStateNormal];
    
}

- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
