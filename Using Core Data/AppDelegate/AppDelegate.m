//
//  AppDelegate.m
//  Using Core Data
//
//  Created by thinkit  on 7/25/14.
//
//

#import "AppDelegate.h"

@interface AppDelegate()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *mainMOC;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *backgroundMOC;
    
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Create and display the view controller in a navigation controller
    self.vocabulariesViewController = [[VocabulariesViewController alloc] initWithManagedObjectContext:self.mainMOC];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.vocabulariesViewController];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveBackgroungContext];
    [self saveMainContext];
}

- (void)saveMainContext
{
    NSError *error = nil;
    NSManagedObjectContext *mainMOC = self.mainMOC;
    if (mainMOC != nil) {
        if ([mainMOC hasChanges] && ![mainMOC save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)saveBackgroungContext {
    if (_backgroundMOC) {
        [_backgroundMOC performBlock:^{
            NSError *error;
            if ([_backgroundMOC hasChanges] && [_backgroundMOC save:&error]) {
                [_mainMOC performBlock:^{
                    [self saveMainContext];
                }];
            }
        }];
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)mainMOC
{
    if (_mainMOC != nil) {
        return _mainMOC;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainMOC setPersistentStoreCoordinator:coordinator];
    }
    return _mainMOC;
}

// 私有队列用以执行耗时操作
- (NSManagedObjectContext *)backgroundMOC {

    _backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundMOC.parentContext = _mainMOC;
    return _backgroundMOC;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Using_Core_Data" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    [self copyDefaultSqlite];
    
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Using_Core_Data.sqlite"];
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    /* Core Data does a few things:
     1. analyze store's model version
     2. compare store's model version & coordinate's model version
     3. if they do not match, do work for migration
     
     solution 1 & 2 are both manual migation
     */
    // begin of solution 1
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES)
                              
                              };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        abort();
    }
 
    // begin of solution 2
/*
    if ([self isMannualMigrationNecessaryForStore:storeURL])
    {
        // data migation
        [self migrateStore:storeURL];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:nil
                                             URL:storeURL
                                                        options:nil
                                           error:&error];
     
    }
    else {
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption : @(YES),
                                  NSInferMappingModelAutomaticallyOption : @(YES)
                                  
                                  };
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            abort();
        }
    }
  */
    return _persistentStoreCoordinator;
}

- (BOOL)isMannualMigrationNecessaryForStore:(NSURL*)storeUrl
{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeUrl.path])
    {
        NSLog(@"SKIPPED MIGRATION: Source database missing.");
        return NO;
    }
    
    NSError *error = nil;
    NSDictionary *sourceMetadata =
    [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                               URL:storeUrl error:&error];
    NSManagedObjectModel *destinationModel = self.managedObjectModel;
    
    if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata])
    {
        NSLog(@"SKIPPED MIGRATION: Source is already compatible");
        return NO;
    }
    
    return YES;
}


// copy default database from bundle to documents directory if there is no database file in documents
- (void)copyDefaultSqlite {
    NSError *error;
    NSString *destinationSqlite = [[self documentsDirectoryString] stringByAppendingPathComponent:@"Using_Core_Data.sqlite"];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:destinationSqlite];
    if (!fileExist) {
        NSString *sourceSqlite = [[NSBundle mainBundle] pathForResource:@"Using_Core_Data"
                                                                 ofType:@"sqlite"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:sourceSqlite]) {
            // copy default sqlite file to documents directory
            [[NSFileManager defaultManager] copyItemAtPath:sourceSqlite
                                                    toPath:destinationSqlite
                                                     error:&error];
        }
    }
}

- (BOOL)migrateStore:(NSURL*)sourceStore {
    
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    BOOL success = NO;
    NSError *error = nil;
    
    // STEP 1 - 收集 Source源实体, Destination目标实体 和 Mapping Model文件
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator
                                    metadataForPersistentStoreOfType:NSSQLiteStoreType
                                    URL:sourceStore
                                    error:&error];
    
    NSManagedObjectModel *sourceModel =
    [NSManagedObjectModel mergedModelFromBundles:nil
                                forStoreMetadata:sourceMetadata];
    
    NSManagedObjectModel *destinModel = [self managedObjectModel];
   
    NSMappingModel *mappingModel =
    [NSMappingModel mappingModelFromBundles:nil
                             forSourceModel:sourceModel
                           destinationModel:destinModel];

    
    // STEP 2 - 开始执行 migration合并, 前提是 mapping model 不是空，或者存在
    if (mappingModel) {
        NSError *error = nil;
        NSMigrationManager *migrationManager =
        [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                       destinationModel:destinModel];
        [migrationManager addObserver:self
                           forKeyPath:@"migrationProgress"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
        
        NSURL *destinStore =
        [[self applicationDocumentsDirectory]
         URLByAppendingPathComponent:@"Temp.sqlite"];
        
        success =
        [migrationManager migrateStoreFromURL:sourceStore
                                         type:NSSQLiteStoreType options:nil
                             withMappingModel:mappingModel
                             toDestinationURL:destinStore
                              destinationType:NSSQLiteStoreType
                           destinationOptions:nil
                                        error:&error];
        if (success)
        {
            // STEP 3 - 用新的migrated store替换老的store
            if ([self replaceStore:sourceStore withStore:destinStore])
            {
                NSLog(@"SUCCESSFULLY MIGRATED %@ to the Current Model",
                      sourceStore.path);
                [migrationManager removeObserver:self
                                      forKeyPath:@"migrationProgress"];
            }
        }
        else
        {
            NSLog(@"FAILED MIGRATION: %@",error);
        }
    }
    else
    {
        NSLog(@"FAILED MIGRATION: Mapping Model is null");
    }
    
    return YES; // migration已经完成
}

- (BOOL)replaceStore:(NSURL *)sourceStore withStore:(NSURL *)destinationStore {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:sourceStore error:&error];
    [[NSFileManager defaultManager] moveItemAtURL:destinationStore
                                            toURL:sourceStore error:&error];
    return YES;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)documentsDirectoryString {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

@end
