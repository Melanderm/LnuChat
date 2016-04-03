//
//  Register.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-31.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Design.h"
#import "License.h"
#import "SVProgressHUD.h"

@interface Register : UIViewController <UITextFieldDelegate> {
    UITextField *username;
    UITextField *reenter;
    UIButton *regist;
    
    UILabel *info;
}


@end
