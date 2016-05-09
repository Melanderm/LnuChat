//
//  AppDelegate.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-30.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    /*
     Setting up connection to parse database
     */
    [Parse setApplicationId:@"xY13D8p07QRUgyUhJZhGFp35YDknSMae45DTZWRd"
                  clientKey:@"Xhx6hXi141WRkFFnQuOW6rWk8OkUSPtBTTBVBvhu"];
    [PFUser enableRevocableSessionInBackground];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecivePush" object:nil userInfo:notificationPayload];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // If user is in password changing view, or  in view to change name, logout user so this view will appear again.
    int bchangepassword = ([[PFUser currentUser][@"changepassword"] boolValue])? 1 : 0;
    if ([[PFUser currentUser][@"name"] isEqualToString:@""] || [PFUser currentUser][@"name"] == nil || bchangepassword == 1) {
        [PFUser logOut];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
         }
    
    
    
    if ([userInfo[@"tag"] isEqualToString:@"mentioned"]) {
        Room *vc = [[Room alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"ChatRooms"];
        [query whereKey:@"objectId" equalTo:userInfo[@"objectId"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
            if (!error) {
                PFObject *obj = [object objectAtIndex:0];
                vc.Roomobject = obj;
                
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                [navigationController pushViewController:vc animated:YES];

            }
        }];

    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    [installation saveInBackground];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Did get push with data: %@", [userInfo objectForKey:@"objectId"]);
    completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecivePush" object:nil userInfo:userInfo];
    
    if ([userInfo[@"tag"] isEqualToString:@"mentioned"]) {
    _objId = userInfo[@"objectId"];
    NSString *cancelTitle = @"Stäng";
    NSString *showTitle = @"Visa";
    NSString *message = [NSString stringWithFormat:@"%@", userInfo[@"message"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notis"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:showTitle, nil];
    alertView.tag = 1;
    [alertView show];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    // If user is in password changing view, or  in view to change name, logout user so this view will appear again.
    int bchangepassword = ([[PFUser currentUser][@"changepassword"] boolValue])? 1 : 0;
    if ([[PFUser currentUser][@"name"] isEqualToString:@""] || [PFUser currentUser][@"name"] == nil || bchangepassword == 1) {
        [PFUser logOut];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1) {
        if( 0 == buttonIndex ){ //cancel button
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        } else if ( 1 == buttonIndex ){
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            Room *vc = [[Room alloc] init];

            PFQuery *query = [PFQuery queryWithClassName:@"ChatRooms"];
            [query whereKey:@"objectId" equalTo:_objId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
                if (!error) {
                    PFObject *obj = [object objectAtIndex:0];
                    vc.Roomobject = obj;

                    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                    [navigationController pushViewController:vc animated:YES];
    
                }
            }];
        }
    }
}



@end
