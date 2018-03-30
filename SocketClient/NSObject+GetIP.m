//
//  NSObject+GetIP.m
//  SocketClient
//
//  Created by 张晓烨 on 2018/3/30.
//  Copyright © 2018年 张晓烨. All rights reserved.
//

#import "NSObject+GetIP.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSObject (GetIP)

//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    NSLog(@"%@", address);
    
    return address;
}

@end
