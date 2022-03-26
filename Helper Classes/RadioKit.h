//
//  RadioKit.h
//  KPISS Radio
//
//  Created by Jack Bauman on 8/6/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPISSShow.h"
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RadioKit : NSObject <AVPlayerItemMetadataOutputPushDelegate>

@property (strong, nonatomic) NSMutableArray<KPISSShow*> * showContent;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<KPISSShow*>*> * showContentByDay;
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic,strong) NSString* isPlaying;
@property (nonatomic,strong) NSDate* scheduleLastUpdatedDatetime;
@property (nonatomic, strong) NSTimer * timer;
@property (strong,nonatomic) NSString* lastMetadataItem;
@property (strong,nonatomic) NSString* aboutPageDescription;
@property (strong,nonatomic) NSString* mainPageImageLink;
@property (strong,nonatomic) NSArray* featuredImages;
@property (strong,nonatomic) NSString* streamURL;


+(RadioKit*)radioKit;

-(void)setShowContentList:(NSMutableArray<KPISSShow *> *)showContentArg;
-(BOOL)updateScheduleNewTime;
-(void)configurePlayer;
-(void)getSchedule;
-(KPISSShow*)getShowByName:(NSString*)name;
-(KPISSShow*)getNextShowByName:(NSString*)name;
-(NSString*)getYoutubeURL;
-(NSString *)getUTCFormateDate:(NSDate *)localDate;
-(BOOL)isShowCancelled:(NSString*)frequency withEndDate:(NSDate*)endTime;
-(NSDate*)adjustForTimeZone:(NSDate*)thisDate withOriginalDate:(NSDate*)originalDate;
-(void) makeShowDataRequest:(NSString*)webLink completionHandler:(void (^)(NSArray *array))completionHandler;
-(void)sortShowContentByDays;


@end

NS_ASSUME_NONNULL_END
