//
//  JYS_SqlManager.h
//  Test
//
//  Created by ccp on 15/10/29.
//  Copyright © 2015年 com.devond. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DVCoreDataManager : NSObject
{
    @private
    dispatch_queue_t opeartionQueue;
}

@property (nonatomic,strong,readonly)NSManagedObjectContext *managerObjectContext;
@property (nonatomic,strong,readonly)NSManagedObjectContext *asyncManagerContext;


+ (nullable DVCoreDataManager *)sharedManager;

/*
 *  初始化数据库
 */
- (BOOL)initDataBaseWithUserID:(NSString *)userId;

/*
 *  CoreData 查询操作
 */
- (nullable __kindof NSManagedObject  *)FetchEntitysWithName:(nonnull NSString *)name entityId:(NSString *)entityId;
- (nullable NSArray<__kindof NSManagedObject *> *)FetchAllEntityWithName:(nonnull NSString *)name ascending:(BOOL)asc;

/*
 *  CoreData 插入操作
 */
- (nullable __kindof NSManagedObject *)insertEntityWithName:(nonnull NSString *)name;

/*
 *  上下文保存更改
 */
- (void)save;

/*
 *  删除操作
 */
- (void)deleteObject:(__kindof NSManagedObject *)object;
- (void)deleteArray:(NSArray <NSManagedObject *> *)array;


// asynic operation in managerContext
- (nullable __kindof NSManagedObject  *)asyncFetchEntitysWithName:(nonnull NSString *)name entityId:(NSString *)entityId;
- (nullable NSArray<__kindof NSManagedObject *> *)asyncFetchAllEntityWithName:(nonnull NSString *)name ascending:(BOOL)asc;

- (nullable __kindof NSManagedObject *)asyncInsertEntityWithName:(nonnull NSString *)name;

- (void)asyncSave;

/*
 *  删除操作
 */
- (void)asynDeleteObject:(__kindof NSManagedObject *)object;
- (void)asynDeleteArray:(NSArray <NSManagedObject *> *)array;



- (void)asyncExcuteWithBlock:(void(^)())block completion:(void(^)())completion;

/**
 
 */
- (NSArray *)queryAllDataWithClassName:(NSString *)className andPredicate:(NSString *)predicate;
@end
