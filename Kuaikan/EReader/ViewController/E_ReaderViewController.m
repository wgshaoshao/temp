//
//  E_ReaderViewController.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderViewController.h"

#import "E_CommonManager.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface E_ReaderViewController ()<E_ReaderViewDelegate>
{
//    E_ReaderView *_readerView;
    
}

@end

@implementation E_ReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _readerView = [[E_ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y, self.view.frame.size.width - 2 * offSet_x, self.view.frame.size.height - offSet_y - 30)];
    _readerView.keyWord = _keyWord;
    _readerView.magnifiterImage = _themeBgImage;
    _readerView.delegate = self;
    [self.view addSubview:_readerView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(ScreenWidth/2, 0, (ScreenWidth - 40)/2, 40);
    _nameLabel.font = Font14;
    _nameLabel.textColor = LightTextColor;
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.text = _bookName;
    [self.view addSubview:_nameLabel];
    
    _chapterNameLabel = [[UILabel alloc] init];
    _chapterNameLabel.frame = CGRectMake(20, 0, (ScreenWidth - 40)/2, 40);
    _chapterNameLabel.font = Font14;
    _chapterNameLabel.textColor = LightTextColor;
    _chapterNameLabel.textAlignment = NSTextAlignmentLeft;
    _chapterNameLabel.text = _chapterTitle;
    [self.view addSubview:_chapterNameLabel];
    
    _progressLabel = [[UILabel alloc] init];
    _progressLabel.frame = CGRectMake(20, ScreenHeight - 25, 100, 20);
    _progressLabel.font = Font14;
    _progressLabel.textColor = LightTextColor;
    _progressLabel.textAlignment = NSTextAlignmentLeft;
 
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%%",_progressRatio * 100];

    
 
    [self.view addSubview:_progressLabel];
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    _electricLabel = [[UILabel alloc] init];
    _electricLabel.frame = CGRectMake(ScreenWidth - 100 - 20, ScreenHeight - 25, 100, 20);
    _electricLabel.font = Font14;
    _electricLabel.textColor = LightTextColor;
    _electricLabel.textAlignment = NSTextAlignmentRight;
    _electricLabel.text = locationString;
    [self.view addSubview:_electricLabel];
    
}

#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo{
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
}

- (void)ciBa:(NSString *)ciBaString{

    [_delegate ciBaWithString:ciBaString];
}

- (void)hideSettingToolBar{
    [_delegate hideTheSettingBar];
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
    if (_isNightText) {
        _readerView.isNightTextColor = YES;
    } else {
        _readerView.isNightTextColor = NO;
    }
   
    [_readerView render];
}


- (NSUInteger )font
{
    return _readerView.font;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}
@end
