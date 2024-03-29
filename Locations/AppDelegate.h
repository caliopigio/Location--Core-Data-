#import <UIKit/UIKit.h>

@interface AppDelegate: UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic)
        NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic)
        NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic)
        NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) UINavigationController *navigationController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end