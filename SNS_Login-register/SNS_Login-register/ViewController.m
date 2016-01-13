//
//  ViewController.m
//  SNS_Login-register
//
//  Created by xyz on 15/9/22.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "ViewController.h"

#import "NetInterface.h"
#import "LZXHttpDownload.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)loginclick:(id)sender;
- (IBAction)registerClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - 登录
- (IBAction)loginclick:(id)sender {
    if (self.usernameTextField.text.length == 0||self.passwdTextfield.text.length == 0) {
        [self showAlertViewWithTitle:@"警告" message:@"用户名/密码"];
        return;
    }
    //发送post 请求
    LZXHttpDownload *httpRequest = [[LZXHttpDownload alloc] init];
    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@",self.usernameTextField.text,self.passwdTextfield.text];
    //提交拼接的参数
    [httpRequest postDataWithUrl:kLoginUrl params:str success:^(NSData *downloadData) {
        if (downloadData) {
            //json 解析
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dict:%@",dict);
            if ([dict[@"code"]isEqualToString:@"login_success"]) {
                [self showAlertViewWithTitle:@"恭喜" message:dict[@"message"]];
                //保存 m_auth 这是 登录之后服务器给客户端的token (手机令牌)
                //保存到本地  NSUserDefaults保存在沙盒目录下Library/Preferences/xxx.plist
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"m_auth"] forKey:@"snstoken"];
                //同步到本地磁盘
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                [self showAlertViewWithTitle:@"警告" message:dict[@"message"]];
            }
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"网络异常");
    }];
}
/*
 dict:{
 code = "login_success";
 expiretime = 31536000;
 "m_auth" = "91abFbYoCm4qZ4eCMGaQCklF6OST+UMaJaviFPlQj3G/ZNmUOHD5qnFQg91cjxzc2u4UrDsCm4YWer4SLepUQUnEkec";
 message = "\U767b\U5f55\U6210\U529f\U4e86\Uff0c\U73b0\U5728\U5f15\U5bfc\U60a8\U8fdb\U5165\U767b\U5f55\U524d\U9875\U9762 ";
 uid = 142873;
 }

 */

#pragma mark - 注册
//登录注册要提交数据那么做 post 请求
- (IBAction)registerClick:(id)sender {
    if (self.usernameTextField.text.length == 0||self.passwdTextfield.text.length == 0||self.emailTextField.text.length == 0) {
        [self showAlertViewWithTitle:@"警告" message:@"用户名/密码/邮箱不能为空"];
        return;
    }
    /*
     #define kRegisterUrl @"http://10.0.8.8/sns/my/register.php"
     //参数?username=%@&password=%@&email=%@
     */
    LZXHttpDownload *httpRequest = [[LZXHttpDownload alloc] init];
    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@&email=%@",self.usernameTextField.text,self.passwdTextfield.text,self.emailTextField.text];
    //发送请求
    [httpRequest postDataWithUrl:kRegisterUrl params:str success:^(NSData *downloadData) {
        if (downloadData) {
            //json 数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dict:%@",dict);
            if ([dict[@"code"] isEqualToString:@"registered"]) {
                [self showAlertViewWithTitle:@"恭喜" message:dict[@"message"]];
            }else {
                [self showAlertViewWithTitle:@"警告" message:dict[@"message"]];
                NSLog(@"失败:%@",dict[@"message"]);
            }
        }
        
    } failedBlock:^(NSError *error) {
        NSLog(@"网络异常");
    }];
}
/*
 dict:{
 code = registered;
 "m_auth" = "<null>";
 message = "\U6ce8\U518c\U6210\U529f\U4e86\Uff0c\U8fdb\U5165\U4e2a\U4eba\U7a7a\U95f4";
 }
 */

//弹出警告框
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        //収键盘
    [self.usernameTextField resignFirstResponder];
    [self.passwdTextfield resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

@end






