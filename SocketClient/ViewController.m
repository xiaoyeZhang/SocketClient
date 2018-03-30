//
//  ViewController.m
//  SocketClient
//
//  Created by 张晓烨 on 2018/3/30.
//  Copyright © 2018年 张晓烨. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "NSObject+GetIP.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressIPTF;
@property (weak, nonatomic) IBOutlet UITextField *portF;

@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showContentMessageTV;

//客户端socket
@property (nonatomic,strong) GCDAsyncSocket *ClientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ClientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.portF.text = @"8080";
    NSString *StringIP = [NSString deviceIPAdress]; //调用方法 获取ip地址 赋值给字符串 stringIP
    NSLog(@"ip地址：%@",StringIP);  //把ip 地址对应后台提供的参数 传给后台
    self.addressIPTF.text = StringIP;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    [self showMessageWithStr:@"连接成功"];
    
    [self showMessageWithStr: [NSString stringWithFormat:@"服务器IP：%@",host]];
    
    [self.ClientSocket readDataWithTimeout:-1 tag:0];
}
//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [self showMessageWithStr:text];
    
    //读取服务端的数据
    [self.ClientSocket readDataWithTimeout:-1 tag:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (IBAction)connectAction:(id)sender {
    //连接服务器
    [self.ClientSocket connectToHost:self.addressIPTF.text onPort:self.portF.text.integerValue withTimeout:-1 error:nil];
    
}
//发送消息
- (IBAction)sendMessageAction:(id)sender {
    if (self.ClientSocket == nil) return;
    
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.ClientSocket writeData:data withTimeout:-1 tag:0];
}

- (IBAction)receivedMessageAction:(id)sender {
      [self.ClientSocket readDataWithTimeout:11 tag:0];
}

- (void)showMessageWithStr:(NSString *)str{
    
    self.showContentMessageTV.text = [self.showContentMessageTV.text stringByAppendingFormat:@"%@\n",str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
