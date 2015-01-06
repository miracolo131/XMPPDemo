//
//  ChatTableViewController.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "ChatTableViewController.h"
#import "XMPPManager.h"
#import "XMPPFramework.h"

@interface ChatTableViewController ()<XMPPStreamDelegate>

@property (nonatomic, retain) NSMutableArray *messagesArray;

@end

@implementation ChatTableViewController

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
    
    NSLog(@"chatToJID = %@", _chatToJID);
    self.messagesArray = [[NSMutableArray alloc] initWithCapacity:11];
    
    // chatTableVC成为delegate， 处理相关信息的方法
    [[[XMPPManager defaultManager] stream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self reloadMessage];
}

#pragma mark -XMPPStreamDelegate
// 发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}
// 发送消息成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    [self reloadMessage];
}

// 接受消息失败
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

// 接受消息成功
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    [self reloadMessage];
}

/**
 *  加载信息
    从对应的context里取出信息
 */
- (void)reloadMessage
{
    // 1.
    NSManagedObjectContext *context = [[XMPPManager defaultManager] context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@", self.chatToJID.bare, [[[[XMPPManager defaultManager] stream] myJID] bare]];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"查询失败：");
    }else{
        // 1.将数组清空
        [self.messagesArray removeAllObjects];
        // 2.添加元素
        [self.messagesArray addObjectsFromArray:fetchedObjects];
        // 3.刷新
        [self.tableView reloadData];
    }
}
- (IBAction)sendButtonAction:(id)sender {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatToJID];
    [message addBody:@"Bonjour"];
    [[[XMPPManager defaultManager] stream] sendElement:message];
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
    return self.messagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat" forIndexPath:indexPath];
    
    // Configure the cell...
    // 1.获取对应的Model类
    XMPPMessageArchiving_Message_CoreDataObject *object = self.messagesArray[indexPath.row];
    if (object.isOutgoing) {
        cell.detailTextLabel.text = object.message.body;
        cell.textLabel.text = @"";
    }else{
        cell.textLabel.text = object.message.body;
        cell.detailTextLabel.text = @"";
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
