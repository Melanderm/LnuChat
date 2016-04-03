//
//  Register.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-31.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "Register.h"

@interface Register ()

@end

@implementation Register

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = k_mainColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *presentation = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 50)];
    presentation.text = NSLocalizedString(@"REGISTER", @"Register");
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
    username.placeholder = NSLocalizedString(@"USERNAME", @"Email");
    username.tintColor = k_mainColor;
    [username setFont:k_textfont];
    username.frame = CGRectMake((self.view.bounds.size.width-240)/2, 120, 240, 30);
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.keyboardType = UIKeyboardTypeEmailAddress;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.returnKeyType=UIReturnKeyNext;
    [username setTextColor:k_mainColor];
    [username addTarget:self
                 action:@selector(TextFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
    username.tag = 1;
    [self.view addSubview:username];
    
    
    reenter = [[UITextField alloc] init];
    reenter.delegate = self;
    reenter.placeholder = NSLocalizedString(@"REUSERNAME", @"re enter email");
    reenter.tintColor = k_mainColor;
    [reenter setFont:k_textfont];
    reenter.frame = CGRectMake((self.view.bounds.size.width-240)/2, 20+50*3, 240, 30);
    reenter.autocorrectionType = UITextAutocorrectionTypeNo;
    reenter.keyboardType = UIKeyboardTypeEmailAddress;
    reenter.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [reenter setTextColor:k_mainColor];
    [reenter addTarget:self
                action:@selector(TextFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
    reenter.tag = 2;
    [self.view addSubview:reenter];
    
    
    regist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [regist addTarget:self action:@selector(showLicens) forControlEvents: UIControlEventTouchDown];
    [regist setTitle:NSLocalizedString(@"REGISTER", @"Register") forState:UIControlStateNormal];
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
    info.text = NSLocalizedString(@"REGISTERINFO", @"Information");
    [self.view addSubview:info];
    
    
    
    username.text = @"mm222ev@student.lnu.se";
    reenter.text = @"mm222ev@student.lnu.se";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"DidRegister" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    
}

/*
 Reacts to changes i textfields
 Making view more interactive
 */
- (void)TextFieldDidChange:(UITextField *)sender
{
    if ([self validateEmail:username.text] && [username.text isEqualToString:reenter.text]) {
        regist.enabled = YES;
        regist.backgroundColor = k_mainColor;
        info.text = @"Ready to go";
        info.textColor = k_mainColor;
        
    } else {
        regist.enabled = NO;
        regist.backgroundColor = k_mainColorNoEnable;
        if ([username.text isEqualToString:reenter.text])
            info.text = @"Wrong format \nEmails need to end with @lnu.se or @student.lnu.se";
        if (![username.text isEqualToString:reenter.text])
            info.text = @"Wrong format \nEmails need to match & end with @lnu.se or @student.lnu.se";
        info.textColor = [UIColor redColor];
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
        [textField resignFirstResponder];
        
    }
    return NO;
}

/*
 Indicates load
 Dismisses keyboard
 Animates Button on buttonPress
 And runs cloud code to register user
 */
-(void)showLicens {
    [username resignFirstResponder];
    [reenter resignFirstResponder];
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         regist.transform = CGAffineTransformMakeScale(.95, .95);
                         
                         License *viewController = [[License alloc] init];
                         viewController.username = username.text;
                         [self.navigationController pushViewController:viewController animated:YES];
                         
                     }
                     completion:^(BOOL finished) {
                         regist.transform = CGAffineTransformMakeScale(1, 1);
                         username.text = @"";
                         reenter.text = @"";
                         
                     }];
    
    
}
/*
 Regex for checking if email is @lnu.se/@student.lnu.se
 Returns BOOL
 */
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *studentRegex = @"[A-Z0-9a-z._%+-]+@student.lnu.se";
    NSString *teacherRegex = @"[A-Z0-9a-z._%+-]+@lnu.se";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", studentRegex];
    NSPredicate *emailTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", teacherRegex];
    return [emailTest evaluateWithObject:emailStr] || [emailTest2 evaluateWithObject:emailStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated {
    /*
     Hiding navigationbar when returning to loginview.
     Hides any running SVProgressHUD
     */
    [SVProgressHUD dismiss];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}



@end
