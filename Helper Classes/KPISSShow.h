//
//  KPISSShow.h
//  KPISS Radio
//
//  Created by Jack Bauman on 8/5/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KPISSShow : NSObject{
}

@property (strong,nonatomic) NSString *showName;
@property (strong,nonatomic) NSString *showDJ;
@property (strong,nonatomic) NSDate * startTime;
@property (strong,nonatomic) NSString * showDescription;
@property (strong,nonatomic) NSDate * endTime;
@property (strong,nonatomic) NSString * frequency;
@property (strong,nonatomic) NSString * imageURL;
@property (strong, nonatomic) NSString * websiteLink;
@property (strong, nonatomic) NSString * gCalendarLink;
@property (strong, nonatomic) NSString * eventID;
@property (strong, nonatomic) NSDate * lastEditedDate;
@property (strong, nonatomic) NSString* isSpecialShow;
@property (strong, nonatomic) NSString* recurringEventId;
@end

NS_ASSUME_NONNULL_END
