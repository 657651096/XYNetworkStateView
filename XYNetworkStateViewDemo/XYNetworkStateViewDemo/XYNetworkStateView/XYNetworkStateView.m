//
//  XYNetworkStateView.m
//  XYNetworkStateViewDemo
//
//  Created by 肖尧 on 16/11/26.
//  Copyright © 2016年 肖尧. All rights reserved.
//

#import "XYNetworkStateView.h"
#import "Reachability.h"

@implementation XYNetworkStateView
{
    Reachability* _reachability;
}

+(instancetype)netWorkStateTipsView{
    return [[NSBundle mainBundle] loadNibNamed:@"XYNetworkStateView" owner:nil options:nil].lastObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    //监听网络状态改变
    [self checkNetWorkState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
}

//检查网络状态
-(void)checkNetWorkState{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    self.hidden = (netStatus == NotReachable) ? NO : YES;
}

//网络状态改变
- (void)reachabilityChanged{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"没网", @"Text field text for access is not available");
            self.hidden = NO;
            break;
        }
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"2G/3G/4G", @"");
            self.hidden = YES;
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"无线网", @"");
            self.hidden = YES;
            break;
        }
    }
    NSLog(@"%@", statusString);
}

-(void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
