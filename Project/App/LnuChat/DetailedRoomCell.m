//
//  DetailedRoomCell.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-02.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "DetailedRoomCell.h"

static CGFloat kTableWidth = -1;
static CGFloat kPadding = 15.0f;
static CGFloat kStandardLabelHeight = 20.0f;


@interface DetailedRoomCell ()
{
    
}
@property (weak, nonatomic) UIImageView *bk;
@property (weak, nonatomic) UILabel *detailedLabel;
@property (weak, nonatomic) UIImageView *markerImg;

@end

@implementation DetailedRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)layoutSubviews {
    // Initial view so heigh won't be zero on create
    CGFloat cellHeight = 100;
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
    
    DetailedRoomCell *cell = [[DetailedRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DIdentifier];
    cell.alpha = 0;
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    cell.backgroundColor = [UIColor whiteColor];
    

    UILabel *detailed = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, kTableWidth-(kPadding*2), kStandardLabelHeight)];
    detailed.font = k_textfont;
    detailed.numberOfLines = 0;
    detailed.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailedLabel = detailed;
    [cell addSubview:cell.detailedLabel];
    
    
    UIImageView *marker = [[UIImageView alloc] initWithFrame:CGRectMake(99, 0, kTableWidth, 2)];
    cell.markerImg = marker;
    [cell addSubview:cell.markerImg];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    cell.alpha = 1;
    [UIView commitAnimations];
    
    return cell;
}

//-- Calculating height of cell depending on textlenght. EVENTUALLY
+ (CGFloat)cellHeight:(PFObject *)obj {
    
    CGSize constrained = CGSizeMake(kTableWidth-(kPadding*2), 1000);
    
    CGSize labelSize = [obj[@"RoomDescription"] sizeWithFont:k_textfont
                                constrainedToSize:constrained
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat labelHeight = labelSize.height;
    
    return labelHeight+(kPadding*2);
}

//-- Cronfiguring cell for the individual index
- (void)configureTextForCell:(PFObject *)obj {
    
    NSString *hex  = obj[@"color"];
    UIColor *color = [UIColorExpanded colorWithHexString:hex];
    
    CGSize constrained = CGSizeMake(kTableWidth-(kPadding*2), 1000);
    CGSize labelSize = [obj[@"RoomDescription"] sizeWithFont:k_textfont
                                           constrainedToSize:constrained
                                               lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight = labelSize.height;
    self.detailedLabel.frame = CGRectMake(kPadding, kPadding, kTableWidth-(kPadding*2), labelHeight);
    self.detailedLabel.text = obj[@"RoomDescription"];
    self.detailedLabel.textColor = color;
    
    self.markerImg.frame = CGRectMake(0, labelHeight+(kPadding*2)-2, kTableWidth, 2);
    self.markerImg.backgroundColor = color;
    
    
}

@end
