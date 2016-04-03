//
//  ChooseName.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-03-25.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "design.h"
#import "SVProgressHUD.h"
#import "NewPassword.h"

@interface ChooseName : UIViewController  <UITextFieldDelegate>{
    UITextField *username;
    UITextField *reenter;
    UIButton *regist;
    
    UILabel *info;
}

@end
