//
//  UserTable.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-26.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "UserTable.h"

@interface UserTable ()

@end

@implementation UserTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [self.navigationController.navigationBar setTintColor:_color];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"DidUpdateTag" object:nil];
     [UserTagsCell setTableViewWidth:self.view.frame.size.width];
    
    _selectedArray = [[NSMutableArray alloc] init];
    _usernameArray = [[NSMutableArray alloc] init];
    
    
    if (_whatView == 1) {
        [self setTitle:NSLocalizedString(@"INVITEUSERS", @"Invite users")];
        self.tableView.bounces = YES;
      
        //Right NAVIGATIONBAR BUTTON
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(CreateRoom)];
        [rightBtn setTitleTextAttributes:@{   NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:15],
                                              NSForegroundColorAttributeName: k_mainColor
                                              } forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    if (_whatView == 2) {
        [self setTitle:NSLocalizedString(@"INVITEUSERS", @"Invite users")];
        self.tableView.bounces = YES;

        //Right NAVIGATIONBAR BUTTON
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"INVITE", @"Invite") style:UIBarButtonItemStyleDone target:self action:@selector(NewInvite)];
        [rightBtn setTitleTextAttributes:@{   NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:15],
                                              NSForegroundColorAttributeName: _color
                                              } forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBtn;

    }
    if (_whatView == 3) {
        [self setTitle:NSLocalizedString(@"ALREADYINROOM", @"Members of room")];
        self.tableView.bounces = YES;
        
    }
   
}

-(void)updateTable {
    NSLog(@"UserTable int: %lu", (unsigned long)_usersArray.count);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _usersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell * cell = [self customCellForIndex:indexPath];
            if (_whatView == 1 || _whatView == 2 || _whatView == 0 ) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.userInteractionEnabled = YES;
            }else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.userInteractionEnabled = NO;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            PFObject *object = [_usersArray objectAtIndex:indexPath.row];
            [(UserTagsCell *)cell  configureTextForCell:object :_color];
            
            
            return cell;
            
        }
            
        default: return nil;
    }
    
    
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = UTCIdentifier;
    cell = [self.tableView dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [UserTagsCell CellForTableWidth:self.tableView.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_whatView == 0 ) {
    NSLog(@"Did trigger: whatView == 0");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *obj = [_usersArray objectAtIndex:indexPath.row];
    NSDictionary* userInfo = @{@"User": obj[@"name"], @"Username": obj[@"username"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeText" object:obj userInfo:userInfo];

    }
    if (_whatView == 2 || _whatView == 1)
    {
       
        PFObject *obj = [_usersArray objectAtIndex:indexPath.row];
        
         NSLog(@"WhatView: %i, adding/removing user: %@", _whatView, obj[@"username"]);
        if ([_selectedArray containsObject:obj.objectId]) {
            [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor whiteColor];
            [_selectedArray removeObject:obj.objectId];
            [_usernameArray removeObject:obj[@"username"]];
            NSLog(@"Removed: %@", _selectedArray);
        } else {
            [_selectedArray addObject:obj.objectId];
            [_usernameArray addObject:obj[@"username"]];
            NSLog(@"added: %@", _selectedArray);
            [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [_color colorWithAlphaComponent:0.3];
        }
    }
    if (_whatView == 3)
    {
    
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
        titleView.textColor = _color;
        titleView.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

-(void)CreateRoom {
    [SVProgressHUD show];
    [PFCloud callFunctionInBackground:@"CreateRoom"
                       withParameters:@{ @"Roomname": [NSString stringWithFormat:@"%@", _name],
                                         @"RoomDetails": _roomdescription,
                                         @"InvitedUsers": _selectedArray,
                                         @"InvitedUsernames": _usernameArray
                                         }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        [SVProgressHUD showSuccessWithStatus:result];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                        
                                    }
                                }];
    
}

-(void)NewInvite {
    [SVProgressHUD show];
    NSLog(@"Selected user array: %@ \nUsernameArray: %@", _selectedArray, _usernameArray);
    [PFCloud callFunctionInBackground:@"InviteUser"
                       withParameters:@{ @"roomID": _objectCurrentRoom.objectId,
                                         @"InvitedUsers": _selectedArray,
                                         @"InvitedUsernames": _usernameArray
                                         }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        [SVProgressHUD showSuccessWithStatus:result];
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                        
                                    }
                                }];
}




@end
