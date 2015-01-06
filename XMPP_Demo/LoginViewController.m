//
//  LoginViewController.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPFramework.h"
#import "XMPPManager.h"

@interface LoginViewController ()<XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 当LoginVC 成为delegate， 来处理登陆成功或失败
    NSLog(@"test");
    [[[XMPPManager defaultManager] stream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (IBAction)loginButtonAction:(id)sender {
    
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[XMPPManager defaultManager] loginWithUserName:userName password:password];
}

- (IBAction)registerButtonAction:(id)sender {
}

#pragma mark ----XMPPDelgeate
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    // 登陆成功登陆页面消失， 展现好友列表
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 设置在线状态
    // 1.创建在线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    // 2.向服务器发送状态
    [[[XMPPManager defaultManager] stream] sendElement:presence];
//    // 3.数据持久化
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
    // 同步, 因为NSUserDefaults可能出现延迟
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
