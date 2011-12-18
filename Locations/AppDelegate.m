#import "RootViewController.h"
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window, managedObjectContext = __managedObjectContext,
        managedObjectModel = __managedObjectModel,
            persistentStoreCoordinator = __persistentStoreCoordinator,
            navigationController = _navigationController;

#pragma mark -
#pragma mark AppDelegate

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator =
            [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Locations"
            withExtension:@"momd"];
    __managedObjectModel =
            [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory]
            URLByAppendingPathComponent:@"Locations.sqlite"];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:
            NSSQLiteStoreType configuration:nil URL:storeURL options:nil
                error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    return __persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = __managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] &&
                ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
            inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark <UIApplicationDelegate>

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController *rootViewController = [[RootViewController alloc] 
            initWithStyle:UITableViewStylePlain];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context) {
        // Handle the error
    }
    [rootViewController setManagedObjectContext:context];
    
    UINavigationController *aNavigationController =
            [[UINavigationController alloc]
                initWithRootViewController:rootViewController];
    
    [self setNavigationController:aNavigationController];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [_window addSubview:[_navigationController view]];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}
@end