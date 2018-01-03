//
//  VocabulariesViewController.m
//  Using Core Data
//
//  Created by thinkit  on 7/25/14.
//
//

#import "VocabulariesViewController.h"
#import "Vocabulary+CoreDataClass.h"
#import "WordsViewController.h"
#import "AppDelegate.h"

@interface VocabulariesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end

@implementation VocabulariesViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.managedContext = context;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Vocabularies";
    [self fetchVovabularies];
    
    if ([self.fetchedResultsController.fetchedObjects count] == 0)
    {
        NSEntityDescription *vocabularyEntityDescriptor = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:self.managedContext];
        
        Vocabulary *spanishVocabulary = (Vocabulary *)[[NSManagedObject alloc] initWithEntity:vocabularyEntityDescriptor insertIntoManagedObjectContext:self.managedContext];
        [spanishVocabulary setName:@"Spanish"];
        
        [self saveContext];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
        self.navigationItem.rightBarButtonItem = addButton;
        
        [self fetchVovabularies];
    }
}

// Reload the data whenever the view appears
- (void)viewWillAppear:(BOOL)animated
{
    [self fetchVovabularies];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Vocabulary *vocabulary = (Vocabulary *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = vocabulary.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)", vocabulary.words.count];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObject *deleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedContext deleteObject:deleted];
        
        [self saveContext];
        [self fetchVovabularies];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vocabulary *vocabulary = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WordsViewController *detailViewController = [[WordsViewController alloc] initWithVocabulary:vocabulary];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - helper method

- (void)saveContext {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveMainContext];
}

// Fetch all vocabularies in the data model and stores them in the fetchedResultsController property
- (void)fetchVovabularies
{
    NSString *entityName = @"Vocabulary";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSString *cacheName = [entityName stringByAppendingString:@"Cache"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                     ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:self.managedContext sectionNameKeyPath:nil
                                                                                  cacheName:cacheName];
    // Complete the fetch request and retrieve the stored data
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Fetch failed: %@", error);
    }
}

- (void)add
{
    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:@"New Vocabulary"
                                                         message:@"Enter a name for the new vocabulary" delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [inputAlert show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSEntityDescription *vocabularyEntityDescription = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:self.managedContext];
        Vocabulary *newVocabulary = (Vocabulary *)[[NSManagedObject alloc] initWithEntity:vocabularyEntityDescription insertIntoManagedObjectContext:self.managedContext];
        newVocabulary.name = [alertView textFieldAtIndex:0].text;
        [self saveContext];
        [self fetchVovabularies];
        [self.tableView reloadData];
    }
}

@end
