//
//  Login.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-31.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newback];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:k_mainColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    /*
     Setting up rest of loginview.
     */

    UILabel *presentation = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 40)];
    presentation.text = @"LnuChat";
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
    username.placeholder = NSLocalizedString(@"USERNAME", @"Username");
    username.tintColor = k_mainColor;
    [username setFont:k_textfont];
    username.frame = CGRectMake((self.view.bounds.size.width-240)/2, 120, 240, 30);
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.keyboardType = UIKeyboardTypeEmailAddress;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [username setTextColor:k_mainColor];
    [username addTarget:self
                 action:@selector(TextFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    username.returnKeyType=UIReturnKeyNext;
    username.tag=1;
    [self.view addSubview:username];
    
    password = [[UITextField alloc] init];
    password.delegate = self;
    password.placeholder = NSLocalizedString(@"PASSWORD", @"Password");
    password.tintColor = k_mainColor;
    [password setFont:k_textfont];
    password.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*3, 240, 30);
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.keyboardType = UIKeyboardTypeDefault;
    password.secureTextEntry = YES;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [password setTextColor:k_mainColor];
    [password addTarget:self
                 action:@selector(TextFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    password.returnKeyType=UIReturnKeyGo;
    password.tag = 2;
    [self.view addSubview:password];
    
    login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [login addTarget:self action:@selector(LoginButtonPressed) forControlEvents: UIControlEventTouchDown];
    [login setTitle:NSLocalizedString(@"LOGIN", @"Login") forState:UIControlStateNormal];
    login.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*4, 240, 50);
    login.tintColor = [UIColor whiteColor];
    [login.titleLabel setFont:k_buttonfont];
    login.enabled = NO;
    login.backgroundColor = k_mainColorNoEnable;
    login.clipsToBounds = YES;
    login.layer.cornerRadius = 10/2.0f;
    [self.view addSubview:login];
    
    signup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signup addTarget:self action:@selector(signup) forControlEvents: UIControlEventTouchDown];
    [signup setTitle:NSLocalizedString(@"REGISTER", @"Register") forState:UIControlStateNormal];
    signup.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*5, 240, 50);
    [signup.titleLabel setFont:k_buttonfont];
    signup.tintColor = k_mainColor;
    signup.enabled = YES;
    signup.backgroundColor = [UIColor clearColor];
    [self.view addSubview:signup];
    
    forgotPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgotPassword addTarget:self action:@selector(resetPassword) forControlEvents: UIControlEventTouchDown];
    [forgotPassword setTitle:NSLocalizedString(@"FORGOTPASSWORD", @"Forgot password?") forState:UIControlStateNormal];
    forgotPassword.frame = CGRectMake((self.view.bounds.size.width-240)/2, self.view.bounds.size.height-70, 240, 50);
    [forgotPassword.titleLabel setFont:k_buttonfont];
    forgotPassword.tintColor = k_mainColor;
    forgotPassword.enabled = YES;
    forgotPassword.backgroundColor = [UIColor clearColor];
    [self.view addSubview:forgotPassword];
    
    
    
 //  username.text = @"mm222ev@student.lnu.se";
    
    

    
}
-(void)viewWillAppear:(BOOL)animated {
    [self resignFirstResponder];
}

- (void)TextFieldDidChange:(UITextField *)sender
{
    if ([self validateEmail:username.text] && password.text.length > 5) {
        login.enabled = YES;
        login.backgroundColor = k_mainColor;
    } else {
        login.enabled = NO;
        login.backgroundColor = k_mainColorNoEnable;
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
        if ([self validateEmail:username.text] && password.text.length > 5) {
            [self LoginButtonPressed];
            [textField resignFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Dismiss keyboard on touch outside.
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

-(void)LoginButtonPressed {
    /*
     Animating button to make it more interaktiv
     Dissmissing keyboard and tries to log in user.
     If password and email is correct, logs in user and dismisses view.
     If not, gives error message
     */
    [SVProgressHUD show];
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         [password resignFirstResponder];
                         [username resignFirstResponder];
                         [PFUser logInWithUsernameInBackground:username.text password:password.text block:^(PFUser *user, NSError *error) {
                             if (!error) { //SUCCESFUL LOGIN
                                 /*
                                  Saving user in installation for easier be able to handle push notifications.
                                  */
                                 
                                 PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                 [currentInstallation setObject:[PFUser currentUser].username forKey:@"Username"];
                                 [currentInstallation saveInBackground];
                                 
                                 //If user hasn't set name, present name controller.
                                 if ([[PFUser currentUser][@"name"] isEqualToString:@""] || [PFUser currentUser][@"name"] == nil) {
                                     
                                     ChooseName *vc = [[ChooseName alloc] init];
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }
                                 else
                                 {
                                     int bchangepassword = ([[PFUser currentUser][@"changepassword"] boolValue])? 1 : 0;
                                     
                                     // If user uses temporary password, present password change controller.
                                     if (bchangepassword == 1) {
                                         NewPassword *vc = [[NewPassword alloc] init];
                                         [self.navigationController pushViewController:vc animated:YES];
                                     }
                                     // Else if everything is in order, dismiss view and let user use the app.
                                     else {
                                         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Logged in as: %@", [PFUser currentUser][@"name"]]];
                                         [self dismissViewControllerAnimated:NO completion:nil];
                                         
                                     }
                                 }
                                 
                             }
                             if (error) {
                                 [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                 password.text = @"";
                             }
                         }];
                         
                         login.transform = CGAffineTransformMakeScale(.95, .95);
                     }
                     completion:^(BOOL finished) {
                         login.transform = CGAffineTransformMakeScale(1, 1);
                         
                     }];
}


-(void)signup {
    /*
     Animating button
     Presents new Sign up ViewController
     */
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         signup.transform = CGAffineTransformMakeScale(.95, .95);
                         
                         Register *viewController = [[Register alloc] init];
                         [self.navigationController pushViewController:viewController animated:YES];
                         
                     }
                     completion:^(BOOL finished) {
                         signup.transform = CGAffineTransformMakeScale(1, 1);
                         
                     }];
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    /*
     Regex for lnu/student lnu email.
     checks if emailStr matches
     returns bool
     */
    NSString *studentRegex = @"[A-Z0-9a-z._%+-]+@student.lnu.se";
    NSString *teacherRegex = @"[A-Z0-9a-z._%+-]+@lnu.se";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", studentRegex];
    NSPredicate *emailTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", teacherRegex];
    return [emailTest evaluateWithObject:emailStr] || [emailTest2 evaluateWithObject:emailStr];
}

-(void)viewWillDisappear:(BOOL)animated {
    /*
     Hides any running SVProgressHUD
     */
    [SVProgressHUD dismiss];
}

-(void)resetPassword {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Glömt lösenord"
                                  message:@"Har du glömt ditt lösenord?\nLåt oss hjälpa dig!\nEmailen är capslock känslig!!!"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Send"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             if ([alert textFields].lastObject.text.length < 0)
                                 [SVProgressHUD showErrorWithStatus:@"Email field cant be empty"];
                             else if (![self validateEmail:[alert textFields].lastObject.text])
                                 [SVProgressHUD showErrorWithStatus:@"That was not an lnu email"];
                             else {
                                 [SVProgressHUD show];
                                 [PFUser requestPasswordResetForEmailInBackground:[alert textFields].lastObject.text block:^(BOOL succeeded,NSError *error)
                                  {
                                      if(!error) {
                                          [SVProgressHUD showSuccessWithStatus:@"We have sent you an email!"];
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                      }
                                  }];
                             }
                             
                             
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
