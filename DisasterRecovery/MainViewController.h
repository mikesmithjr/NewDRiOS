//
//  MainViewController.h
//  DisasterRecovery
//
//  Created by Michael Smith on 6/23/15.
//  Copyright (c) 2015 Michael Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface MainViewController : UIViewController
{
    NSString *dbPath;
    NSString *fullPath;
    sqlite3 *dbContext;
    NSMutableArray *allUserArray;
    NSMutableArray *animatoUserArray;
    NSMutableArray *clientUserArray;
    NSMutableArray *remainingUserArray;
    NSMutableArray *onCallUserArray;
    NSArray *resultsArrayUser;
    NSArray *resultsArrayContact;
}

@property(nonatomic,strong)NSMutableArray *allUserArray;
@property(nonatomic,strong)NSMutableArray *animatoUserArray;
@property(nonatomic,strong)NSMutableArray *clientUserArray;
@property(nonatomic,strong)NSMutableArray *remainingUserArray;
@property(nonatomic,strong)NSMutableArray *onCallUserArray;

-(IBAction)onAnimatoSelect:(id)sender;
-(IBAction)onClientSelect:(id)sender;
-(IBAction)onUserSelect:(id)sender;
-(IBAction)onOnCallSelect:(id)sender;
@end
