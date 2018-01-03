//
//  AddWordViewController.m
//  Using Core Data
//
//  Created by thinkit  on 7/28/14.
//
//

#import "AddWordViewController.h"

@interface AddWordViewController ()

@property (nonatomic, strong) AddWordViewControllerCompletionHandler completionHandler;
@property (nonatomic, strong) Word *word;

@end

@implementation AddWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Add Word";
    self.wordTextField.text = _word.word;
    self.translationTextField.text = _word.translation;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)editWord:(Word *)word
inNavigationController:(UINavigationController *)navigationController
      completion:(AddWordViewControllerCompletionHandler)completionHandler
{
    AddWordViewController *addWordViewController = [[AddWordViewController alloc] initWithWord:word completion:completionHandler];
    [navigationController pushViewController:addWordViewController animated:YES];
}

- (id)initWithWord:(Word *)word completion:(AddWordViewControllerCompletionHandler)completionHandler
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _word = word;
        _completionHandler = completionHandler;
    }
    return self;
}

#pragma mark - Helper method

- (void)done
{
    _word.word = self.wordTextField.text;
    _word.translation = self.translationTextField.text;
    _completionHandler(self, NO);
}

- (void)cancel
{
    _completionHandler(self, YES);
}


@end
