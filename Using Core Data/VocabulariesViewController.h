//
//  VocabulariesViewController.h
//  Using Core Data
//
//  Created by thinkit  on 7/25/14.
//
//

#import <UIKit/UIKit.h>

@interface VocabulariesViewController : UITableViewController <UIAlertViewDelegate>

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;


@end
