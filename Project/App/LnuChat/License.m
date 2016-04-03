//
//  License.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-03-29.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "License.h"

@interface License ()

@end

@implementation License

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = k_mainColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.hidesBackButton = YES; //HIDES BACK BUTTON, not allowed to skip this step.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"License"];
    
    LicenseText = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [PFCloud callFunctionInBackground:@"licensText"
                       withParameters:@{
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        LicenseText.text = result;
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:@"Could not load licens agreement. Cannot complete registration"];
                                        [self dismissView];
                                        
                                    }
                                }];
    LicenseText.editable = NO;
    [LicenseText setFont:k_buttonfont];
    LicenseText.textColor = k_mainColor;
    [self.view addSubview:LicenseText];
    
    
    Accept = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Accept addTarget:self action:@selector(sendRegistrationRequest) forControlEvents: UIControlEventTouchDown];
    [Accept setTitle:@"I accept" forState:UIControlStateNormal];
    Accept.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width-10, 50);
    [Accept.titleLabel setFont:k_buttonfont];
    Accept.tintColor = k_mainColor;
    Accept.enabled = YES;
    Accept.backgroundColor = [UIColor clearColor];
    [self.view addSubview:Accept];
    
    
    //Right NAVIGATIONBAR BUTTON
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"I do not accept" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewNoAccept)];
    [rightBtn setTitleTextAttributes:@{   NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:15],
                                          NSForegroundColorAttributeName: [UIColor redColor]
                                          } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)sendRegistrationRequest {


    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Accept"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"I accept the licens"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             UIAlertController * Lalert=   [UIAlertController
                                                            alertControllerWithTitle:@"Register"
                                                            message:[NSString stringWithFormat:@"Are you sure this is the correct email? \n%@", _username]
                                                            preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* yesAccept = [UIAlertAction
                                                      actionWithTitle:@"Yes this is my email"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                                      {
                                                          [SVProgressHUD show];
                                                          [UIView animateWithDuration:0.08f
                                                                                delay:0.0f
                                                                              options: UIViewAnimationOptionAllowAnimatedContent
                                                                           animations:^{
                                                                               Accept.transform = CGAffineTransformMakeScale(.95, .95);
                                                                           }
                                                                           completion:^(BOOL finished) {
                                                                               Accept.transform = CGAffineTransformMakeScale(1, 1);
                                                                             
                                                                               [PFCloud callFunctionInBackground:@"createUser"
                                                                                                  withParameters:@{ @"email": _username
                                                                                                                    }
                                                                                                           block:^(NSString *result, NSError *error) {
                                                                                                               if (!error) {
                                                                                                                   [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"USERCREATEDSUCESS", @"User creation succsessfull")];
                                                                                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                                   
                                                                                                               } else {
                                                                                                                   [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                                                                                   [self dismissView];
                                                                                                                   
                                                                                                               }
                                                                                                           }];
                                                                           }]; 

                                                          
                                                      }];
                             UIAlertAction* cancel2 = [UIAlertAction
                                                       actionWithTitle:@"No take me back"
                                                       style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           [self dismissView];
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
                              [Lalert addAction:yesAccept];
                             [Lalert addAction:cancel2];
                            
                             [self presentViewController:Lalert animated:YES completion:nil];
                             
                         }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"I do not accept"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewNoAccept];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)dismissView {
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewNoAccept {
    
    UIAlertController * alert=   [UIAlertController
                                   alertControllerWithTitle:@"Are you sure?"
                                   message:@"If you do not accept, we cannot complete your registration"
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noAccept = [UIAlertAction
                                actionWithTitle:@"I want to accept"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    UIAlertAction* cancel = [UIAlertAction
                              actionWithTitle:@"I'm sure, take me back"
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction * action)
                              {
                                  [self dismissView];
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    [alert addAction:noAccept];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:18]];
        titleView.textColor = k_mainColor;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
