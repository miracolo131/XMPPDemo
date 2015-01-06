//
//  RegisterViewController.m
//  XMPP_Demo
//
//  Created by Miracolo Bosco on 14/12/1.
//  Copyright (c) 2014年 MI-31. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"

@interface RegisterViewController ()<XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegisterViewController

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
    
    // 让RegisterVC成为Delegate， 来处理注册成功或失败的方法
    [[[XMPPManager defaultManager] stream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (IBAction)registerButtonAction:(id)sender {
    
    // 获取注册信息
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 调用XMPPManager中对应方法， 进行连接
    [[XMPPManager defaultManager] registerWithUserName:userName password:password];
}

#pragma mark -- XMPPStreamDelegate
// 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    [self.navigationController popViewControllerAnimated:YES];
}

// 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"%s_%d_| ", __FUNCTION__, __LINE__);
    NSLog(@"注册失败: error = %@", error);
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
