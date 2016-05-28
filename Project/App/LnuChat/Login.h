//
//  Login.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-31.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Design.h"
#import "Register.h"
#import "SVProgressHUD.h"
#import "ChooseName.h"
#import "NewPassword.h"

@interface Login : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    
    UITextField *username;
    UITextField *password;
    UIButton *login;
    UIButton *signup;
    UIButton *forgotPassword;
}


@end
