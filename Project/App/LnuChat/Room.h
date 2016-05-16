//
//  Room.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-10.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Design.h"
#import "UIColorExpanded.h"
#import "DetailedRoomCell.h"
#import "ChatCell.h"
#import "SelfChatCell.h"
#import "SVProgressHUD.h"
#import "HPGrowingTextView.h"
#import "ErrorHandler.h"

#import "UserTable.h"



@interface Room : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, UIApplicationDelegate> {
    
    NSMutableArray *tableArray;
    UILabel *label;

    UIColor *color;
    
    UIView *containerView;
    UIButton *doneBtn;
    
    PFObject *EditObj;
    HPGrowingTextView *textView;
    
    
    Boolean searchUser;
    NSMutableArray *UsersTagedArray;
    NSMutableArray *UsersTagedArrayTemp;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong)  PFObject *Roomobject;
@property (nonatomic, strong)  PFObject *ChatObj;



@end
