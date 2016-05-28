//
//  TopicsCell.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-12.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "TopicsCell.h"

static CGFloat kTableWidth = -1;
static CGFloat kPadding = 15.0f;
static CGFloat kStandardSize = 50.0f;
static CGFloat kStandardHeight = 100.0f;
static CGFloat kStandardLabelHeight = 20.0f;

@interface TopicsCell ()
{
    
}
@property (weak, nonatomic) UIImageView *bk;
@property (weak, nonatomic) UIImageView *PlaceholderImg;
@property (weak, nonatomic) UIImageView *ActivityIndi;
@property (weak, nonatomic) UILabel *Onelabel;
@property (weak, nonatomic) UILabel *Hlabel;
@property (weak, nonatomic) UILabel *Dlabel;
@end


@implementation TopicsCell

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
    
    TopicsCell *cell = [[TopicsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    cell.alpha = 0;
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *PhImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(kStandardHeight-(kStandardSize*1.1)-kPadding*2, kPadding*0.7, kStandardSize*1.2, kStandardSize*1.2)];
    PhImg2.layer.cornerRadius = PhImg2.frame.size.height/2;
    PhImg2.backgroundColor = [UIColor redColor];
    cell.ActivityIndi = PhImg2;
    //   [cell addSubview:cell.ActivityIndi];
    
    UIImageView *PhImg = [[UIImageView alloc] initWithFrame:CGRectMake(kStandardHeight-kStandardSize-kPadding*2, kPadding, kStandardSize, kStandardSize)];
    PhImg.layer.cornerRadius = kStandardSize/2;
    cell.PlaceholderImg = PhImg;
    [cell addSubview:cell.PlaceholderImg];
    
    
    
    UILabel *OLabel = [[UILabel alloc] initWithFrame:CGRectMake(PhImg.frame.origin.x, PhImg.frame.origin.y, PhImg.frame.size.width, PhImg.frame.size.height)];
    OLabel.textColor = [UIColor whiteColor];
    OLabel.textAlignment = NSTextAlignmentCenter;
    OLabel.font = k_bigfont;
    cell.Onelabel = OLabel;
    [cell addSubview:cell.Onelabel];
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(PhImg.frame.size.width+PhImg.frame.origin.x+kPadding, kPadding, kTableWidth-(PhImg.frame.size.width+PhImg.frame.origin.x+kPadding*2.5), kStandardLabelHeight)];
    HeaderLabel.font = k_buttonfont;
    cell.Hlabel = HeaderLabel;
    [cell addSubview:cell.Hlabel];
    
    UILabel *DetailedLabel = [[UILabel alloc] initWithFrame:CGRectMake(HeaderLabel.frame.origin.x, kPadding*1.2+kStandardLabelHeight, HeaderLabel.frame.size.width, 57.5f)];
    DetailedLabel.font = k_textfont;
    DetailedLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    DetailedLabel.numberOfLines = 2;
    DetailedLabel.adjustsFontSizeToFitWidth = NO;
    cell.Dlabel = DetailedLabel;
    [cell addSubview:cell.Dlabel];
    
    
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
    
    return kStandardHeight;
}

//-- Cronfiguring cell for the individual index
- (void)configureTextForCell:(PFObject *)obj {
    
    NSString *hex  = obj[@"color"];
    UIColor *color = [UIColorExpanded colorWithHexString:hex];
    
    if (([obj[@"Private"] boolValue])? 1 : 0)
         self.Hlabel.text = [NSString stringWithFormat:@"%@ (%@)", [obj objectForKey:@"RoomName"], NSLocalizedString(@"PRIVATEROOM", @"")];
    else
        self.Hlabel.text = [obj objectForKey:@"RoomName"];
    
    self.Hlabel.textColor = color;
    
    self.Dlabel.text = [obj objectForKey:@"RoomDescription"];
    self.Dlabel.textColor =color;
    self.Dlabel.alpha = 0.8;
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.Dlabel.text
                                    attributes:@{NSFontAttributeName: k_textfont}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.Hlabel.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    self.Dlabel.frame = CGRectMake(self.Dlabel.frame.origin.x, self.Dlabel.frame.origin.y, rect.size.width, rect.size.height);

    
    self.Onelabel.text = [NSString stringWithFormat:@"%@", [[self.Hlabel.text substringToIndex:2]uppercaseString]];
    
    self.PlaceholderImg.backgroundColor = color;
    
    
    
}


@end
