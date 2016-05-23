//
//  UserTagsCell.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-27.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "UserTagsCell.h"

static CGFloat kTableWidth = -1;
static CGFloat kPadding = 10.0f;
static CGFloat kStandardSize = 28.0f;
static CGFloat kStandardLabelHeight = 15.0f;

@interface UserTagsCell ()
{
    
}

@property (weak, nonatomic) UIImageView *bk;
@property (weak, nonatomic) UIImageView *PlaceholderImg;
@property (weak, nonatomic) UIImageView *markerImg;
@property (weak, nonatomic) UILabel *Onelabel;
@property (weak, nonatomic) UILabel *Hlabel;

@end

@implementation UserTagsCell

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
    
    UserTagsCell *cell = [[UserTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UTCIdentifier];
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
    
     _color = k_mainColor;
    self.PlaceholderImg.backgroundColor = _color;
    self.Hlabel.text = [obj[@"name"] uppercaseString];
    self.Hlabel.textColor = _color;
    

    self.markerImg.frame = CGRectMake(0, 0, 4, 45);
    self.markerImg.backgroundColor = _color;
    

    
    if (obj[@"Profilepic"] != NULL) {
        self.Onelabel.text = @"";
        PFFile *userImageFile = obj[@"Profilepic"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.PlaceholderImg.image = image;
                self.PlaceholderImg.layer.cornerRadius = kStandardSize/2;
                
            } else {
                self.PlaceholderImg.backgroundColor = _color;
                self.PlaceholderImg.image = nil;
                self.Onelabel.text = [NSString stringWithFormat:@"%@", [ExtraFucntions FirstLetters:obj[@"name"]]];
            }
                
            }];
        
    } else {
        self.PlaceholderImg.backgroundColor = _color;
        self.PlaceholderImg.image = nil;
        self.Onelabel.text = [NSString stringWithFormat:@"%@", [ExtraFucntions FirstLetters:obj[@"name"]]];
        
    }
    
    
    
}


@end
