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
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    [installation saveInBackground];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Did get push with data: %@", [userInfo objectForKey:@"objectId"]);
    completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecivePush" object:nil userInfo:userInfo];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    // If user is in password changing view, or  in view to change name, logout user so this view will appear again.
    int bchangepassword = ([[PFUser currentUser][@"changepassword"] boolValue])? 1 : 0;
    if ([[PFUser currentUser][@"name"] isEqualToString:@""] || [PFUser currentUser][@"name"] == nil || bchangepassword == 1) {
        [PFUser logOut];
    }
}


@end
