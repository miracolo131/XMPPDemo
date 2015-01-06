//
//  XMPPManager.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "XMPPManager.h"

@interface XMPPManager ()<XMPPStreamDelegate>

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userName;

// 和服务器连接的目的
@property (nonatomic, assign) ConnectToServerPurpose connectToServerPurpose;

@end

@implementation XMPPManager

+ (XMPPManager *)defaultManager
{
    static XMPPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc] init];
    });
    return manager;
}

// 重写init方法， 给对应属性赋值
- (instancetype)init
{
    if (self = [super init]) {
        
        self.stream = [[XMPPStream alloc] init];
        
        // 1.设置服务器
        self.stream.hostName = kHostName;
        self.stream.hostPort = kHostPort;
        
        // 2.设置代理，处理反馈信息
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // 3.好友列表
        XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        // 4.激活
        [self.roster activate:self.stream];
        
        // 5.信息检索
        XMPPMessageArchivingCoreDataStorage *messageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:messageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        self.context = messageArchivingCoreDataStorage.mainThreadManagedObjectContext;
        // 激活
        [self.messageArchiving activate:self.stream];
    }
    return self;
}

/**
 *  和服务器进行连接
 */
- (void)connectToServer
{
    if ([self.stream isConnected]) {
        
        // 如果已经建立练剑，需要先断开原来的连接
        [self disconnectFromServer];
        
    }
        
    NSError *error = nil;
    // 建立连接
    [self.stream connectWithTimeout:15 error:&error];
    
    // 1.创建JID
    XMPPJID *jid = [XMPPJID jidWithUser:self.userName domain:kDomin resource:kResource];
    // 2. 设置Stream的myJID
    self.stream.myJID = jid;
    [self.stream connectWithTimeout:15 error:&error];
    
    if (error) {
            
        NSLog(@"连接失败：error = %@", error);
        
    }
}

/**
 *  从服务器断开
 */
- (void)disconnectFromServer
{
    // 从通道断开
    [self.stream disconnect];
}

/**
 *  获取登录名密码，与服务器连接
 *
 *  @param userName  用户名
 *  @param passsword 密码
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)passsword
{
    self.userName = userName;
    self.password = passsword;
    
    // 设置连接目的
    self.connectToServerPurpose = ConnectToServerPurposeLogin;
    
    [self connectToServer];
}

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password
{
    self.userName = userName;
    self.password = password;
    self.connectToServerPurpose = ConnectToServerPurposeRegister;
    [self connectToServer];
}


#pragma mark -XMPPStreamDelegate

// 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    // 登陆
    NSError *error = nil;
    
    switch (self.connectToServerPurpose) {
        case ConnectToServerPurposeLogin:
            
            // 进行认证
            [self.stream authenticateWithPassword:self.password error:&error];
            
            break;
            
        case ConnectToServerPurposeRegister:
            
            // 向服务器进行注册
            [self.stream registerWithPassword:self.password error:&error];
            
            break;
    }
    
    if (error) {
        NSLog(@"认证失败：%@", error);
    }
}

// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

@end
