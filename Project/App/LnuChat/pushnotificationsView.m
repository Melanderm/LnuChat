//
//  pushnotificationsView.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-28.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "pushnotificationsView.h"
#import "UIColorExpanded.h"

@interface pushnotificationsView ()

@end

@implementation pushnotificationsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _color = [UIColorExpanded colorWithHexString:@"#f1c40f"];
    
    [self setTitle:@"Pushnotiser"];
    
    [[UIView appearance] setTintColor:_color];
    UIBarButtonItem *newback = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newback];
    [self.navigationController.navigationBar setTintColor:_color];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    NSDictionary *obj = @{ @"text" : @"Om du blir taggad:",
                           @"color" : _color};
    NSDictionary *obj2 = @{ @"text" : @"Pushnotiser:",
                     @"color" : _color};    


    _Array = [[NSMutableArray alloc] initWithObjects:obj, obj2, nil];
    
   
}


-(void)viewDidAppear:(BOOL)animated {
    // adding these in viewDidAppear because the bounds.size.width is calculated after the view is shown.
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = k_lightGray;
    [self.table setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.view addSubview:self.table];
    [pushnotificationsCell setTableViewWidth:self.view.frame.size.width];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [titleView setFont:k_midfont];
        titleView.textColor = _color;
        titleView.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _Array.count-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell * cell = [self customCellForIndex:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            PFObject *obj = [_Array objectAtIndex:indexPath.row];
            [(pushnotificationsCell *)cell  configureTextForCell:obj];
            
            return cell;

        }
            
        default: return nil;
    }
    
    
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = PNCIdentifier;
    cell = [self.table dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [pushnotificationsCell CellForTableWidth:self.table.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}


@end
