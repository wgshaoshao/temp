//
//  E_CommonManager.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_CommonManager.h"
#import "E_ContantFile.h"
#import "E_Mark.h"

@implementation E_CommonManager


+ (NSInteger)Manager_getReadTheme{
   
    NSString *themeID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVETHEME];
    
    if (themeID == nil) {
        
        return 1;
        
    }else{
        
        return [themeID integerValue];
    }
}


+ (void)saveCurrentThemeID:(NSInteger)currentThemeID{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentThemeID) forKey:SAVETHEME];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSUInteger)Manager_getPageBefore{
    
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVEPAGE];
    
    if (pageID == nil) {
        
        return 0;
        
    }else{
        
        return [pageID integerValue];
    }
}

+ (void)saveCurrentPage:(NSInteger)currentPage{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:SAVEPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (NSMutableDictionary *)Manager_getChapterBefore:(NSString *)bookID{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    JYS_SqlManager *dataManager = [JYS_SqlManager shareManager];
    BookInforModel *readRecord = [dataManager getBookWithBookId:bookID];
    if (readRecord != nil) {
        [dict setObject:readRecord.currentPageIndex forKey:@"currentPage"];
        [dict setObject:readRecord.chapterIndex forKey:@"chapterIndex"];
        [dict setObject:readRecord.bookid forKey:@"bookID"];
    }
    
    return dict;
}

+ (void)saveCurrentChapter:(NSInteger)currentChapter{
   
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];

}



+ (NSUInteger)fontSize
{
    NSUInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE];
    if (fontSize == 0) {
        fontSize = 18;
    }
    return fontSize;
}

+ (void)saveFontSize:(NSUInteger)fontSize
{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:FONT_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark- 书签保存

+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    E_Mark *eMark = [[E_Mark alloc] init];
    eMark.markRange = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%ld",(long)currentChapter];
    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    
    
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self getBookID]];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:[self getBookID]];
            
        }else{
        
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:[self getBookID]];
        }
       
       [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self getBookID]];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
           
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) && (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) && ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentChapter]])) {
        
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:[self getBookID]];
                
            }
        }
    }
    
}

+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self getBookID]];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        int k = 0;
        for (int i = 0; i < oldSaveArray.count; i ++) {
             E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
            
            if ((NSRangeFromString(e.markRange).location >= currentRange.location) && (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) && [e.markChapter isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentChapter]]) {
                k++;
            }else{
               // k++;
            }
        }
        if (k >= 1) {
           return YES;
        }else{
           return NO;
        }
}

+ (NSMutableArray *)Manager_getMark{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self getBookID]];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
    
    }
}

+ (NSString *)getBookID{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *bookID = [userDefaults objectForKey:@"bookID"];
    
    if (!bookID) {
        bookID = @"";
    }
    
    return bookID;
}

@end