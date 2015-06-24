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

@synthesize allUserArray;
@synthesize animatoUserArray;
@synthesize clientUserArray;
@synthesize remainingUserArray;
@synthesize onCallUserArray;

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
    
    NSURL *userUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.parse.com/1/classes/_User"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userUrl];
    NSLog(@"%@", userUrl);
    [request setURL:userUrl];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"M8qXaArTODB4C7fUe4BBOeb08NxOZWRNUj4iuoUL" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:@"R5doxM9TuhnaeASVLK9l1c8a8h6hA7ktYTqWL8iv" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:0 error:&error];
    resultsArrayUser = [jsonDictionary objectForKey:@"results"];
    NSLog(@"Results Array User: %@", resultsArrayUser);
    for (NSDictionary *dictionaryName in resultsArrayUser) {
        NSString *name = [dictionaryName objectForKey:@"username"];
        NSLog(@"Request: %@", name);
    }
    
    NSURL *contactUrl = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.parse.com/1/classes/Contacts"]];
    NSMutableURLRequest *contactRequest = [NSMutableURLRequest requestWithURL:contactUrl];
    NSLog(@"%@", contactUrl);
    [contactRequest setURL:contactUrl];
    [contactRequest setHTTPMethod:@"GET"];
    [contactRequest setValue:@"M8qXaArTODB4C7fUe4BBOeb08NxOZWRNUj4iuoUL" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [contactRequest setValue:@"R5doxM9TuhnaeASVLK9l1c8a8h6hA7ktYTqWL8iv" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSError *contactError;
    
    NSDictionary *jsonDictionaryContacts = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:contactRequest returningResponse:nil error:nil]  options:0 error:&contactError];
    resultsArrayContact = [jsonDictionaryContacts objectForKey:@"results"];
    NSLog(@"Results Array Contact: %@", resultsArrayContact);
    for (NSDictionary *dictionaryContactName in resultsArrayContact) {
        NSString *name = [dictionaryContactName objectForKey:@"user"];
        NSLog(@"Request: %@", name);
    }
    
                                               
}
- (void)localDB
{
    if (resultsArray != nil) {
        
        
        NSArray *dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        if(dirpaths != nil)
        {
            NSString *documentsDirectory = [dirpaths objectAtIndex:0];
            NSString *dbName = @"planes.db";
            dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
            NSLog(@"path=%@", dbPath);
            BOOL fileThere = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            const char *databasePath = [dbPath UTF8String];
            if (fileThere) {
                NSLog(@"File There");
                if (sqlite3_open(databasePath, &dbContext) == SQLITE_OK) {
                    const char *selectStatement = "SELECT * FROM PLANE_TABLE";
                    sqlite3_stmt *compiledSelectStatement;
                    
                    if (sqlite3_prepare_v2(dbContext, selectStatement, -1, &compiledSelectStatement, NULL) == SQLITE_OK)
                    {
                        planeArray = [[NSMutableArray alloc]init];
                        //ratingsArray = [[NSMutableArray alloc]init];
                        while (sqlite3_step(compiledSelectStatement) == SQLITE_ROW)
                        {
                            NSString *planeParseID = [[NSString alloc] initWithUTF8String:(const char *)
                                                      sqlite3_column_text(compiledSelectStatement, 1)];
                            NSString *planeParseName = [[NSString alloc] initWithUTF8String:(const char *)
                                                        sqlite3_column_text(compiledSelectStatement, 2)];
                            NSString *planeParseType = [[NSString alloc] initWithUTF8String:(const char *)
                                                        sqlite3_column_text(compiledSelectStatement, 3)];
                            NSString *planeParsePower = [[NSString alloc] initWithUTF8String:(const char *)
                                                         sqlite3_column_text(compiledSelectStatement, 4)];
                            int planeParseTime = sqlite3_column_int(compiledSelectStatement, 5);
                            NSString *planeParseCreated = [[NSString alloc] initWithUTF8String:(const char *)
                                                           sqlite3_column_text(compiledSelectStatement, 6)];
                            NSString *planeParseUpdated = [[NSString alloc] initWithUTF8String:(const char *)
                                                           sqlite3_column_text(compiledSelectStatement, 7)];
                            Plane *dbPlane = [[Plane alloc] initPlaneInfo:planeParseID planeName:planeParseName planeType:planeParseType planePowerSystem:planeParsePower planeFlightTime:planeParseTime planeCreatedAt:planeParseCreated planeLastUpdate:planeParseUpdated];
                            [planeArray addObject:dbPlane];
                            //[ratingsArray addObject:movieRating];
                            
                        }
                    }
                }
                
            }else{
                NSLog(@"File NOT There");
                const char *databasePath = [dbPath UTF8String];
                if (sqlite3_open(databasePath, &dbContext) == SQLITE_OK)
                {
                    //create table
                    const char *sqlTableStatement = "CREATE TABLE IF NOT EXISTS PLANE_TABLE (PLANEID INTEGER PRIMARY KEY AUTOINCREMENT, PARSEID TEXT, NAME TEXT, TYPE TEXT, POWER_TYPE TEXT, FLIGHT_TIME INTEGER, PARSE_CREATED TEXT, PARSE_UPDATED TEXT)";
                    char *error;
                    if (sqlite3_exec(dbContext, sqlTableStatement, NULL, NULL, &error) != SQLITE_OK)
                    {
                        
                    }
                    
                    NSLog(@"%@", [resultsArray description]);
                    
                    
                    NSLog(@"planes in array %lu", (unsigned long)[resultsArray count]);
                    for (int i=0; i<[resultsArray count]; i++)
                    {
                        NSString *planeParseID = [[resultsArray objectAtIndex:i] objectForKey:@"objectId"];
                        NSString *planeParseName = [[resultsArray objectAtIndex:i] objectForKey:@"Name"];
                        NSString *planeParseType = [[resultsArray objectAtIndex:i] objectForKey:@"Type"];
                        NSString *planeParsePower = [[resultsArray objectAtIndex:i] objectForKey:@"Power_type"];
                        int planeParseFlight = [[[resultsArray objectAtIndex:i] objectForKey:@"Flight_Time"] intValue];
                        NSString *planeParseCreated = [[resultsArray objectAtIndex:i] objectForKey:@"createdAt"];
                        NSString *planeParseUpdated = [[resultsArray objectAtIndex:i] objectForKey:@"updatedAt"];
                        
                        const char *dbplaneParseID = [planeParseID UTF8String];
                        const char *dbplaneParseName = [planeParseName UTF8String];
                        const char *dbplaneParseType = [planeParseType UTF8String];
                        const char *dbplaneParsePower = [planeParsePower UTF8String];
                        int dbplaneParseFlight = planeParseFlight;
                        const char *dbplaneParseCreated = [planeParseCreated UTF8String];
                        const char *dbplaneParseUpdated = [planeParseUpdated UTF8String];
                        
                        const char *insertStatement = "INSERT INTO PLANE_TABLE (PARSEID, NAME, TYPE, POWER_TYPE, FLIGHT_TIME, PARSE_CREATED, PARSE_UPDATED) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        
                        sqlite3_stmt *compiledInsertStatement;
                        
                        if (sqlite3_prepare_v2(dbContext, insertStatement, -1, &compiledInsertStatement, NULL) == SQLITE_OK)
                        {
                            sqlite3_bind_text(compiledInsertStatement, 1, dbplaneParseID, -1, NULL);
                            sqlite3_bind_text(compiledInsertStatement, 2, dbplaneParseName, -1, NULL);
                            sqlite3_bind_text(compiledInsertStatement, 3, dbplaneParseType, -1, NULL);
                            sqlite3_bind_text(compiledInsertStatement, 4, dbplaneParsePower, -1, NULL);
                            sqlite3_bind_int(compiledInsertStatement, 5, dbplaneParseFlight);
                            sqlite3_bind_text(compiledInsertStatement, 6, dbplaneParseCreated, -1, NULL);
                            sqlite3_bind_text(compiledInsertStatement, 7, dbplaneParseUpdated, -1, NULL);
                            if (sqlite3_step(compiledInsertStatement) == SQLITE_DONE)
                            {
                                sqlite3_finalize(compiledInsertStatement);
                            }
                        }
                    }
                    
                }
                
                
                //close db
                sqlite3_close(dbContext);
            }
            
        }
    }
    
    
}



-(IBAction)onAnimatoSelect:(id)sender{
    
    ListTableViewController *tableViewController = nil;
    tableViewController = [[ListTableViewController alloc] initWithStyle:UITableViewStylePlain className:@"Contacts"];
    [self presentViewController:tableViewController animated:true completion:nil];
    
}
-(IBAction)onClientSelect:(id)sender{
    
}
-(IBAction)onUserSelect:(id)sender{
    
}
-(IBAction)onOnCallSelect:(id)sender{
    
}

@end
