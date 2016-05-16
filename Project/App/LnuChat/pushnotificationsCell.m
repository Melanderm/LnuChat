//
//  pushnotificationsCell.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-28.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "pushnotificationsCell.h"

static CGFloat kTableWidth = -1;
static CGFloat kPadding = 10.0f;
static CGFloat kStandardSize = 28.0f;
static CGFloat kStandardLabelHeight = 15.0f;

@interface pushnotificationsCell ()
{
    
}

@property (weak, nonatomic) UIImageView *bk;
@property (weak, nonatomic) UIImageView *PlaceholderImg;
@property (weak, nonatomic) UIImageView *markerImg;
@property (weak, nonatomic) UILabel *Onelabel;
@property (weak, nonatomic) UILabel *Hlabel;
@property (weak, nonatomic) UISwitch *Rswitch;

@end


@implementation pushnotificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)layoutSubviews {
    // Initial view so heigh won't be zero on create
    CGFloat cellHeight = 90;
    CGRect frame = self.bk.frame;
    frame.size.height = cellHeight;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.bk.frame = frame;
    
    
    
    
    [super layoutSubviews];
}

//-- Saving the tableView Width on create
+ (void)setTableViewWidth:(CGFloat)tableWidth {
    kTableWidth = tableWidth;
}

//-- Setting up initial cell to be reused.
+ (id)CellForTableWidth:(CGFloat)width {
    
    pushnotificationsCell *cell = [[pushnotificationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PNCIdentifier];
    cell.alpha = 0;
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *PhImg = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding+3, (45-kStandardSize)/2, kStandardSize, kStandardSize)];
    PhImg.layer.cornerRadius = kStandardSize/2;
    PhImg.clipsToBounds = YES;
    cell.PlaceholderImg = PhImg;
    [cell addSubview:cell.PlaceholderImg];
    
    UIImageView *marker = [[UIImageView alloc] initWithFrame:CGRectMake(kTableWidth-2, 1, 2, 10)];
    cell.markerImg = marker;
    [cell addSubview:cell.markerImg];
    
    UILabel *OLabel = [[UILabel alloc] initWithFrame:CGRectMake(PhImg.frame.origin.x, PhImg.frame.origin.y, PhImg.frame.size.width, PhImg.frame.size.height)];
    OLabel.textColor = [UIColor whiteColor];
    OLabel.textAlignment = NSTextAlignmentCenter;
    OLabel.font = k_smallfont;
    cell.Onelabel = OLabel;
    [cell addSubview:cell.Onelabel];
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kStandardSize+kPadding*2, (45-kStandardLabelHeight)/2, kTableWidth-(PhImg.frame.size.width+PhImg.frame.origin.x+kPadding*2.5), kStandardLabelHeight)];
    HeaderLabel.font = k_textfont;
    cell.Hlabel = HeaderLabel;
    [cell addSubview:cell.Hlabel];
    
    UISwitch *RightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kTableWidth-50-kPadding, (45-30)/2, 25, 25)];
    cell.Rswitch = RightSwitch;
    [cell addSubview:cell.Rswitch];
  
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    cell.alpha = 1;
    [UIView commitAnimations];
    
    return cell;
}

//-- Giving a standard height to all cells
+ (CGFloat)cellHeight:(PFObject *)obj {
    
    return 45;
}


//-- Cronfiguring cell for the individual index
- (void)configureTextForCell:(PFObject *)obj {
    int push = ([[PFUser currentUser][@"reciveTag"] boolValue])? 1 : 0;
    NSLog(@"on: %@",[PFUser currentUser][@"reciveTag"]);
    if (push==1)
        self.Rswitch.on = true;
    else
        self.Rswitch.on = false;
    self.PlaceholderImg.backgroundColor = obj[@"color"];
    self.Hlabel.text = [obj[@"text"] uppercaseString];
    self.Hlabel.textColor = obj[@"color"];
    
    
    self.markerImg.frame = CGRectMake(0, 0, 4, 45);
    self.markerImg.backgroundColor = obj[@"color"];
    
    
    
    self.PlaceholderImg.backgroundColor = obj[@"color"];
    self.PlaceholderImg.image = nil;
    self.Onelabel.text = [NSString stringWithFormat:@"%@", [ExtraFucntions FirstLetters:obj[@"text"]]];
        
    
    self.Rswitch.tintColor = obj[@"color"];
    self.Rswitch.onTintColor = obj[@"color"];
    [self.Rswitch addTarget:self action:@selector(didSwitch:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didSwitch:(id)sender
{
    BOOL state = [sender isOn];
    NSString *stat = state == YES ? @"YES" : @"NO";
    
    if (YES) {
        PFUser *user = [PFUser currentUser];
        user[@"reciveTag"] = @NO;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"NAMESAVED", @"Name saved")];
                
                } else
                {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ALERT_WASNOTABLEVTOSAVENAME", @"Wasnt able to save name")];
            }
        }];
    } else {
        PFUser *user = [PFUser currentUser];
        user[@"reciveTag"] = @YES;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"NAMESAVED", @"Name saved")];
                
            } else
            {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ALERT_WASNOTABLEVTOSAVENAME", @"Wasnt able to save name")];
            }
            }];
    }
        
}


@end
