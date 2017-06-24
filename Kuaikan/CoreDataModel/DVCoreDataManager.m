//
//  JYS_SqlManager.m
//  Test
//
//  Created by ccp on 15/10/29.
//  Copyright © 2015年 com.devond. All rights reserved.
//

#import "DVCoreDataManager.h"

@implementation DVCoreDataManager
+ (DVCoreDataManager *)sharedManager
{
    static DVCoreDataManager *sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        opeartionQueue = dispatch_queue_create("DBOPERATION",DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}

- (BOOL)initDataBaseWithUserID:(NSString *)userId
{
    _managerObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    _asyncManagerContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_asyncManagerContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Kuaikan" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:momURL];
    self.managerObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    _asyncManagerContext.persistentStoreCoordinator = self.managerObjectContext.persistentStoreCoordinator;
    NSString *docs = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:userId];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    BOOL createDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:docs withIntermediateDirectories:YES attributes:nil error:nil];
    if(!createDirectory)
    {
        return NO;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"KuaikanDB.sqlite"]];
    NSError *error = nil;
    NSPersistentStore *store = [self.managerObjectContext.persistentStoreCoordinator persistentStoreForURL:url];
    if(![self.managerObjectContext.persistentStoreCoordinator.persistentStores containsObject:store])
    {
        store = [self.managerObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
    }
    if (store == nil) { // 直接抛异常
        return NO;
    }
    return YES;
    
}

#pragma - mark  Fetch Operation
- (nullable __kindof NSManagedObject  *)FetchEntitysWithName:(nonnull NSString *)name entityId:(NSString *)entityId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managerObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entityid == %@",entityId];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray<__kindof NSManagedObject *> *array = [self.managerObjectContext executeFetchRequest:fetchRequest error:&error];
    return  [array firstObject];
}

- (nullable NSArray<__kindof NSManagedObject *> *)FetchAllEntityWithName:(nonnull NSString *)name ascending:(BOOL)asc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managerObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"entityid" ascending:asc];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray<__kindof NSManagedObject *> *array = [self.managerObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return  array;
}


/**
 *  查询所有记录
 */
- (NSArray *)queryAllDataWithClassName:(NSString *)className andPredicate:(NSString *)predicate
{
    // 1. 实例化一个查询(Fetch)请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    
    // 3. 条件查询，通过谓词来实现的
    //    request.predicate = [NSPredicate predicateWithFormat:@"age < 60 && name LIKE '*五'"];
    // 在谓词中CONTAINS类似于数据库的 LIKE '%王%'
    if (predicate&&predicate.length) {
        request.predicate = [NSPredicate predicateWithFormat:predicate];
    }
    // 如果要通过key path查询字段，需要使用%K
    //    request.predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS '1'", @"phoneNo"];
    // 直接查询字表中的条件
    // 2. 让_context执行查询数据
    NSArray *array = [self.managerObjectContext  executeFetchRequest:request error:nil];
    return array;
}



#pragma - mark Insert Operation
- (nullable __kindof NSManagedObject *)insertEntityWithName:(nonnull NSString *)name
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managerObjectContext];
    return object;
}


#pragma - mark CoreData saveData
- (void)save
{
    NSError *error = nil;
    @try {
        [self.managerObjectContext save:&error];
        if(error)
        {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)deleteObject:(__kindof NSManagedObject *)object
{
    [self.managerObjectContext deleteObject:object];
}

- (void)deleteArray:(NSArray <NSManagedObject *> *)array
{
    for(__kindof NSManagedObject *object in array)
    {
        [self.managerObjectContext deleteObject:object];
    }
}


#pragma - mark async Operation
- (nullable __kindof NSManagedObject  *)asyncFetchEntitysWithName:(nonnull NSString *)name entityId:(NSString *)entityId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.asyncManagerContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entityid == %@",entityId];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray<__kindof NSManagedObject *> *array = [self.asyncManagerContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return  [array firstObject];
    
}


- (nullable NSArray<__kindof NSManagedObject *> *)asyncFetchAllEntityWithName:(nonnull NSString *)name ascending:(BOOL)asc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managerObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"entityid" ascending:asc];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray<__kindof NSManagedObject *> *array = [self.asyncManagerContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    return  array;
}

- (nullable __kindof NSManagedObject *)asyncInsertEntityWithName:(nonnull NSString *)name
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.asyncManagerContext];
    return object;
}


- (void)mocDidSaveNotification:(NSNotification *)notification
{
    [self.managerObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void)asyncSave
{
    
    NSError *error = nil;
    [self.asyncManagerContext save:&error];
    if(error)
    {
//        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
}

/*
 *  删除操作
 */
- (void)asynDeleteObject:(__kindof NSManagedObject *)object
{
    [self.asyncManagerContext deleteObject:object];
}
- (void)asynDeleteArray:(NSArray <NSManagedObject *> *)array
{
    for(__kindof NSManagedObject *object in array)
    {
        [self.asyncManagerContext deleteObject:object];
    }
}

- (void)asyncExcuteWithBlock:(void(^)())block completion:(void(^)())completion
{
    
//        if ([NSThread currentThread].isMainThread) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                block();
//                [self asyncSave];
//            });
//        } else {
//            block();
//            [self save];
//        }
    

    dispatch_async(opeartionQueue, ^{
        block();
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
    
    
}
@end
