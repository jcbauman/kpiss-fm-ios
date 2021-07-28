//
//  ScheduleTableViewCell.h
//  KPISS Radio
//
//  Created by Jack Bauman on 8/5/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *djLabel;
@property (strong, nonatomic)NSString *showDetails;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *websiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *notificationBtn;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property (weak, nonatomic) IBOutlet NSString *isSpecialShow;

@end

NS_ASSUME_NONNULL_END
