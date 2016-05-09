//
//  pushnotificationsView.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-28.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pushnotificationsCell.h"
#import <Parse/Parse.h>

@interface pushnotificationsView : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    
}

@property (nonatomic, strong) NSMutableArray *Array;
@property (strong, nonatomic) UITableView *table;
@property (weak, nonatomic) UIColor *color;

@end
