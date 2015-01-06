//
//  AppDelegate.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPManager.h"

@interface AppDelegate ()<XMPPStreamDelegate>



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 取出用户名与密码
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (userName) {
        // 登陆过
        [[XMPPManager defaultManager] loginWithUserName:userName password:password];
        // 验证登陆成功或失败
        [[[XMPPManager defaultManager] stream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }else{
        
        UIStoryboard *storyBoadrd = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:storyBoadrd.instantiateInitialViewController animated:NO completion:nil];

    }
    
    return YES;
}

#pragma mark --XMPPStreamDelegate
// 验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    // 设置在线状态
    // 1.创建在线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    // 2.向服务器发送状态
    [[[XMPPManager defaultManager] stream] sendElement:presence];
}
// 验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
