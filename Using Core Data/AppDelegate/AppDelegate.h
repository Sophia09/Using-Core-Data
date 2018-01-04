//
//  AppDelegate.h
//  Using Core Data
//
//  Created by thinkit  on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import "VocabulariesViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) VocabulariesViewController *vocabulariesViewController;

- (void)saveMainContext;
- (void)saveBackgroungContext;
- (NSURL *)applicationDocumentsDirectory;

@end
