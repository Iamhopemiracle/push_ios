//
//  AppDelegate.m
//  推送
//
//  Created by Bing on 17/2/23.
//  Copyright © 2017年 xinfu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerNotifa]; // 注册通知
    if (launchOptions [UIApplicationLaunchOptionsLocalNotificationKey]) { // 用户通过通知(App未运行,已经杀死)打开程序,这里通过 Badge 就可以观察到
        UILocalNotification*localNotif=[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
        UILocalNotification *myLocalNotifa = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]; // 返回的是本地通知的对象
        NSDictionary *dicValue = myLocalNotifa.userInfo;
        NSString *detailMess = dicValue[@"detailMess"];
        self.myMess = [NSString stringWithFormat:@"%@(通过通知(App未运行,已经杀死)打开程序,这里是具体的通知信息详情)",detailMess];
        NSLog(@"111111");
        
    }
    else{  // 用户通过App的图片打开的程序
        NSLog(@"用户通过App的图标打开程序");
        application.applicationIconBadgeNumber = 0;
    }
    return YES;
}

#pragma mark 注册用户通知
-(void)registerNotifa{
    // 因为这里系统大于IOS 8.0,所有不需要考虑IOS 8.0 以下
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];//获取系统版本
    if (version >= 8.0) {
        /*
         UIUserNotificationTypeNone    = 0,      不发出通知
         UIUserNotificationTypeBadge   = 1 << 0, 改变应用程序图标右上角的数字
         UIUserNotificationTypeSound   = 1 << 1, 播放音效
         UIUserNotificationTypeAlert   = 1 << 2, 是否运行显示横幅
         */
        UIUserNotificationType notifaType = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
        UIUserNotificationSettings *userNotifi = [UIUserNotificationSettings settingsForTypes:notifaType categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifi];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge];
    }
}

//注册通知成功
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"注册成功---》deviceToken:%@", deviceToken);
}

//注册通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
}

#pragma mark -通知有关的代理方法
/**
 本地推送 ---  App在后台,程序未被杀死,用户点击了本地通知后的操作
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"applicationState:%ld*******%@", (long)application.applicationState, notification.userInfo);
    // 一定要判断App是否在后台
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"%@", notification.userInfo);
    } else {
        // 当前App在后台
        NSLog(@"执行后台对应的操作");
        //        notification.applicationIconBadgeNumber++;
        application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber + 1;
        NSString *strValue = notification.userInfo[@"detailMess"]; // 这里的 userInfo 对应通知的设置信息 userInfo
        self.myMess = [NSString stringWithFormat:@"%@(App在后台且用户点击了通知后,这里是具体的通知信息详情)",strValue];
        NSNotification *notification = [NSNotification notificationWithName:@"bgckMess" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"App还在后台,点击了本地通知后,进入这个方法.得到的本地其他信息:%@", notification.userInfo);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;//推送的消息个数清空
//    [self cancelLocalNotificationWithKey:@"key"];
}

//取消某个本地推送通知
- (void)cancelLocalNotificationWithKey:(NSString*)key {
    //获取所有本地通知数组
    NSArray*localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo) {
            NSLog(@"%@", userInfo);
            //根据设置通知参数时指定的key来获取通知参数
            NSString *infoDic = [userInfo objectForKey:@"userInfo"];
            //如果找到需要取消的通知，则取消
            if(infoDic !=nil) {
                [[UIApplication sharedApplication]cancelLocalNotification:notification];
                break;
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
