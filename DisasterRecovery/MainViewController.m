//
//  MainAppViewController.m
//
//
//  Created by Michael Smith on 6/23/15.
//
//

#import "MainViewController.h"
#import "ListTableViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

#pragma mark - UIViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
         self.title = NSLocalizedString(@"Red Pill or Blue Pill", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
   
    
                                               
}

-(IBAction)onAnimatoSelect:(id)sender{
    
    UIViewController *tableViewController = nil;
    tableViewController = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    [self presentViewController:tableViewController animated:true completion:nil];
    
}
-(IBAction)onClientSelect:(id)sender{
    
}
-(IBAction)onUserSelect:(id)sender{
    
}
-(IBAction)onOnCallSelect:(id)sender{
    
}

@end
