//
//  ViewController.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-30.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"LnuChat"];
    
    [[UIView appearance] setTintColor:k_mainColor];
    UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newback];
    [self.navigationController.navigationBar setTintColor:k_mainColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.alpha = 0;
    
    //LEFT NAVIGATIONBAR BUTTON
    UIImage *image = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuButton)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    //Right NAVIGATIONBAR BUTTON
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RIGHTNAVBARBUTTON", @"Create room") style:UIBarButtonItemStyleDone target:self action:@selector(CreateRoomFirst)];
    [rightBtn setTitleTextAttributes:@{   NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:15],
                                          NSForegroundColorAttributeName: k_mainColor
                                          } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [TopicsCell setTableViewWidth:self.view.frame.size.width];
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = k_lightGray;
    self.table.alpha = 0;
    [self.table setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.view addSubview:self.table];
    

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self changingTitleLabel];
    });
    
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(queryRooms)
                forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshController];
    
    
    
    [[PFUser currentUser] fetchInBackground]; //Updates user information
}
/*
 Animates Navigation TitleView
 */
-(void)changingTitleLabel {
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    [UIView animateWithDuration:0.5
                          delay:0.0f
                        options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         titleView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished) {
                         if ([titleView.text isEqualToString:@"LnuChat"]) {
                             [self setTitle:NSLocalizedString(@"ROOM", @"Room")];
                         } else {
                             [self setTitle:@"LnuChat"];
                         }
                         [UIView beginAnimations:nil context:nil];
                         [UIView setAnimationDuration:0.5];
                         [UIView setAnimationDelay:0];
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                         titleView.alpha = 1;
                         [UIView commitAnimations];
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [self changingTitleLabel];
                         });
                     }];
}

-(void)viewDidAppear:(BOOL)animated {
    // Changing the tint back after being in another room
    [self.navigationController.navigationBar setTintColor:k_mainColor];
    [[UIView appearance] setTintColor:k_mainColor];
    /*
     Checking if user is logged in or not
     Presenting loginview if user is not logged in.
     */
    
    if (![PFUser currentUser]) {
        Login *viewcontroller = [Login alloc];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
        [self presentViewController:nav animated:NO completion:nil];
    } else {
        [TopicsCell setTableViewWidth:self.view.frame.size.width];
        [self queryRooms];
    }
}


-(void)initialViewLoad {

    [self.table reloadData];
    [refreshController endRefreshing];
    if (self.table.alpha == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.table.alpha = 1;
        self.navigationController.navigationBar.alpha = 1;
        [UIView commitAnimations];
    }

}

-(void)queryRooms {
    /*
     Loops thrue query 2 times, first time for Cached data
     second time querys database data.
     We need to keep track of whatQuert it is.
     */
    [[PFUser currentUser] fetchInBackground];
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRooms"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    __block int whatQuery = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            tableArray  = [[NSMutableArray alloc] initWithArray:objects];
            
            // If has cached data, show tableview. If no cached data wait until data is loaded.
            if ((tableArray.count != 0 && whatQuery != 2) || (tableArray.count != 0 && whatQuery == 2))
                [self initialViewLoad];
            
            
            [self.table reloadData];
            whatQuery = whatQuery + 1;
        }
        else
        {
            
            //Dont want to show error if its because user has no cached data.
            if (whatQuery == 2) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ERROR", @"Something went wrong")];
            }
            whatQuery = whatQuery + 1;
            [ErrorHandler handleParseError:error];
        }
        
    }];
    
}

-(void)leftMenuButton {
    NSString *message;
    if ([ErrorHandler hasAdminRights]) {
        message = [NSString stringWithFormat:[NSString stringWithFormat:@"%@ %@\n%@",NSLocalizedString(@"LOGGEDINAS", @"Logged in as: "), [PFUser currentUser][@"name"], NSLocalizedString(@"HASADMINRIGHTS", @"Has admin rights")]];
    }else {
       message = [NSString stringWithFormat:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LOGGEDINAS", @"Logged in as: "), [PFUser currentUser][@"name"]]];
    }
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"MENUHEADER", @"What do you want to do?")
                                  message:message
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* settings = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"SETTINGS", @"Settings")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   Settings *vc = [[Settings alloc] init];
                                   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                   [self presentViewController:nav animated:YES completion:nil];
                                   
                               }];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"LOGOUT", @"Logout")
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             
                             UIAlertController * Lalert=   [UIAlertController
                                                            alertControllerWithTitle:NSLocalizedString(@"LOGOUT", @"Logout")
                                                            message:NSLocalizedString(@"SURELOGOUT", @"Are you sure?")
                                                            preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* logout = [UIAlertAction
                                                      actionWithTitle:NSLocalizedString(@"LOGOUT", @"Logout")
                                                      style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                          
                                                          
                                                          PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                          [currentInstallation removeObjectForKey:@"Username"];
                                                          [currentInstallation saveInBackground];
                                                          [PFQuery clearAllCachedResults];
                                                          [PFUser logOut];
                                                          Login *vc = [[Login alloc] init];
                                                          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                          [self presentViewController:nav animated:YES completion:nil];
                                                      }];
                             UIAlertAction* cancel2 = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
                             [Lalert addAction:cancel2];
                             [Lalert addAction:logout];
                             [self presentViewController:Lalert animated:YES completion:nil];
                             
                         }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:settings];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma EXTRAS

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView setFont:k_midfont];
        titleView.textColor = k_mainColor;
        titleView.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

#pragma mark - Tablesetup

//------Tableview setup

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    { case 0:
        {
            return [tableArray count];
        }
        default: return nil;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell * cell = [self customCellForIndex:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            object = [tableArray objectAtIndex:indexPath.row];
            [(TopicsCell *)cell  configureTextForCell:object];
            
            return cell;
            
        }
            
        default: return nil;
    }
    
    
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = Identifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [TopicsCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0;
    
    cellHeight += [TopicsCell cellHeight:object];
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    object = [tableArray objectAtIndex:indexPath.row];
    Room *viewController = [[Room alloc] init];
    viewController.Roomobject = object;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)CreateRoomFirst {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"CREATEROOM", @"")
                                  message:NSLocalizedString(@"CREATEROOMDETAILED", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"ROOMPLACEHOLDER", @"");
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        [textField addTarget:self
                      action:@selector(alertTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"ROOMDESCRIPTION", @"");
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        [textField addTarget:self
                      action:@selector(alertTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"CREATE", @"Create")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             

                             if ([alert textFields].firstObject.text.length > 0 && [alert textFields].lastObject.text.length > 0) {
                    
                             UIAlertController * alert2=   [UIAlertController
                                                           alertControllerWithTitle:NSLocalizedString(@"ROOMTYPE", @"")
                                                           message:NSLocalizedString(@"ROOMTYPEDESCRIPTION", @"")
                                                           preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* ok2 = [UIAlertAction
                                                  actionWithTitle:NSLocalizedString(@"OPENFORALL", @"")
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                                                  {
                                                      [self CreateRoom:[alert textFields].firstObject.text :[alert textFields].lastObject.text];
                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                }];
                             UIAlertAction* closed = [UIAlertAction
                                                      actionWithTitle:NSLocalizedString(@"ONLYINVITE", @"")
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                           [self UserQuery:[alert textFields].firstObject.text :[alert textFields].lastObject.text];
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
                             [alert2 addAction:closed];
                             [alert2 addAction:ok2];
                             [self presentViewController:alert2 animated:YES completion:nil];
                                 
                             } else {
                                 [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"FIELDSEMPTY", @"")];
                             }
                         }];
    ok.enabled = NO;
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

-(void)CreateRoom:(NSString *)name :(NSString *)details {
    [SVProgressHUD show];
    [PFCloud callFunctionInBackground:@"CreateRoom"
                       withParameters:@{ @"Roomname": name,
                                         @"RoomDetails": details
                                         }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        [SVProgressHUD showSuccessWithStatus:result];
                                        [self queryRooms];
                                        
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                        
                                    }
                                }];
    
}

-(void)UserQuery:(NSString *)name :(NSString *)description {
    NSLog(@"Current user: %@", [PFUser currentUser].username);
    [SVProgressHUD show];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count != 0) {
                UserTable *vc = [[UserTable alloc] init];
                vc.whatView = 1;
                vc.usersArray = objects;
                vc.roomdescription = description;
                vc.name = name;
                vc.color = k_mainColor;
                [SVProgressHUD dismiss];
                [self.navigationController pushViewController:vc animated:YES];
            } else {

            }
        }
        
    }];
    
}

- (void)alertTextFieldDidChange:(UITextField *)sender {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    UIAlertAction *okAction = alertController.actions.lastObject;
    
    if (alertController.textFields.firstObject.text.length >= 3 && alertController.textFields.lastObject.text.length >= 3)
        okAction.enabled = YES;
    else
        okAction.enabled = NO;
}




@end
