#import "Event.h"
#import "RootViewController.h"

@implementation RootViewController

@synthesize eventsArray = _eventsArray,
        managedObjectContext = _managedObjectContext, addButton = _addButton,
            locationManager = _locationManager;

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Locations"];
    [[self tableView] setAllowsSelection:NO];
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    
    [_addButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:_addButton];
    [[self locationManager] startUpdatingLocation];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
            inManagedObjectContext:_managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
            initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors =
            [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [request setEntity:entity];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext
            executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        // Handle the error
    }
    [self setEventsArray:mutableFetchResults];
}

- (void)viewDidUnload
{
    _eventsArray = nil;
    _locationManager = nil;
    _addButton = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:
        (UIInterfaceOrientation)interfaceOrientation
{
    [[self tableView] reloadData];    
    return YES;
}

#pragma mark -
#pragma mark RootViewController

- (CLLocationManager *)locationManager
{
    if (_locationManager != nil) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    return _locationManager;
}

- (void)addEvent
{
    CLLocation *location = [_locationManager location];
    
    if (!location) {
        return;
    }
    Event *event = (Event *)[NSEntityDescription
            insertNewObjectForEntityForName:@"Event"
                inManagedObjectContext:_managedObjectContext];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
    [event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
    [event setCreationDate:[NSDate date]];
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        // Handle the error
    }
    [_eventsArray insertObject:event atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] scrollToRowAtIndexPath:indexPath
                atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [_eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormater = nil;
    
    if (dateFormater == nil) {
        dateFormater = [[NSDateFormatter alloc] init];
        
        [dateFormater setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormater setDateStyle:NSDateFormatterMediumStyle];
    }
    static NSNumberFormatter *numberFormater = nil;
    if (numberFormater == nil) {
        numberFormater = [[NSNumberFormatter alloc] init];
        
        [numberFormater setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormater setMaximumFractionDigits:3];
    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Event *event = (Event *)[_eventsArray objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:
            [dateFormater stringFromDate:[event creationDate]]];
    
    NSString *string = [NSString stringWithFormat:@"%@, %@",
            [numberFormater stringFromNumber:[event latitude]],
            [numberFormater stringFromNumber:[event longitude]]];
    
    [[cell detailTextLabel] setText:string];
    return cell;
}

- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *eventToDelete =
                [_eventsArray objectAtIndex:indexPath.row];
        
        [_eventsArray removeObjectAtIndex:indexPath.row];
        [_managedObjectContext deleteObject:eventToDelete];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                withRowAnimation:UITableViewRowAnimationFade];
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            // Handle the error
        }
    }   
}

#pragma mark -
#pragma mark <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_addButton setEnabled:YES];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_addButton setEnabled:NO];
}
@end