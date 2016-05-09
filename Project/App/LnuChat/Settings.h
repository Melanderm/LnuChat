//
//  Settings.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-04.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "design.h"
#import <Parse/Parse.h>
#import "SettingsCell.h"
#import "NewPassword.h"
#import "ChooseName.h"
#import "Login.h"
#import "pushnotificationsView.h"

@interface Settings : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate> {
    
    NSMutableArray *tableArray;
    NSMutableArray *tableArrayD;
    NSMutableArray *tableArrayC;
    
    NSString *bild;
    
    UITapGestureRecognizer *tap;
}

@property (nonatomic, strong) UITableView *table;

@end
