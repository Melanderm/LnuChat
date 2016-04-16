//
//  ChatCell.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-02.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ChatCell.h"

static CGFloat kTableWidth = -1;
static CGFloat kPadding = 10.0f;
static CGFloat kStandardSize = 28.0f;
static CGFloat kStandardLabelHeight = 15.0f;

@interface ChatCell ()
{
    
}
@property (weak, nonatomic) UIImageView *bk;
@property (weak, nonatomic) UIImageView *PlaceholderImg;
@property (weak, nonatomic) UIImageView *bkImage;
@property (weak, nonatomic) UIImageView *markerImg;
@property (weak, nonatomic) UILabel *Onelabel;
@property (weak, nonatomic) UILabel *Hlabel;
@property (weak, nonatomic) UILabel *Dlabel;
@property (weak, nonatomic) UILabel *DateLabel;


@end

@implementation ChatCell

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
    
    ChatCell *cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CIdentifier];
    cell.alpha = 0;
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *PhImg = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding+3, kPadding, kStandardSize, kStandardSize)];
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
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kStandardSize+kPadding*2, kPadding, kTableWidth-(PhImg.frame.size.width+PhImg.frame.origin.x+kPadding*2.5), kStandardLabelHeight)];
    HeaderLabel.font = k_smallfont;
    cell.Hlabel = HeaderLabel;
    [cell addSubview:cell.Hlabel];
    
    UIImageView *bkImg = [[UIImageView alloc] initWithFrame:CGRectMake(kStandardSize+(kPadding*2)-3, kPadding-3, kTableWidth-(kPadding*3)-kStandardSize+6, 57.5f)];
    bkImg.layer.cornerRadius = 5;
    cell.bkImage = bkImg;
    [cell addSubview:cell.bkImage];
    
    UILabel *DetailedLabel = [[UILabel alloc] initWithFrame:CGRectMake(kStandardSize+kPadding*2, kPadding+kStandardLabelHeight, kTableWidth-(kPadding*3)-kStandardSize, 57.5f)];
    DetailedLabel.textAlignment = NSTextAlignmentLeft;
    DetailedLabel.font = k_textfont;
    DetailedLabel.textColor = [UIColor grayColor];
    DetailedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    DetailedLabel.numberOfLines = 0;
    cell.Dlabel = DetailedLabel;
    [cell addSubview:cell.Dlabel];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(DetailedLabel.frame.size.width + DetailedLabel.frame.origin.x, DetailedLabel.frame.size.height+DetailedLabel.frame.origin.y, kTableWidth-(kPadding*3)-kStandardSize, 10)];
    date.font = k_smallfont;
    date.textAlignment = NSTextAlignmentRight;
    date.textColor = [UIColor lightGrayColor];
    cell.DateLabel = date;
    [cell addSubview:cell.DateLabel];
    
    
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
    
    CGSize labelSize = [ChatCell LabelSize:obj[@"Message"]];
    CGFloat labelHeight = labelSize.height;
    CGFloat result = labelHeight+(kPadding*2)+kStandardLabelHeight+25;
    
    if (result < 70) {
        result = 70;
    }
    return result;
}

+(CGSize)LabelSize:(NSString *)string {
    CGSize constrained = CGSizeMake(kTableWidth-(kPadding*3)-kStandardSize, 1000);
    CGSize labelSize = [string sizeWithFont:k_textfont
                          constrainedToSize:constrained
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize;
}

//-- Cronfiguring cell for the individual index
- (void)configureTextForCell:(PFObject *)obj {
    
    NSString *hex  = obj[@"ChatRoom"][@"color"];
    UIColor *color = [UIColorExpanded colorWithHexString:hex];
    
    NSString *message = obj[@"Message"];
    self.PlaceholderImg.backgroundColor = color;
    
    
    self.Hlabel.text = [obj[@"Author"][@"name"] uppercaseString];
    self.Hlabel.textColor = color;
    
    CGSize labelSize = [ChatCell LabelSize:message];
    CGFloat labelHeight = labelSize.height;
    CGFloat result = labelHeight+(kPadding*2)+kStandardLabelHeight+25;
    if (result < 70) {
        result = 70;
    }

    self.markerImg.frame = CGRectMake(0, 0, 4, result);
    self.markerImg.backgroundColor = color;
    
    
    self.DateLabel.frame = CGRectMake(kStandardSize+kPadding*2, kPadding+kStandardLabelHeight+8+labelHeight+15, kTableWidth-(kStandardSize+kPadding*3), 10);
    self.DateLabel.textColor = color;
    self.DateLabel.alpha = 0.5;
    int edited = ([obj[@"Edited"] boolValue])? 1 : 0;
    if (edited == 1)
        self.DateLabel.text = [NSString stringWithFormat:@"%@ | %@", NSLocalizedString(@"EDITED", @"Edited"),[DateChecker ReturnCorrectDateSetup:obj.createdAt]];
    else
        self.DateLabel.text = [DateChecker ReturnCorrectDateSetup:obj.createdAt];

    self.Dlabel.frame = CGRectMake(kStandardSize+kPadding*2, kPadding+kStandardLabelHeight+5, kTableWidth-(kPadding*3)-kStandardSize, labelHeight);
    self.Dlabel.text = message;
    [self.Dlabel sizeToFit];

    
    if (obj[@"Author"][@"Profilepic"] != NULL) {
        self.Onelabel.text = @"";
        PFFile *userImageFile = obj[@"Author"][@"Profilepic"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                self.PlaceholderImg.image = image;
                self.PlaceholderImg.layer.cornerRadius = kStandardSize/2;
                
            }} progressBlock:^(int percentDone) {
                
                
            }];
        
    } else {
        self.PlaceholderImg.backgroundColor = color;
         self.PlaceholderImg.image = nil;
        self.Onelabel.text = [NSString stringWithFormat:@"%@", [ExtraFucntions FirstLetters:obj[@"Author"][@"name"]]];
        
    }



}


@end
