//
//  Settings.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-04.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[PFUser currentUser][@"name"]];
    
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {  //Updates user information
        if (!error) {
            [self.table reloadData];
                [self setTitle:[PFUser currentUser][@"name"]];
        } 
    }];

    [[UIView appearance] setTintColor:k_mainColor];
    UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newback];
    [self.navigationController.navigationBar setTintColor:k_mainColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
 
    

    //LEFT NAVIGATIONBAR BUTTON
    UIImage *image = [UIImage imageNamed:@"cross.png"];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = k_lightGray;
    [self.table setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.view addSubview:self.table];
    
    [SettingsCell setTableViewWidth:self.view.frame.size.width];

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self settingUpArray];
}

-(void)settingUpArray {
    if ([PFUser currentUser][@"Profilepic"] != NULL)
        bild = NSLocalizedString(@"CHANGEIMAGE", @"Change image");
    else
        bild = NSLocalizedString(@"UPLOADIMAGE", @"Upload image");
    
    tableArray = [[NSMutableArray alloc] initWithObjects:bild, NSLocalizedString(@"CHANGEPW", @"Change password"), NSLocalizedString(@"CHANGENAME", @"Change name"), NSLocalizedString(@"PUSHNOTIS", @"Pusnotiser"), NSLocalizedString(@"LOGOUT", @"Logout"), nil];
    tableArrayD = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"IMAGEDETALED", @"Img detailed"),NSLocalizedString(@"CHANGEPWDETAILED", @"pw detailed"), NSLocalizedString(@"CHANGENAMEDETAILED", @"Name detailed"), NSLocalizedString(@"PUSHNOTISDETAILED", @"Pusnotiser detailed"), NSLocalizedString(@"LOGOUTDETAILED", @"Logout detailed"), nil];
    tableArrayC = [[NSMutableArray alloc] initWithObjects:@"#3498db",@"#2ecc71", @"#9b59b6", @"#f1c40f", @"#c0392b", nil];

}

-(void)viewDidAppear:(BOOL)animated {
//self.table.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);

}

-(void)Image {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self uploadImage:squareCropImageToSideLength(image, 200)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// SQUARE IMAGE! CODE FROME https://www.cocoanetics.com/2014/07/square-cropping-images/
UIImage *squareCropImageToSideLength(UIImage *sourceImage,
                                     CGFloat sideLength) {
    [SVProgressHUD showInfoWithStatus:@"Skalar om bilden"];
    // input size comes from image
    CGSize inputSize = sourceImage.size;
    
    // round up side length to avoid fractional output size
    sideLength = ceilf(sideLength);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(sideLength, sideLength);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(sideLength / inputSize.width,
                        sideLength / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                        inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0,
                                 outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                   center.y - scaledInputSize.height/2.0,
                                   scaledInputSize.width,
                                   scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [sourceImage drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}

-(void)uploadImage:(UIImage *)img {
    [SVProgressHUD showWithStatus:@"Laddar upp bild"];
    NSData* data = UIImageJPEGRepresentation(img, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:data];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFUser *user = [PFUser currentUser];
            user[@"Profilepic"] = imageFile;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                   [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                       if (!error) {
                           [self settingUpArray];
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"IMAGESAVED", @"Image saved")];
                        [self.table reloadData];
                       }
                   }];
                } else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ERROR", @"Something went wrong")];
                }
            }];
        }
    }];
}

#pragma EXTRAS

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView setFont:k_midfont];
        titleView.textColor = k_mainColor;
        titleView.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

#pragma mark - Tablesetup

//------Tableview setup

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    { case 0:
        {
            return [tableArray count];
        }
        default: return nil;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell * cell = [self customCellForIndex:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString *object = [tableArray objectAtIndex:indexPath.row];
            NSString *object2 = [tableArrayD objectAtIndex:indexPath.row];
             NSString *object3 = [tableArrayC objectAtIndex:indexPath.row];
            [(SettingsCell *)cell  configureTextForCell:object :object2 :object3 :indexPath.row];
            if (indexPath.row == 0 && [PFUser currentUser][@"Profilepic"] != NULL) {
                UILongPressGestureRecognizer *tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage)];
                [tapGestureRecognizer setDelegate:self];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:tapGestureRecognizer];
            }
            
            return cell;
            
        }
            
        default: return nil;
    }
    
    
}

-(void)removeImage {
    UIAlertController * Lalert=   [UIAlertController
                                   alertControllerWithTitle:NSLocalizedString(@"REMOVEIMAGE", @"Remove")
                                   message:NSLocalizedString(@"REMOVEIMAGEDETAILED", @"Are you sure?")
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* logout = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"REMOVEIMAGE", @"Remove")
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 PFUser *current = [PFUser currentUser];
                                 [current removeObjectForKey:@"Profilepic"];
                                 [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     if (!error) {
                                         [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"REMOVEDPICTURE", @"Removed")];
                                         [self settingUpArray];
                                         [self.table reloadData];
                                         
                                     } else {
                                         [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                         
                                     }
                                 }];
                             }];
    UIAlertAction* cancel2 = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [Lalert dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    [Lalert addAction:cancel2];
    [Lalert addAction:logout];
    [self presentViewController:Lalert animated:YES completion:nil];


}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = SeIdentifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [SettingsCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0;
    
    cellHeight += [SettingsCell cellHeight:[tableArray objectAtIndex:indexPath.row]];
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self Image];
    }
    if (indexPath.row == 1) {
        NewPassword *vc = [[NewPassword alloc] init];
        vc.fromSettings = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        ChooseName *vc = [[ChooseName alloc] init];
        vc.fromSettings = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        pushnotificationsView *dst = [[pushnotificationsView alloc] init];
        UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:dst];
        vc.view.frame = CGRectMake(15, 50, self.view.bounds.size.width-30, self.view.bounds.size.height/2);
    
        vc.view.layer.borderColor = k_mainColor.CGColor;
        vc.view.layer.borderWidth = 1.0;
        vc.view.clipsToBounds = YES;
        vc.view.layer.cornerRadius = 10;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc didMoveToParentViewController:self];
        
        self.table.alpha = 0.5;
        
        [self.table addGestureRecognizer:tap];

    }
  
    if (indexPath.row == 4) {
        UIAlertController * Lalert=   [UIAlertController
                                       alertControllerWithTitle:NSLocalizedString(@"LOGOUT", @"Logout")
                                       message:NSLocalizedString(@"SURELOGOUT", @"Are you sure?")
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* logout = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"LOGOUT", @"Logout")
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     
                                     PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                     [currentInstallation removeObjectForKey:@"Username"];
                                     [currentInstallation saveInBackground];
                                     [PFQuery clearAllCachedResults];
                                     [PFUser logOut];
                                     Login *vc = [[Login alloc] init];
                                     [self dismissViewControllerAnimated:NO completion:nil];
                                     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                     [self presentViewController:nav animated:YES completion:nil];
                                 }];
        UIAlertAction* cancel2 = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [Lalert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
        [Lalert addAction:cancel2];
        [Lalert addAction:logout];
        [self presentViewController:Lalert animated:YES completion:nil];

    }

    
}

-(void)removeView {
    UIViewController *vc = [self.childViewControllers lastObject];
    [self.table removeGestureRecognizer:tap];
         self.table.alpha = 1;
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

-(void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
