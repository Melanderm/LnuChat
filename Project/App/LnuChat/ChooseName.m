//
//  ChooseName.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-03-25.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ChooseName.h"

@interface ChooseName ()

@end

@implementation ChooseName
@synthesize fromSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (fromSettings) {
        [[UIView appearance] setTintColor:k_mainColor];
        UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newback];
        [self.navigationController.navigationBar setTintColor:k_mainColor];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        [self.navigationController.navigationBar setTranslucent:NO];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.tintColor = k_mainColor;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.hidesBackButton = YES; //HIDES BACK BUTTON, not allowed to skip this step.
    }
    
    
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    bk.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bk];
    
    UILabel *presentation = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 50)];
    presentation.text = NSLocalizedString(@"CHOOSENAME", @"Skriv in namn");
    presentation.textAlignment = NSTextAlignmentCenter;
    presentation.textColor = k_mainColor;
    presentation.alpha = 0.7;
    [presentation setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:40]];
    [self.view addSubview:presentation];
    
    
    
    /*
     Setting up "TEXTFIELDDIDCHANGE" for interactive feel of login, activating the login button when format is correct.
     */
    username = [[UITextField alloc] init];
    username.delegate = self;
    username.placeholder = NSLocalizedString(@"FIRSTNAME", @"Firstname");
    username.tintColor = k_mainColor;
    [username setFont:k_textfont];
    username.frame = CGRectMake((self.view.bounds.size.width-240)/2, 120, 240, 30);
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.keyboardType = UIKeyboardTypeDefault;
    username.autocapitalizationType = UITextAutocapitalizationTypeWords;
    username.returnKeyType=UIReturnKeyNext;
    [username setTextColor:k_mainColor];
    [username addTarget:self
                 action:@selector(TextFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    username.tag = 1;
    [self.view addSubview:username];
    
    
    reenter = [[UITextField alloc] init];
    reenter.delegate = self;
    reenter.placeholder = NSLocalizedString(@"LASTNAME", @"Lastname");
    reenter.tintColor = k_mainColor;
    [reenter setFont:k_textfont];
    reenter.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*3, 240, 30);
    reenter.autocorrectionType = UITextAutocorrectionTypeNo;
    reenter.keyboardType = UIKeyboardTypeDefault;
    reenter.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [reenter setTextColor:k_mainColor];
    [reenter addTarget:self
                action:@selector(TextFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
    reenter.tag = 2;
    [self.view addSubview:reenter];
    
    
    regist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [regist addTarget:self action:@selector(saveName) forControlEvents: UIControlEventTouchDown];
    [regist setTitle:NSLocalizedString(@"CONTINUE", @"Continue") forState:UIControlStateNormal];
    regist.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*4, 240, 50);
    regist.tintColor = [UIColor whiteColor];
    [regist.titleLabel setFont:k_buttonfont];
    regist.enabled = NO;
    regist.backgroundColor = k_mainColorNoEnable;
    regist.clipsToBounds = YES;
    regist.layer.cornerRadius = 10/2.0f;
    [self.view addSubview:regist];
    
    
    /*
     Setting up a multiline information label.
     */
    info = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-240)/2, 20+50*5, 240, 100)];
    info.lineBreakMode = NSLineBreakByWordWrapping;
    info.numberOfLines = 0;
    info.textAlignment = NSTextAlignmentCenter;
    info.textColor = k_mainColor;
    info.font = k_textfont;
    info.text = NSLocalizedString(@"NAMEINFO", @"Information");
    [self.view addSubview:info];

}

- (void)TextFieldDidChange:(UITextField *)sender
{
    if ([self validateName:username.text] && [self validateName:reenter.text] && username.text.length > 2 && reenter.text.length > 2) {
        regist.enabled = YES;
        regist.backgroundColor = k_mainColor;
    } else {
        regist.enabled = NO;
        regist.backgroundColor = k_mainColorNoEnable;
    }
}

/*
 Handels ReturnKey on textfield keyboard
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        if ([self validateName:username.text] && [self validateName:reenter.text] && username.text.length > 2 && reenter.text.length > 2) {
            [self saveName];
            [textField resignFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    return NO;
}

-(void)saveName {
    [SVProgressHUD show];
    PFUser *user = [PFUser currentUser];
    user[@"name"] = [NSString stringWithFormat:@"%@ %@", username.text, reenter.text];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"NAMESAVED", @"Name saved")];
            
            int bchangepassword = ([[PFUser currentUser][@"changepassword"] boolValue])? 1 : 0;
            //Checks if user has temporary password
            if (bchangepassword == 1) {
                NewPassword *vc = [[NewPassword alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            //No password change needed
            else {
                   [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Logged in as: %@", [PFUser currentUser][@"name"]]];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        } else {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ALERT_WASNOTABLEVTOSAVENAME", @"Wasnt able to save name")];
            
        }
    }];

}



- (BOOL)validateName:(NSString *)name {
    NSString *emailRegex = @"^[A-ZÅÄÖ][-a-zåäö]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    // Identifies that the view was removed by hitting the back button
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        //Returning the navigationbar to the more visable look that it has in settigsView
        [[UIView appearance] setTintColor:k_mainColor];
        UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newback];
        [self.navigationController.navigationBar setTintColor:k_mainColor];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
    }
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
