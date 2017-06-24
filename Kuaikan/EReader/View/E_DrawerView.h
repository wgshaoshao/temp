//
//  E_DrawerView.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/15.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E_ListView.h"
#import "E_Mark.h"

@protocol E_DrawerViewDelegate <NSObject>

- (void)openTapGes;
- (void)turnToClickChapter:(NSInteger)chapterIndex;
- (void)turnToClickChapterLastPate;
- (void)turnToClickMark:(E_Mark *)eMark;

@end

@interface E_DrawerView : UIView<UIGestureRecognizerDelegate,E_ListViewDelegate>{
    
    E_ListView *_listView;
}
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *parent;
@property (nonatomic, assign) NSInteger myIndex;
@property (nonatomic, strong) NSString *bookID;
@property(nonatomic, assign) id<E_DrawerViewDelegate>delegate;

- (void)configUI;


- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p;

@end
