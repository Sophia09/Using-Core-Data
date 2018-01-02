//
//  AddWordViewController.h
//  Using Core Data
//
//  Created by thinkit  on 7/28/14.
//
//

#import <UIKit/UIKit.h>
#import "Word+CoreDataClass.h"

@class AddWordViewController;
typedef void (^AddWordViewControllerCompletionHandler)(AddWordViewController *sender, BOOL canceled);

@interface AddWordViewController : UIViewController
{
    @private
    AddWordViewControllerCompletionHandler _completionHandler;
    Word *_word;
}

@property (weak, nonatomic) IBOutlet UITextField *wordTextField;

@property (weak, nonatomic) IBOutlet UITextField *translationTextField;

+ (void)editWord:(Word *)word
inNavigationController:(UINavigationController *)navigationController
      completion:(AddWordViewControllerCompletionHandler)completionHandler;


- (id)initWithWord:(Word *)word completion:(AddWordViewControllerCompletionHandler)completionHandler;

@end
