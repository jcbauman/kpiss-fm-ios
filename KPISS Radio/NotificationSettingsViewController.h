//
//  NotificationSettingsViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 8/11/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationSettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UIButton *removeAllBtn;
@property (strong, nonatomic) NSMutableArray<NSString*> * notificationList;
- (IBAction)removeAllTapped:(id)sender;
- (IBAction)dismissTaooed:(id)sender;

@end

NS_ASSUME_NONNULL_END
