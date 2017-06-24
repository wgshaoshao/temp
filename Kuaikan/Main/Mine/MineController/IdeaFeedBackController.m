//
//  IdeaFeedBackController.m
//  Kuaikan
//
//  Created by 少少 on 16/5/16.
//  Copyright © 2016年 DZKJ. All rights reserved.
//

#import "IdeaFeedBackController.h"
#import "DisagreeBtn.h"

@interface IdeaFeedBackController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) DisagreeBtn *stumbleBtn;
@property (nonatomic, strong) DisagreeBtn *updateBtn;
@property (nonatomic, strong) DisagreeBtn *flowBtn;
@property (nonatomic, strong) DisagreeBtn *bookBtn;
@property (nonatomic, strong) DisagreeBtn *UIBtn;
@property (nonatomic, strong) DisagreeBtn *promptBtn;
@property (nonatomic, strong) DisagreeBtn *priceBtn;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NetworkModel *netWorkModel;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation IdeaFeedBackController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [_navigationBarView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self createNavigationBarView];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = BackViewColor;
    
    [self setupView];
    
    [self setupTextView];
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
    titleMainLabel.text = [NSString stringWithFormat:@"意见反馈"];
    titleMainLabel.textAlignment = NSTextAlignmentCenter;
    titleMainLabel.font = Font18;
     titleMainLabel.backgroundColor = [UIColor clearColor];
    titleMainLabel.textColor = WhiteColor;
    [_navigationBarView addSubview:titleMainLabel];
    [titleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 100, 0, 100));
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

#pragma mark - 返回上一级
- (void)closeWindowClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupView{
    
    CGFloat marginY =  15;
    CGFloat stumbleBtnH = 35;
    CGFloat marginTwoY = marginY + stumbleBtnH + 15;
    CGFloat margin = 12;
    CGFloat stumbleBtnW = (ScreenWidth - 5 * margin) / 4;

    DisagreeBtn *stumbleBtn = [[DisagreeBtn alloc] init];
    [self addButton:stumbleBtn fieldFrame:CGRectMake(margin, marginY, stumbleBtnW, stumbleBtnH) title:@"不流畅" tag:1];
    stumbleBtn.isDisect = NO;
    self.stumbleBtn = stumbleBtn;
    
    CGFloat updateBtnX = 2 * margin + stumbleBtnW;
    DisagreeBtn *updateBtn = [[DisagreeBtn alloc] init];
    [self addButton:updateBtn fieldFrame:CGRectMake(updateBtnX, marginY, stumbleBtnW, stumbleBtnH) title:@"更新慢" tag:2];
    updateBtn.isDisect = NO;
    self.updateBtn = updateBtn;
    
    CGFloat flowBtnX = 3 * margin + 2 * stumbleBtnW;
    DisagreeBtn *flowBtn = [[DisagreeBtn alloc] init];
    [self addButton:flowBtn fieldFrame:CGRectMake(flowBtnX, marginY, stumbleBtnW, stumbleBtnH) title:@"耗流量" tag:3];
    flowBtn.isDisect = NO;
    self.flowBtn = flowBtn;
    
    CGFloat bookBtnX = 4 * margin + 3 * stumbleBtnW;
    DisagreeBtn *bookBtn = [[DisagreeBtn alloc] init];
    [self addButton:bookBtn fieldFrame:CGRectMake(bookBtnX, marginY, stumbleBtnW, stumbleBtnH) title:@"书籍少" tag:4];
    bookBtn.isDisect = NO;
    self.bookBtn = bookBtn;
   
    DisagreeBtn *UIBtn = [[DisagreeBtn alloc] init];
    [self addButton:UIBtn fieldFrame:CGRectMake(margin, marginTwoY, stumbleBtnW, stumbleBtnH) title:@"界面丑" tag:5];
    UIBtn.isDisect = NO;
    self.UIBtn = UIBtn;
    
    CGFloat priceBtnX = 2 * margin + stumbleBtnW;
    DisagreeBtn *priceBtn = [[DisagreeBtn alloc] init];
    [self addButton:priceBtn fieldFrame:CGRectMake(priceBtnX, marginTwoY, stumbleBtnW, stumbleBtnH) title:@"价格高" tag:6];
    priceBtn.isDisect = NO;
    self.priceBtn = priceBtn;
    
    CGFloat promptBtnX = 3 * margin + 2 * stumbleBtnW;
    DisagreeBtn *promptBtn = [[DisagreeBtn alloc] init];
    [self addButton:promptBtn fieldFrame:CGRectMake(promptBtnX, marginTwoY, stumbleBtnW, stumbleBtnH) title:@"提示少" tag:7];
    promptBtn.isDisect = NO;
    self.promptBtn = promptBtn;
}

- (void)setupTextView{
    
    CGFloat textViewY = CGRectGetMaxY(self.promptBtn.frame) + 15;
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(12, textViewY, ScreenWidth - 24, 100);
    textView.font = Font14;
    textView.delegate = self;
    textView.backgroundColor = WhiteColor;
    [self.view addSubview:textView];
    self.textView = textView;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    CGFloat numberLabelY = CGRectGetMaxY(textView.frame) + 5;
    numberLabel.frame = CGRectMake(12, numberLabelY, ScreenWidth - 24, 15);
    numberLabel.text = @"0/200";
    numberLabel.font = Font12;
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.textColor = ADColor(153, 153, 153);
    [self.view addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [self.view addSubview:submitBtn];
    CGFloat submitBtnY = CGRectGetMaxY(numberLabel.frame) + 15;
    submitBtn.frame = CGRectMake((ScreenWidth - 190) / 2, submitBtnY, 190, 40);
    submitBtn.backgroundColor = ADColor(96, 204, 95);
    submitBtn.titleLabel.font = Font15;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
}

#pragma mark - 提交
- (void)submitBtnClick{
    
    self.submitBtn.enabled = NO;
    
    [self performSelector:@selector(todosomething) withObject:self afterDelay:2.5];
    
    if (self.textView.text.length || self.stumbleBtn.isDisect || self.flowBtn.isDisect || self.bookBtn.isDisect || self.UIBtn.isDisect || self.promptBtn.isDisect || self.priceBtn.isDisect || self.updateBtn.isDisect) {
        [self requestUserFeedBack116];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请填写意见反馈"];
    }
}

- (void)todosomething{
    
    self.submitBtn.enabled = YES;
}


#pragma mark - 热荐
- (void)requestUserFeedBack116{
    
    [SVProgressHUD showWithStatus:@"提交意见中" maskType:SVProgressHUDMaskTypeClear];
    self.netWorkModel = [[NetworkModel alloc]initWithResponder:self];
    NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
    requestData[@"constents"] = self.textView.text;
    [self.netWorkModel registerAccountAndCall:116 andRequestData:requestData];
}

#pragma mark - 网络请求结束回调
- (void)receiveMessage:(Message *)message{
    
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.numberLabel.text = @"0/200";
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    });
    
    
    
    [self setupSuccess];
   
}

- (void)setupSuccess{

    self.textView.text = @"";
    
    [self.stumbleBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.stumbleBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.stumbleBtn.isDisect = NO;
    
    [self.updateBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.updateBtn.isDisect = NO;
    
    [self.flowBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.flowBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.flowBtn.isDisect = NO;
    
    [self.bookBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.bookBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.bookBtn.isDisect = NO;
    
    [self.UIBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.UIBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.UIBtn.isDisect = NO;
    
    [self.priceBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.priceBtn.isDisect = NO;
    
    [self.promptBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    [self.promptBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
    self.promptBtn.isDisect = NO;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 200) {
        [self.view showAlertTextWith:@"最多输入200个字"];
        
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textView resignFirstResponder];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return textView.text.length + (text.length - range.length) <= 200;
}

//创建一个button
- (void)addButton:(UIButton *)button fieldFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    
    button.titleLabel.font = Font14;
    [button setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
    button.frame = frame;
    button.tag = tag;
    [button setTitleColor:LightTextColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button{

    if (button.tag == 1) {
        if (self.stumbleBtn.isDisect) {
            [self.stumbleBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.stumbleBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.stumbleBtn.isDisect = NO;
        } else {
            [self.stumbleBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.stumbleBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.stumbleBtn.isDisect = YES;
        }
    } else if (button.tag == 2) {
        if (self.updateBtn.isDisect) {
            [self.updateBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.updateBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.updateBtn.isDisect = NO;
        } else {
            [self.updateBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.updateBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.updateBtn.isDisect = YES;
        }
    } else if (button.tag == 3) {
        if (self.flowBtn.isDisect) {
            [self.flowBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.flowBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.flowBtn.isDisect = NO;
        } else {
            [self.flowBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.flowBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.flowBtn.isDisect = YES;
        }
    } else if (button.tag == 4) {
        if (self.bookBtn.isDisect) {
            [self.bookBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.bookBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.bookBtn.isDisect = NO;
        } else {
            [self.bookBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.bookBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.bookBtn.isDisect = YES;
        }
    } else if (button.tag == 5) {
        if (self.UIBtn.isDisect) {
            [self.UIBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.UIBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.UIBtn.isDisect = NO;
        } else {
            [self.UIBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.UIBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.UIBtn.isDisect = YES;
        }
    } else if (button.tag == 6) {
        if (self.priceBtn.isDisect) {
            [self.priceBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.priceBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.priceBtn.isDisect = NO;
        } else {
            [self.priceBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.priceBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.priceBtn.isDisect = YES;
        }
    } else if (button.tag == 7) {
        if (self.promptBtn.isDisect) {
            [self.promptBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_n"] forState:UIControlStateNormal];
            [self.promptBtn setTitleColor:ADColor(102, 102, 120) forState:UIControlStateNormal];
            self.promptBtn.isDisect = NO;
        } else {
            [self.promptBtn setBackgroundImage:[UIImage imageNamed:@"search_opinion_btn_s"] forState:UIControlStateNormal];
            [self.promptBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.promptBtn.isDisect = YES;
        }
    }
}

@end
