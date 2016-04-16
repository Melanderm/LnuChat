//
//  Room.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-01.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "Room.h"


@interface Room ()




@end

@implementation Room

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hex  = _Roomobject[@"color"];
    color = [UIColorExpanded colorWithHexString:hex];
   
    [self setTitle:_Roomobject[@"RoomName"]];
    
    [[UIView appearance] setTintColor:color];
    UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newback];
    [self.navigationController.navigationBar setTintColor:color];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //Right NAVIGATIONBAR BUTTON
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ROOMLEFTNAV", @"Top") style:UIBarButtonItemStyleDone target:self action:@selector(toTheTop)];
    [rightBtn setTitleTextAttributes:@{   NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:15],
                                          NSForegroundColorAttributeName: color
                                          } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.alpha = 1;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    
    [DetailedRoomCell setTableViewWidth:self.view.frame.size.width];
    [ChatCell setTableViewWidth:self.view.frame.size.width];
    [SelfChatCell setTableViewWidth:self.view.frame.size.width];
    
    // Recognise tap on tableview to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.table addGestureRecognizer:tap];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchPushedMessage:) name:@"DidRecivePush" object:nil];
    
    
    [self setupMessage];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self getConverstaion];
    
}


-(void)getConverstaion {
    /*
     Loops thrue query 2 times, first time for Cached data
     second time querys database data.
     We need to keep track of whatQuert it is.
     */
    PFQuery *query = [PFQuery queryWithClassName:@"Conversations"];
    [query includeKey:@"Author"];
    [query includeKey:@"ChatRoom"];
    [query whereKey:@"ChatRoom" equalTo:_Roomobject];
    [query orderByAscending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    __block int whatQuery = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            
            tableArray  = [[NSMutableArray alloc] initWithArray:objects];
            [self.table reloadData];
            //Scrolling down tableview if it has cached data.
            if (whatQuery == 1  && tableArray.count > 0) {
                self.table.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40);
                NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
                [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            if (whatQuery == 2) {
                if (tableArray.count > 0) {
                    self.table.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40);
                    NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
                    [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    [label removeFromSuperview];
                } else {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height-20)/2, self.view.bounds.size.width, 20)];
                    label.text = NSLocalizedString(@"BETHEFIRST", @"No posts");
                    label.font = k_namefont;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = color;
                    [self.table addSubview:label];
                }
            }
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


-(void)toTheTop {
    if (tableArray.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView setFont:k_midfont];
        titleView.textColor = color;
        titleView.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}






#pragma mark - Tablesetup

//------Tableview setup

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    { case 0:
        {
            return 1;
        }
        case 1: {
            return tableArray.count;
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
            cell.userInteractionEnabled = NO;
            [(DetailedRoomCell *)cell  configureTextForCell:_Roomobject];
          
            return cell;
            
        }
        case 1:
        {
             _ChatObj = [tableArray objectAtIndex:indexPath.row];
            if ([_ChatObj[@"Author"][@"username"] isEqualToString:[PFUser currentUser].username]) {
                 UITableViewCell * cell = [self customCellForIndex3:indexPath];
                 [(SelfChatCell *)cell  configureTextForCell:_ChatObj];
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILongPressGestureRecognizer *tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
                [tapGestureRecognizer setDelegate:self];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:tapGestureRecognizer];
                 return cell;
            } else {
                UITableViewCell * cell = [self customCellForIndex2:indexPath];
                cell.userInteractionEnabled = NO;
                [(ChatCell *)cell  configureTextForCell:_ChatObj];
                if ([ErrorHandler hasAdminRights]) {
                    UILongPressGestureRecognizer *tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
                    [tapGestureRecognizer setDelegate:self];
                    cell.tag = indexPath.row;
                    [cell addGestureRecognizer:tapGestureRecognizer];
                }
              
                 return cell;
            }
         
            
           
            
        }
            
        default: return nil;
    }
    
}



- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = DIdentifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [DetailedRoomCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (UITableViewCell *)customCellForIndex2:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = CIdentifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [ChatCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (UITableViewCell *)customCellForIndex3:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = SCIdentifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [SelfChatCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
    if (indexPath.section == 0) {
        CGFloat cellHeight = 0.0;
        
        cellHeight += [DetailedRoomCell cellHeight:_Roomobject];
        
        return cellHeight;
    }
    else {
        // BECAUSE THE HEIGHT IS CALCULATED THE SAME WAY WE CAN USE THE SAME FUNCTION
        CGFloat cellHeight = 0.0;
        PFObject *obj = [tableArray objectAtIndex:indexPath.row];
        cellHeight += [ChatCell cellHeight:obj];
        
        return cellHeight;
    }

}



/*
 Setting upp chatConversation object. 
 Setting up correct acl
 Pushing it up to database
 Adding it to the array and updates tableView.
 */
-(void)sendMessage {
 
    PFObject *Chat = [PFObject objectWithClassName:@"Conversations"];
    
    Chat[@"Message"] = textView.text;
    textView.text = @"";
    Chat[@"ChatRoom"] = _Roomobject;
    Chat[@"Author"] = [PFUser currentUser];
 
    [self->tableArray addObject:Chat];
    [label removeFromSuperview];
    [self.table reloadData];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
    [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    PFACL *postACL = [PFACL ACL];
    [postACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [postACL setWriteAccess:YES forRoleWithName:@"Administrator"];
    [postACL setReadAccess:YES forRoleWithName:@"Administrator"];
    [postACL setWriteAccess:NO forRoleWithName:@"User"];
    [postACL setReadAccess:YES forRoleWithName:@"User"];
    [postACL setPublicReadAccess:NO];
    Chat.ACL = postACL;
    
    [Chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
        }else {
            [tableArray removeObject:Chat];
            [self.table reloadData];
            NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
            [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"COULDNOTSENDMESSAGE", @"Could not send message :(")];

        }
        
    }];

}

-(void)SaveEdit {
    [SVProgressHUD show];
    
    EditObj[@"Message"] = textView.text;
    EditObj[@"Edited"] = @YES;
    
    [EditObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismiss];
            [containerView removeFromSuperview];
            [self.table reloadData];
            [self setupMessage];
        }else {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"COULDNOTSENDMESSAGE", @"Could not send message :(")];
            
        }
        
    }];
    
}



-(void)cellTapped:(id)sender
{
    UITapGestureRecognizer *tapView = (UITapGestureRecognizer *)sender;
    NSLog(@"Pressed %ld", [tapView.view tag]);
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"MENUHEADER", @"What do you want to do")
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"DELETEPOST", @"Remove")
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 UIAlertController * Lalert=   [UIAlertController
                                                                alertControllerWithTitle:NSLocalizedString(@"DELETEPOSTSURE", @"Are you sure?")
                                                                message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction* cancel = [UIAlertAction
                                                          actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              
                                                              [Lalert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
                                 UIAlertAction* delete = [UIAlertAction
                                                          actionWithTitle:NSLocalizedString(@"DELETEPOST", @"Remove")
                                                          style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              
                                                              [self removePost:[tableArray objectAtIndex:[tapView.view tag]]];
                                                              [Lalert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
                                 [Lalert addAction:cancel];
                                 [Lalert addAction:delete];
                                 [self presentViewController:Lalert animated:YES completion:nil];

                             }];
    
    UIAlertAction* edit = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"EDITPOST", @"Edit post")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [containerView removeFromSuperview];
                             [self EditText:[tableArray objectAtIndex:[tapView.view tag]]];
                             [textView becomeFirstResponder];
                            [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:delete];
    [alert addAction:edit];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)removePost:(PFObject *)obj {
    [SVProgressHUD show];
    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
             [SVProgressHUD dismiss];
            [tableArray removeObject:obj];
            [self.table reloadData];
           
            
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [ErrorHandler handleParseError:error];
        }
    }];

}

#pragma KEYBOARD ARGS


-(void)setupMessage {
    
    //Base code from GrowingTextView example, but edited.
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.bounds.size.width, 40)];
    containerView.backgroundColor =  k_lightGray;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    line.backgroundColor = color;
  //  [containerView addSubview:line];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.bounds.size.width-12, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.layer.borderColor = color.CGColor;
    textView.layer.borderWidth = 0.7f;
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeyDefault;
    textView.keyboardType = UIKeyboardTypeTwitter;
    textView.font = k_textfont;
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.placeholder = NSLocalizedString(@"MESSAGE", @"Message");
    textView.textColor = [UIColor grayColor];
    textView.layer.cornerRadius = 5;
    [self.view addSubview:containerView];
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:textView];
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width + 3, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:NSLocalizedString(@"POST", @"Post") forState:UIControlStateNormal];
    doneBtn.tintColor = color;
    [doneBtn.titleLabel setFont:k_buttonfont];
    [doneBtn setTitleColor:color forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}


-(void)EditText:(PFObject *)obj {
    
    //Base code from GrowingTextView example, but edited.
    EditObj = obj;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.bounds.size.width, 40)];
    containerView.backgroundColor =  [UIColor whiteColor];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    line.backgroundColor = color;
  //  [containerView addSubview:line];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.bounds.size.width-75, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeyDefault;
    textView.keyboardType = UIKeyboardTypeTwitter;
    textView.font = k_textfont;
    textView.delegate = self;
    textView.backgroundColor = k_lightGray;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.text = obj[@"Message"];
    textView.textColor = [UIColor grayColor];
    textView.layer.cornerRadius = 5;
    [self.view addSubview:containerView];
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:textView];
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:NSLocalizedString(@"EDIT", @"Edit") forState:UIControlStateNormal];
    doneBtn.tintColor = color;
    [doneBtn.titleLabel setFont:k_buttonfont];
    [doneBtn setTitleColor:color forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(SaveEdit) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}


-(void)hideKeyBoard {
    [textView resignFirstResponder];
}

//Code from Brett Schumann (HP GROWINGTEXTVIEW)
-(void)resignTextView
{
    [textView resignFirstResponder];
    if (textView.text.length > 0) {
         [self sendMessage];
    }
   
}

//Code from Brett Schumann (HP GROWINGTEXTVIEW)
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    self.table.frame = CGRectMake(0, 0, self.view.bounds.size.width, containerFrame.origin.y);
   
    // commit animations
    [UIView commitAnimations];
    if (tableArray.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
        [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
//Code from Brett Schumann (HP GROWINGTEXTVIEW)
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    self.table.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40);
    
    // commit animations
    [UIView commitAnimations];
}
//Code from Brett Schumann (HP GROWINGTEXTVIEW)
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;

}

/*
 Shows and hides send button
 when keyboard is editing!
 */
-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    textView.frame =CGRectMake(6, 3, self.view.bounds.size.width-75, containerView.frame.size.height-6);
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    [UIView commitAnimations];
   
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    if (growingTextView.text.length == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        textView.frame =CGRectMake(6, 3, self.view.bounds.size.width-12, containerView.frame.size.height-6);
        doneBtn.frame = CGRectMake(containerView.frame.size.width + 3, 8, 63, 27);
        [UIView commitAnimations];
    }
}



-(void)fetchPushedMessage:(NSNotification *)notification {
    NSLog(@"Push info: %@", notification.userInfo);
    if ([notification.userInfo[@"objectId"] isEqualToString:_Roomobject.objectId]) {
    NSLog(@"Acted on push");
    NSString *Id = notification.userInfo[@"chatId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Conversations"];
    [query includeKey:@"Author"];
    [query includeKey:@"ChatRoom"];
    [query whereKey:@"ChatRoom" equalTo:_Roomobject];
    [query getObjectInBackgroundWithId:Id block:^(PFObject *newChat, NSError *error) {
        if (!error) {
            [self->tableArray addObject:newChat];
            [self.table reloadData];
            NSIndexPath* ip = [NSIndexPath indexPathForRow:tableArray.count-1 inSection:1];
            [self.table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"COULDNOTSENDMESSAGE", @"Could not send message :(")];
            
        }
        
    }];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
}


@end