//
//  UserTagsCell.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-27.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "design.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColorExpanded.h"
#import "ExtraFucntions.h"

static NSString *UTCIdentifier = @"UserTagCell";

@interface UserTagsCell : UITableViewCell

+ (void)setTableViewWidth:(CGFloat)tableWidth;
+ (id)CellForTableWidth:(CGFloat)width;
+ (CGFloat)cellHeight:(PFObject *)obj;
- (void)configureTextForCell:(PFObject *)obj;

@property (nonatomic, strong) PFObject *Object;
@property (nonatomic, strong) UIColor *color;


@end
