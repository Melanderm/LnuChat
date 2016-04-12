//
//  ErrorHandler.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-12.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ErrorHandler.h"
#import "Login.h"
#import <Parse/Parse.h>

@implementation ErrorHandler

/*
 Checks if user hase admin rights
 returns BOOL
 */
+(BOOL)hasAdminRights {
    
    if ([[PFUser currentUser][@"role"] isEqualToString:@"Administrator"]) {
        return YES;
    } else {
        return NO;
    }
}


/*
 Checks what error
 */
+(void)handleParseError:(NSError *)error{
    if (![error.domain isEqualToString:PFParseErrorDomain]) {
        return;
    }
    
    switch (error.code) {
        case kPFErrorInvalidSessionToken: {
            [self _handleInvalidSessionTokenError];
            break;
        }
    }
}

/*
 IF error with Session expired, Logs out user, and removes "pushnotification" refrence
 */
+ (void)_handleInvalidSessionTokenError {
    NSLog(@"Invalid token.");
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObjectForKey:@"Username"];
    [currentInstallation saveInBackground];
    [PFQuery clearAllCachedResults];
    [PFUser logOut];
    
    UIViewController *presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Login *vc = [[Login alloc] init];
    [SVProgressHUD showErrorWithStatus:@"Your sessions has expired, please log in again"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [presentingViewController presentViewController:nav animated:NO completion:nil];
    
}




@end
