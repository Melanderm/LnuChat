//
//  UserTable.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-26.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "UserTable.h"

@interface UserTable ()

@end

@implementation UserTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"DidUpdateTag" object:nil];
     [UserTagsCell setTableViewWidth:self.view.frame.size.width];

}

-(void)updateTable {
    NSLog(@"UserTable int: %lu", (unsigned long)_usersArray.count);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _usersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell * cell = [self customCellForIndex:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            PFObject *object = [_usersArray objectAtIndex:indexPath.row];
            [(UserTagsCell *)cell  configureTextForCell:object];
            
            return cell;
            
        }
            
        default: return nil;
    }
    
    
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = UTCIdentifier;
    cell = [self.tableView dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [UserTagsCell CellForTableWidth:self.tableView.frame.size.width];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *obj = [_usersArray objectAtIndex:indexPath.row];
    NSDictionary* userInfo = @{@"User": obj[@"name"], @"Username": obj[@"username"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeText" object:obj userInfo:userInfo];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
