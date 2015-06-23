//
//  ViewController.h
//  DisasterRecovery
//
//  Created by Michael Smith on 6/23/15.
//  Copyright (c) 2015 Michael Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LogInViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;

@end

