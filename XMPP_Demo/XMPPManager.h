//
//  XMPPManager.h
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//  用于客户端与服务器的数据处理类

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef enum : NSUInteger {
    ConnectToServerPurposeLogin,
    ConnectToServerPurposeRegister,
} ConnectToServerPurpose;


@interface XMPPManager : NSObject

// 通信管道
@property (nonatomic, retain) XMPPStream *stream;
// 好友列表
@property (nonatomic, retain) XMPPRoster *roster;

// 信息检索
@property (nonatomic, retain) XMPPMessageArchiving *messageArchiving;

// 上下文
@property (nonatomic, retain) NSManagedObjectContext *context;

+ (XMPPManager *) defaultManager;

// 获取登陆用户名与密码, 以登陆的形式和服务器进行连接
- (void)loginWithUserName:(NSString *)userName password:(NSString *)passsword;
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password;

//

@end
