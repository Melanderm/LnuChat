//
//  UserTable.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-26.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserTagsCell.h"
#import "Room.h"



@interface UserTable : UITableViewController

@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) UIColor *color;


@end
