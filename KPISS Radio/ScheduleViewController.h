//
//  ScheduleViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 7/27/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "KPISSShow.h"
#import "ScheduleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;
@property (strong, nonatomic) NSMutableArray<KPISSShow*> * showContent;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<KPISSShow*>*> * showContentByDay;
@property (strong,nonatomic) NSIndexPath * selectedCell;
@property (strong,nonatomic) NSMutableArray* notificationList;
- (NSDate*) nextHourDate:(NSDate*)inDate;
@end

NS_ASSUME_NONNULL_END
