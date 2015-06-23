//
//  ViewController.m
//  DisasterRecovery
//
//  Created by Michael Smith on 6/23/15.
//  Copyright (c) 2015 Michael Smith. All rights reserved.
//

#import "LogInViewController.h"
#import "MainViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController


#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        UIViewController *nextViewController = nil;
        nextViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self presentViewController:nextViewController animated:true completion:nil];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton);
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }else if ([PFUser currentUser]) {
        UIViewController *nextViewController = nil;
        nextViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self presentViewController:nextViewController animated:true completion:nil];
    }
    
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
