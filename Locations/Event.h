#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Event: NSManagedObject

@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@end