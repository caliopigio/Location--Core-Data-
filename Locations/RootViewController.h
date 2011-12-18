#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController: UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIBarButtonItem *addButton;

- (void)addEvent;
@end