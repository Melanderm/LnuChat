//
//  License.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-03-29.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "design.h"

@interface License : UIViewController {
    
    UITextView *LicenseText;
    UIButton *Accept;
    
}
@property (nonatomic,strong) NSString *username;

@end
