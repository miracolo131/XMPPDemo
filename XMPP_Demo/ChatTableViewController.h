//
//  ChatTableViewController.h
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@interface ChatTableViewController : UITableViewController

@property (nonatomic, retain) XMPPJID *chatToJID;

@end
