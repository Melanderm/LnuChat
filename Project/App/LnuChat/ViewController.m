//
//  ViewController.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-03-30.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    /*
     Checking if user is logged in or not
     Presenting loginview if user is not logged in.
     */
    if (![PFUser currentUser]) {
        Login *viewcontroller = [Login alloc];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
        [self presentViewController:nav animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
