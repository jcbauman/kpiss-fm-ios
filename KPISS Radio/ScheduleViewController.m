//
//  ScheduleViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 7/27/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "ScheduleViewController.h"
#import "AppDelegate.h"
#import "ScheduleTableViewCell.h"
#import "RadioKit.h"
#import <UserNotifications/UserNotifications.h>
#import "ShowWebViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showContent = [[NSMutableArray alloc] init];
    self.notificationList = [[NSMutableArray alloc] init];
    self.showContentByDay = [[NSMutableArray alloc] init];
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    [self.scheduleTableView setBackgroundColor:[UIColor systemYellowColor]];
    [self.scheduleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule:) name:@"reload_schedule"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    //get showContent
    self.showContent = [RadioKit radioKit].showContent;
    self.showContentByDay =[RadioKit radioKit].showContentByDay;
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        [self.notificationList removeAllObjects];
        if(requests.count){
            for(UNNotificationRequest * request in requests){
                [self.notificationList addObject:request.identifier];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scheduleTableView reloadData];
        });
    }];
    
}

#pragma mark TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath == self.selectedCell){
        return 250;
    } else {
        return 60;
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.showContentByDay objectAtIndex:section].count;
}

-(NSInteger) getShowIndexForIndexPath:(NSIndexPath *)indexPath{
    int returnVal = 0;
    for(int i = 0;i<indexPath.section; i++){
        returnVal += [self.showContentByDay objectAtIndex:i].count;
    }
    returnVal += indexPath.row;
    return returnVal;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleTableViewCell * cell = (ScheduleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"schedCell"];
    KPISSShow* thisShow = [[self.showContentByDay objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.showNameLabel.text = thisShow.showName;
    if(self.selectedCell == indexPath){
        cell.showNameLabel.text = thisShow.showName;
        if(thisShow.imageURL){
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: thisShow.imageURL]];
            if(data){
                cell.backgroundImage.image = [UIImage imageWithData:data];
            } else {
                cell.backgroundImage.image = NULL;
            }
        }
        if([thisShow.showDescription length] != 0){
                    cell.descriptionText.text = thisShow.showDescription;
                } else {
        cell.descriptionText.text = @"Tap the bell icon to get reminded when the next show starts";
                }
    }
    
    //format showtime
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h"];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@" - ha"];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormat setLocale:locale];
    [dateFormat2 setLocale:locale];
    
    NSString * timeString = [dateFormat stringFromDate:thisShow.startTime];
    NSString * timeString2 = [[timeString stringByAppendingString:[dateFormat2 stringFromDate:thisShow.endTime]] uppercaseString];
    cell.timeLbl.text = timeString2;
    
    if(self.selectedCell != indexPath){
        cell.websiteBtn.hidden = YES;
        cell.notificationBtn.hidden = YES;
        cell.djLabel.hidden = YES;
        cell.backgroundImage.hidden = YES;
        //cell.descriptionText.hidden = YES;
    } else {
        if(thisShow.websiteLink){
        cell.websiteBtn.hidden = NO;
        }
        cell.notificationBtn.hidden = NO;
        cell.djLabel.hidden = NO;
//        cell.backgroundImage.hidden = NO;
        //cell.descriptionText.hidden = NO;
        [cell.djLabel setText:thisShow.showDJ];
        if(![self.notificationList containsObject:thisShow.showName]){
            [cell.notificationBtn setImage:[UIImage systemImageNamed:@"bell"] forState:UIControlStateNormal];
        }else{
            [cell.notificationBtn setImage:[UIImage systemImageNamed:@"bell.fill"] forState:UIControlStateNormal];
        }
    }
    cell.websiteBtn.tag = [self getShowIndexForIndexPath:indexPath ];
    cell.isSpecialShow = thisShow.isSpecialShow != nil ? thisShow.isSpecialShow : @"false";
    cell.notificationBtn.tag = [self getShowIndexForIndexPath:indexPath] + 999;
    [cell.websiteBtn addTarget:self action:@selector(websiteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.notificationBtn addTarget:self action:@selector(notificationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [generator impactOccurred];
    if(self.selectedCell != indexPath){
        self.selectedCell = indexPath;
                if(!self.showContentByDay[indexPath.section][indexPath.row].imageURL){
                    [[RadioKit radioKit] makeShowDataRequest:self.showContentByDay[indexPath.section][indexPath.row].websiteLink completionHandler:^(NSArray *returnArray) {
                        if(returnArray.count > 1){
//                            self.showContentByDay[indexPath.section][indexPath.row].imageURL = returnArray[0];
                            self.showContentByDay[indexPath.section][indexPath.row].showDescription = returnArray[1];
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView reloadData];
                            });
                        }
                    }];

                }
    } else {
        self.selectedCell = NULL;
    }
    [tableView reloadData];
}

-(void)websiteBtnPressed:(UIButton*)sender{
    if([RadioKit radioKit].showContent.count >= sender.tag){
        NSURL * URL = [NSURL URLWithString:[RadioKit radioKit].showContent[sender.tag].websiteLink];
        if( [[UIApplication sharedApplication] canOpenURL:URL])
            [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
                return;
            }];
        //        NSURL *URL = [NSURL URLWithString:[RadioKit radioKit].showContent[sender.tag].websiteLink];
        //        if(URL){
        //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        //            ShowWebViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"showDetailsVc"];
        //            vc.websiteLink = URL;
        //            [self presentViewController:vc animated:YES completion:nil];
        //        }
    }
}

#pragma mark Notifications

-(void)notificationBtnPressed:(UIButton*)sender{
    NSLog(@"notification pressed");
    if([RadioKit radioKit].showContent.count >= (sender.tag - 999)){
        UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [generator impactOccurred];
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                NSLog(@"user notifications accepted and are all good");
                dispatch_async(dispatch_get_main_queue(), ^{
                    KPISSShow * thisShow = [RadioKit radioKit].showContent[sender.tag - 999];
                    [self scheduleNotification:thisShow];
                });
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showContentByDay.count;
}

-(void)scheduleNotification:(KPISSShow*)thisShow{
    KPISSShow * showToSchedule = thisShow;
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    if([self.notificationList containsObject:showToSchedule.showName]){
        //remove existing notification
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers: @[showToSchedule.showName]];
        [self.notificationList removeObjectAtIndex: [self.notificationList indexOfObject:showToSchedule.showName]];
        [self.scheduleTableView reloadData];
    } else {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        [content setTitle:showToSchedule.showName];
        [content setBody:@"Starting now on KPISS.FM"];
        [content setSound:[UNNotificationSound defaultSound]];
        //NSTimeInterval triggerInterval = [[[NSDate date] dateByAddingTimeInterval:10] timeIntervalSinceDate:[NSDate date]];
        NSTimeInterval triggerInterval = [showToSchedule.startTime timeIntervalSinceDate:[NSDate date]];
        if(triggerInterval <= 0){
            showToSchedule = [[RadioKit radioKit] getNextShowByName:showToSchedule.showName];
            triggerInterval = [showToSchedule.startTime timeIntervalSinceDate:[NSDate date]];
            if(triggerInterval <= 0 ){
                NSLog(@"cannot schedule notification");
                return;
            }
        }
        
        UNTimeIntervalNotificationTrigger * trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:triggerInterval repeats:NO];

        
        UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:showToSchedule.showName content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error);
            } else {
                NSLog(@"addedNotification");
                if(![self.notificationList containsObject:showToSchedule.showName]){
                    [self.notificationList addObject:showToSchedule.showName];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.scheduleTableView reloadData];
                    });
                }
            }
        }];
    }
}


-(void)reloadSchedule:(id)sender{
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        [self.notificationList removeAllObjects];
        if(requests.count){
            for(UNNotificationRequest * request in requests){
                [self.notificationList addObject:request.identifier];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scheduleTableView reloadData];
        });
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 16)];
    [label setFont:[UIFont fontWithName:@"Avenir Black" size:16]];
    [label setText:@"MORE SHOWS..."];
    if(self.showContentByDay.count > 0){
        if([self.showContentByDay objectAtIndex:section].count > 0){
        KPISSShow* firstShowInSection = [[self.showContentByDay objectAtIndex:section] objectAtIndex:0];
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat: @"EEEE"];
            if(section > 6){
        [weekday setDateFormat: @"EEEE, MMMM d"];
            }
            NSString* sectionTitle = [[weekday stringFromDate:firstShowInSection.startTime ] uppercaseString];
            [label setText:sectionTitle];
    }
    }
    view.layer.shadowOpacity = 0.2;
    view.layer.shadowOffset = CGSizeMake(0, 5);
    view.layer.shadowRadius = 1;
   [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:72.0/255.0 blue:105.0/255.0 alpha:1.0]];
   return view;
}

@end
