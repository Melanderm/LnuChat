//
//  ViewController.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-30.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Login.h"
#import "Design.h"
#import "ErrorHandler.h"
#import "TopicsCell.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *tableArray;
    PFObject *object;
    UIRefreshControl *refreshController;
    
}
@property (nonatomic, strong) UITableView *table;




@end

