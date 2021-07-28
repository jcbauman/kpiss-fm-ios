//
//  NotificationSettingsViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 8/11/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "NotificationSettingsViewController.h"
#import "KPISSShow.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationTableViewCell.h"

@interface NotificationSettingsViewController ()

@end

@implementation NotificationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificationList = [[NSMutableArray alloc] init];
    self.notificationTableView.delegate = self;
    self.notificationTableView.dataSource = self;
    self.notificationTableView.backgroundColor = [UIColor yellowColor];
    [self.notificationTableView setBackgroundColor:[UIColor systemYellowColor]];
    
    //get pending notifications
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        [self.notificationList removeAllObjects];
        if(requests.count){
            for(UNNotificationRequest * request in requests){
                [self.notificationList addObject:request.identifier];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.notificationTableView reloadData];
        });
    }];
    
}

#pragma mark TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationList.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationTableViewCell * cell = ((NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"notifCell"]);
    
    if(self.notificationList.count >= indexPath.row){
        cell.cellTite.text = [self.notificationList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(UITableViewCellEditingStyleDelete){
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers: @[self.notificationList[indexPath.row]]];
           [self.notificationList removeObjectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_schedule"
          object:self
        userInfo:@{}];
           [self.notificationTableView reloadData];
       }
}

- (IBAction)dismissTaooed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeAllTapped:(id)sender {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    [self.notificationList removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_schedule"
      object:self
    userInfo:@{}];
    [self.notificationTableView reloadData];
}

@end
