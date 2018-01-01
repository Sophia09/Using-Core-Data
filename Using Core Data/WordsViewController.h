//
//  WordsViewController.h
//  Using Core Data
//
//  Created by thinkit  on 7/28/14.
//
//

#import <UIKit/UIKit.h>

#import "Vocabulary.h"
#import "Word.h"

@interface WordsViewController : UITableViewController

@property (strong, nonatomic) Vocabulary *vocabulary;

- (id)initWithVocabulary:(Vocabulary *)vocabulary;

@end
