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
    
    //--- Setting up background color and navigationBar ( Hidden and back button empty )
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
    username.placeholder = NSLocalizedString(@"USERNAME", @"Username");
    username.text = @"mm222ev@student.lnu.se"; //TEMP
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
    [login addTarget:self action:nil forControlEvents: UIControlEventTouchDown];
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
    [signup addTarget:self action:nil forControlEvents: UIControlEventTouchDown];
    [signup setTitle:NSLocalizedString(@"REGISTER", @"Register") forState:UIControlStateNormal];
    signup.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*5, 240, 50);
    [signup.titleLabel setFont:k_buttonfont];
    signup.tintColor = k_mainColor;
    signup.enabled = YES;
    signup.backgroundColor = [UIColor clearColor];
    [self.view addSubview:signup];


}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)TextFieldDidChange:(UITextField *)sender
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
