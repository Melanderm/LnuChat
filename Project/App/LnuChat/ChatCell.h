//
//  ChatCell.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-07.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "design.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColorExpanded.h"
#import "DateChecker.h"
#import "ExtraFucntions.h"


static NSString *CIdentifier = @"ChatCell";

@interface ChatCell : UITableViewCell

+ (void)setTableViewWidth:(CGFloat)tableWidth;
+ (id)CellForTableWidth:(CGFloat)width;
+ (CGFloat)cellHeight:(PFObject *)obj;
- (void)configureTextForCell:(PFObject *)obj;

@property (nonatomic, strong) PFObject *Object;
@property (nonatomic, strong) UIColor *color;

@end
