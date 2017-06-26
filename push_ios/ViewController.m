//
//  ViewController.m
//  push_ios
//
//  Created by Bing on 17/3/20.
//  Copyright © 2017年 xinfu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark 通知设置值
-(void)backgroundMessOpeartion{
    [UIApplication sharedApplication].applicationIconBadgeNumber ++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundMessOpeartion) name:@"bgckMess" object:nil];
    [self push1];
}

- (void)push1 {
    NSArray *arr = @[@"14:45:00", @"14:35:00", @"14:55:00"];
    for (int i = 0; i < arr.count; i++) {
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2){
            NSRange range = NSMakeRange(0,obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        NSArray *resultArray = [arr sortedArrayUsingComparator:sort];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger uint = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSTimeZone *zone = [NSTimeZone systemTimeZone];//获取系统的时区
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置时间格式
        [formatter setTimeZone:zone];//设置时区
        NSDate *date = [NSDate date];
        NSString *dateString = [formatter stringFromDate:date];
        NSLog(@"3.1******%@", dateString);
        NSDateComponents *comps = [calendar components:uint fromDate:date];
        int day = (int)[comps weekday];
        int hours = (int)[comps hour];
        int minute = (int)[comps minute];
        int second = (int)[comps second];
        UILocalNotification *localNotifa = [[UILocalNotification alloc] init];
        localNotifa.alertBody = @"通知啊"; // 通知的内容
        //        localNotifa.soundName = @"unbelievable.caf"; //通知的声音  系统的声音
        localNotifa.soundName = UILocalNotificationDefaultSoundName;//使用默认提示音
        localNotifa.alertAction = @":查看"; // 锁屏的时候 相当于 滑动来::查看最新重大新闻
        localNotifa.alertTitle = @"有一天";
        localNotifa.applicationIconBadgeNumber ++;
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        localNotifa.timeZone = [NSTimeZone defaultTimeZone];  // 设置时区
        NSArray *aa = [resultArray[i] componentsSeparatedByString:@":"];
        int time = ([aa[0] intValue]-hours)*3600+([aa[1] intValue]-minute)*60-second;
        localNotifa.fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
        localNotifa.repeatInterval = NSCalendarUnitDay;
        localNotifa.userInfo = @{@"detailMess":[NSString stringWithFormat:@"不要忘记%@哦！", @"吃饭"]};
        //设置userinfo方便撤销
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        localNotifa.userInfo = info;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotifa]; // 调度通知(启动通知)
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
