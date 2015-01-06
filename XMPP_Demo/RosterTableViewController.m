//
//  RosterTableViewController.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "RosterTableViewController.h"
#import "XMPPManager.h"
#import "ChatTableViewController.h"

@interface RosterTableViewController ()<XMPPRosterDelegate>

@property (nonatomic, retain) NSMutableArray *rostersArray;

@end

@implementation RosterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 让RosterTableVC成为delegate 来处理好友相关方法
    [[[XMPPManager defaultManager] roster] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.rostersArray = [NSMutableArray arrayWithCapacity:11];
}

#pragma mark ---XMPPRosterDelegate

/**
 *  开始检索
 *
 *  @param sender
 */
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

/**
 *  结束检索
 *
 *  @param sender
 */
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

/**
 *  有几个好友走几次
 *
 *  @param sender
 *  @param item   存储好友信息
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    NSLog(@"item: %@", item);
    NSString *jidStr = [[item attributeForName:@"jid"] stringValue];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    [self.rostersArray addObject:jid];
    
    // 局部刷新tableview
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:self.rostersArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

/**
 *  收到好友请求，才走
 *
 *  @param sender
 *  @param presence
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.rostersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"roster";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    XMPPJID *jid = [self.rostersArray objectAtIndex:indexPath.row];
//    cell.title.text = jid.user;
    cell.textLabel.text = jid.user;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ChatTableViewController *chatVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    XMPPJID *jid = self.rostersArray[indexPath.row];
    chatVC.chatToJID = jid;
}

@end
