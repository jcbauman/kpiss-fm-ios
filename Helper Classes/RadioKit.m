//
//  RadioKit.m
//  KPISS Radio
//  Singleton class handling stream and schedule
//
//  Created by Jack Bauman on 8/6/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "RadioKit.h"
#import "KPISSShow.h"
#import <AVKit/AVKit.h>
#import <GTMNSString+HTML.h>

@implementation RadioKit

@synthesize player;
@synthesize playerItem;
@synthesize isPlaying;

+(RadioKit*) radioKit{
    static RadioKit* radioKit = nil;
    if(!radioKit){
        radioKit = [[super allocWithZone:nil] init];
    }
    return radioKit;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self radioKit];
}

-(id) init {
    NSLog(@"initing radioKit");
    self = [super init];
    if(self){
        self.showContent = [[NSMutableArray alloc] init];
//        [self makeShowDataRequest:@"https://kpiss.fm/show/lunar-rotation" completionHandler:^(NSArray *returnArray) {
//         }];
        //[self getSchedule];
            [self configurePlayer];
        self.isPlaying = @"NO";
        self.lastMetadataItem = @"Live Talk Radio";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromBackground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}

#pragma mark Schedule
-(void)getSchedule{
    NSString *APIurl = @"https://www.googleapis.com/calendar/v3/calendars/kpiss.fm_m0i5spckdijuki5dbhvg9d2jos%40group.calendar.google.com/events?maxResults=2500&key=AIzaSyC_EoCXV-7np1V30Ft1JGDqNaBHW1DoLag";
    
    NSURL * url = [NSURL URLWithString:APIurl];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *data = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error && !response){
            NSLog(@"GOOGLE API error: getting shows");
        }
        
        if (data!=nil) {
            
            NSMutableDictionary *json = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error ] mutableCopy];
            
            NSMutableArray * showScheduleHelper = [NSMutableArray array];
            if (json.count > 0) {
                if(((NSDictionary*)[json valueForKey:@"items"]).count){
                    if(((NSDictionary*)[json valueForKey:@"items"]).count){
                        for(NSDictionary * entry in [json valueForKey:@"items"]){
                            KPISSShow * thisShow = [[KPISSShow alloc] init];
                            NSString * fullShowName = [[entry valueForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            NSRange wRange = [fullShowName rangeOfString:@" w/"];
                            if(wRange.location != NSNotFound){
                                thisShow.showName = [fullShowName substringToIndex:wRange.location];
                                thisShow.showDJ = [fullShowName substringFromIndex:wRange.location + 4];
                            } else {
                                thisShow.showName = fullShowName;
                                thisShow.showDJ = @"KPISS DJ";
                            }
//                            if([entry valueForKey:@"location"]){
//                                if(![[entry valueForKey:@"location"] isEqualToString:@"www.kpiss.fm"]){
//                                    thisShow.imageURL = [entry valueForKey:@"location"];
//                                }
//                            }
                            thisShow.frequency = ((NSArray*)[entry valueForKey:@"recurrence"])[0];
                            thisShow.recurringEventId = ((NSString*)[entry valueForKey:@"recurringEventId"]);
                            if([entry valueForKey:@"description"]){
                                NSArray *arrayOfComponents = [[entry valueForKey:@"description"] componentsSeparatedByString:@"\""];
                                if(arrayOfComponents.count > 2){
                                    if([arrayOfComponents[1] containsString:@"kpiss.fm"]){
                                        NSString * webLink = arrayOfComponents[1];
                                        webLink = [webLink substringToIndex:webLink.length];
                                        thisShow.websiteLink = webLink;
                                    }
                                } else if([[entry valueForKey:@"description"] containsString:@"kpiss.fm/show/"]){
                                    thisShow.websiteLink = [entry valueForKey:@"description"];
                                }
                            }
                            thisShow.lastEditedDate = [entry valueForKey:@"updated"];
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
                            dateFormat.locale = [[NSLocale alloc]
                                                 initWithLocaleIdentifier:@"en_US"];
                            dateFormat.timeZone = [[NSTimeZone alloc]
                                                   initWithName:@"UTC"];
                            
                            NSDate *startDate = [dateFormat dateFromString:[((NSDictionary*)[entry valueForKey:@"start"]) objectForKey:@"dateTime"]];
                                                    
                            
                            if([[[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate] minute] == 59){
                                thisShow.startTime = [startDate dateByAddingTimeInterval:60];
                            } else {
                                thisShow.startTime = startDate;
                            }
                            
                            //                            //accomodate time change
                            //                            int eventOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:thisShow.startTime];
                            //                            int nowOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[NSDate date]];
                            //                            thisShow.startTime = [thisShow.startTime dateByAddingTimeInterval:(eventOffset - nowOffset)];
                            
                            
                            NSDate *endDate = [dateFormat dateFromString:[((NSDictionary*)[entry valueForKey:@"end"]) objectForKey:@"dateTime"]];
                            
                            if([[[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate] minute] == 59){
                                thisShow.endTime = [endDate dateByAddingTimeInterval:60];
                            } else {
                                thisShow.endTime = endDate;
                            }
                            
                            //                            //accomodate time change
                            //                            eventOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:thisShow.endTime];
                            //                            nowOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[NSDate date]];
                            //                            thisShow.endTime = [thisShow.endTime dateByAddingTimeInterval:(eventOffset - nowOffset)];
                            
                            thisShow.eventID = [entry valueForKey:@"id"];
                            thisShow.isSpecialShow = @"false";
                            if(![self isShowCancelled:thisShow.frequency withEndDate:thisShow.endTime]){
                                [showScheduleHelper addObject:thisShow];
                            }
                        }
                        [self filterShowContent:showScheduleHelper.mutableCopy];
                    }
                }
            }
        }
    }];
    [data resume];
}

//filter/sort shows that have already happened
-(void)filterShowContent:(NSMutableArray<KPISSShow*>*)showScheduleFromApi{
    
    //find the relevant recurrence of this event
    NSMutableArray<KPISSShow*> * showScheduleHelper = showScheduleFromApi.mutableCopy;
    if(showScheduleHelper.count > 0){
        NSDate * now = [NSDate date];
        NSDate * inTwoWeeks = [now dateByAddingTimeInterval:60*60*24*14 + 360];
        
        for(int i = 0; i < showScheduleHelper.count; i++){
            if(i >= 0 && i < showScheduleHelper.count){
                KPISSShow* thisShow = ((KPISSShow*)showScheduleHelper[i]);
                if([thisShow.showName isEqualToString:@"Lunar Rotation"]){
                    NSLog(@"groove");
                }
                NSDate * relevantDate = thisShow.endTime;
                NSInteger offset = 60*60*24;
                if([thisShow.frequency isEqualToString:@""]){
                    offset = 0;
                } else if(([thisShow.frequency rangeOfString:@"UNTIL="].location == NSNotFound) || ![self isShowCancelled:thisShow.frequency withEndDate:thisShow.endTime]){
                    if([thisShow.frequency rangeOfString:@"FREQ=WEEKLY"].location == NSNotFound){
                        //daily - do niente
                    } else if([thisShow.frequency rangeOfString:@"INTERVAL=2"].location == NSNotFound){
                        //weekly
                        offset *= 7;
                    } else {
                        //biweekly
                        offset *= 14;
                    } if([thisShow.frequency rangeOfString:@"FREQ=MONTHLY"].location != NSNotFound){
                        //monthly - weird, delete
                        offset = 0;
                    }
                    
                }
                else {
                    offset = 0;
                }
                
                //find show date in correct range
                if(thisShow.frequency == nil && thisShow.showName != nil && thisShow.recurringEventId == nil){
                    thisShow.isSpecialShow = @"true";
                }
                else if(offset == 0){
                    [showScheduleHelper removeObjectAtIndex:i];
                    i--;
                } else {
                    while([now compare:relevantDate] == NSOrderedDescending){
                        NSDate * newRelevantDate = [relevantDate dateByAddingTimeInterval:offset];
                        if( [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:newRelevantDate] != [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:relevantDate]){
                            newRelevantDate =[self adjustForTimeZone:newRelevantDate withOriginalDate:relevantDate];
                        }
                        relevantDate = newRelevantDate;
                    }
                
                
                    //                    relevantDate = [self adjustForTimeZone:relevantDate withOriginalDate:thisShow.endTime];
                    NSTimeInterval showLength = [thisShow.startTime timeIntervalSinceDate:thisShow.endTime];
                    thisShow.endTime = relevantDate;
                    thisShow.startTime = [relevantDate dateByAddingTimeInterval:showLength];
                    [showScheduleHelper replaceObjectAtIndex:i withObject:thisShow];
                    
                    
                    //cover repeated/weekly shows
                    NSDate * nextDate = [thisShow.endTime dateByAddingTimeInterval:offset];
                    int count = 0;
                    while([now compare:nextDate] == NSOrderedAscending && [inTwoWeeks compare:nextDate] == NSOrderedDescending){
                        
                        //copy object
                        KPISSShow* nextShow = [[KPISSShow alloc] init];
                        nextShow.showName = thisShow.showName;
                        nextShow.showDJ = thisShow.showDJ;
                        nextShow.frequency = thisShow.frequency;
                        nextShow.imageURL = thisShow.imageURL;
                        nextShow.websiteLink = thisShow.websiteLink;
                        nextShow.gCalendarLink = thisShow.gCalendarLink;
                        nextShow.showDescription = thisShow.showDescription;
                        nextShow.eventID = thisShow.eventID;
                        nextShow.lastEditedDate = thisShow.lastEditedDate;
                        nextShow.endTime = nextDate;
                        nextShow.startTime = [nextDate dateByAddingTimeInterval:showLength];
                        [showScheduleHelper insertObject:nextShow atIndex:i+1];
                        nextDate = [nextDate dateByAddingTimeInterval:offset];
                        count++;
                    }

                } if([inTwoWeeks compare:relevantDate] == NSOrderedAscending){
                    [showScheduleHelper removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        //remove duplicates
        showScheduleHelper = [[showScheduleHelper valueForKeyPath:@"@distinctUnionOfObjects.self"] mutableCopy];
        
        //sort by ascending time
        [showScheduleHelper sortUsingDescriptors:
         @[
             [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES]
         ]];
        
        //        //delete shows in same time slot by hierarchy of last updated
        //        for(int i = 0; i < showScheduleHelper.count-1; i++){
        //            if(i<0 && i<showScheduleHelper.count-1){
        //                if(showScheduleHelper[i].endTime == showScheduleHelper[i+1].endTime){
        //
        //                    //TO-DO update if there are 2 streams
        //                    if([showScheduleHelper[i].lastEditedDate compare:showScheduleHelper[i+1].lastEditedDate] == NSOrderedAscending){
        //                        [showScheduleHelper removeObjectAtIndex:i];
        //                    }else {
        //                        [showScheduleHelper removeObjectAtIndex:i+1];
        //                    }
        //                    i--;
        //                }
        //            }
        //
        //        }
        
        //collapse repeat shows in format Part 1, Part 2
        for(int i = 0; i < showScheduleHelper.count-1; i++){
            if(i>=0 && i<showScheduleHelper.count-1){
                if([[showScheduleHelper[i].showName substringToIndex:showScheduleHelper[i].showName.length-2] isEqualToString:[showScheduleHelper[i+1].showName substringToIndex:showScheduleHelper[i+1].showName.length-2]]){
                    showScheduleHelper[i].endTime = showScheduleHelper[i+1].endTime;
                    showScheduleHelper[i].showName = [showScheduleHelper[i].showName substringToIndex:showScheduleHelper[i].showName.length-1];
                    [showScheduleHelper removeObjectAtIndex:i+1];
                    i--;
                }
            }
        }
        self.showContent = showScheduleHelper.mutableCopy;
        [self updateLastUpdatedTime];
        [self sortShowContentByDay];
        dispatch_async(dispatch_get_main_queue(),
                       ^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_home_on_hour"
                                                                              object:self
                                                                            userInfo:@{}]; });
    }
}

-(void)updateFromBackground:(NSNotification*)notification{
    [self getSchedule];
}

-(NSInteger)getOffsetForRecurrence:(KPISSShow*)thisShow{
    NSInteger offset = 60*60*24;
    if([thisShow.frequency isEqualToString:@""]){
        offset = 0;
    } else if(([thisShow.frequency rangeOfString:@"UNTIL="].location == NSNotFound) || ![self isShowCancelled:thisShow.frequency withEndDate:thisShow.endTime]){
        if([thisShow.frequency rangeOfString:@"FREQ=WEEKLY"].location == NSNotFound){
            //daily - do niente
        } else if([thisShow.frequency rangeOfString:@"INTERVAL=2"].location == NSNotFound){
            //weekly
            offset *= 7;
        } else {
            //biweekly
            offset *= 14;
        } if([thisShow.frequency rangeOfString:@"FREQ=MONTHLY"].location != NSNotFound){
            //monthly - weird, delete
            offset = 0;
        }
        
    }
    else {
        offset = 0;
    }
    return offset;
}

-(BOOL)updateScheduleNewTime{
    int count = 0;
    if(self.showContent.count > 0){
        for(int i = 0; i < self.showContent.count;i++){
            if(i>=0 && i < 20){
                if([self.showContent[i].endTime compare:[NSDate date]] == NSOrderedAscending){

                    //show is long gone buddy
                    [self.showContent removeObjectAtIndex:i];
                    count++;
                    i--;
                }
            }
        }
    }
    if(count >= 20){
        NSLog(@"schedule obsolete, refreshing schedule");
        [self getSchedule];
    }
    [self updateLastUpdatedTime];
    return YES;
}

-(void)setShowContentList:(NSMutableArray<KPISSShow *> *)showContentArg{
    self.showContent = showContentArg;
}

-(void)sortShowContentByDay{
    NSMutableArray* showContentbyDay = [NSMutableArray array];
    NSMutableArray<KPISSShow*>* todayShows = [NSMutableArray array];
    int i = 0;
    while(i < self.showContent.count){
        [todayShows addObject:[self.showContent objectAtIndex:i]];
        i++;
        while(i < self.showContent.count && [[NSCalendar currentCalendar] isDate:[todayShows objectAtIndex:todayShows.count - 1].startTime inSameDayAsDate:[self.showContent objectAtIndex:i].startTime]){
            [todayShows addObject:[self.showContent objectAtIndex:i]];
            i++;
        }
        [showContentbyDay addObject:todayShows.mutableCopy];
        [todayShows removeAllObjects];
    }
    self.showContentByDay = showContentbyDay;
}

//get next show time
-(void)updateLastUpdatedTime{
    self.scheduleLastUpdatedDatetime = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSCalendarUnitEra|NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate: self.scheduleLastUpdatedDatetime];
    [comps setHour: [comps hour]+1];
    NSDate * updateTime = [calendar dateFromComponents:comps];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[updateTime timeIntervalSinceNow]
                                                      target:self
                                                    selector:@selector(refreshPlayerScreen)
                                                    userInfo:nil
                                                     repeats:NO];
    });
}

-(void)refreshPlayerScreen{
    [self updateScheduleNewTime];
    dispatch_async(dispatch_get_main_queue(),
                   ^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_home_on_hour"
                                                                          object:self
                                                                        userInfo:@{}]; });
}

-(void) makeShowDataRequest:(NSString*)webLink completionHandler:(void (^)(NSArray *array))completionHandler{
    __block NSArray* returnArray = [[NSArray alloc] init];
    if(webLink){
    NSString* baselineWebLink = @"https://kpiss.fm/show/";
    NSString * baselineReqCall = @"https://kpiss.fm//wp-json/wp/v2/show?_embed&slug=";
    NSRange range1 = [webLink rangeOfString:@"show/"];
    if (range1.location != NSNotFound) {
        NSRange rangeSlug = NSMakeRange(range1.location + 5, webLink.length - baselineWebLink.length);
        NSString* slug = [webLink substringWithRange:rangeSlug];
        if(!slug){
            completionHandler(returnArray);
        }
        NSString* showApiCall = [baselineReqCall stringByAppendingString:slug];
        NSURL *url = [NSURL URLWithString:showApiCall];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:url];

        //make request to wordpress site
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {

            if(error){
                NSLog(@"Bad slug, %@", error);
                completionHandler(returnArray);
            }
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if(jsonArray.count > 0){
                NSMutableDictionary* jsonDict = jsonArray[0];
                if([jsonDict valueForKey:@"acf"]){
                    jsonDict = [jsonDict valueForKey:@"acf"];
                    NSString* imageLink = @"";
                    NSString* description = @"";
                    if([jsonDict valueForKey:@"image"]){
                        imageLink = [jsonDict valueForKey:@"image"];
                    }
                    if([jsonDict valueForKey:@"description"]){
                        description = [jsonDict valueForKey:@"description"];
                        NSRange removePs = NSMakeRange(3,description.length - 8);
                        if(description.length > 0){
                        if([description substringWithRange:removePs]){
                        description = [description substringWithRange:removePs];
                        }
                        }
                        returnArray = [NSArray arrayWithObjects:imageLink, description, nil];
                    }
                }
            }
            completionHandler(returnArray);

        }] resume];
    }
    } else {
        completionHandler(returnArray);
    }
}

#pragma mark Player

-(void)configurePlayer{
    //    NSURL * streamURL;
    //    if(!self.streamURL){
    //        streamURL= [NSURL URLWithString:[NSString stringWithFormat:@"http://streaming.live365.com/a18444"]];
    //    } else {
    //        NSLog(@"%@", self.streamURL);
    //        streamURL= [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.streamURL]];
    //    }
    
    //update stream URL here!!!
    NSURL * streamURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://streaming.live365.com/a18444"]];
    AVAsset * asset = [AVAsset assetWithURL:streamURL];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayerItemMetadataOutput *metadataOutput = [[AVPlayerItemMetadataOutput alloc] initWithIdentifiers:nil];
    [metadataOutput setDelegate:self queue:dispatch_get_main_queue()];
    [self.playerItem addOutput:metadataOutput];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
}

-(BOOL)isShowCancelled:(NSString*)frequency withEndDate:(NSDate*)endTime{
    if(frequency){
        NSArray *components = [frequency componentsSeparatedByString:@";"];
        if(components.count){
            for(int i = 0;i < components.count;i++){
                if([((NSString*)components[i]) containsString:(@"UNTIL=") ]){
                    NSString* targetComponent = components[i];
                    NSString* endDateString = [targetComponent substringFromIndex:6];
                    endDateString = [endDateString substringToIndex:8];
                    NSDate * now = [NSDate now];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YYYYMMDD"];
                    NSDate *endDate = [dateFormatter dateFromString:endDateString];
                    if([endDate compare:now] == NSOrderedAscending){
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
        return false;
    } else {
        NSDate * now = [NSDate now];
        if([endTime compare:now] == NSOrderedAscending){
            return true;
        }
    }
    return false;
}

//show helper and time functions

-(KPISSShow*)getShowByName:(NSString*)name{
    for(KPISSShow* show in self.showContent){
        if ([show.showName isEqualToString:name]){
            return show;
        }
    }
    return nil;
}

-(KPISSShow*)getNextShowByName:(NSString*)name{
    int count = 0;
    for(KPISSShow* show in self.showContent){
        if ([show.showName isEqualToString:name]){
            count++;
            if(count == 2){
                return show;
            }
        }
    }
    return nil;
}

-(NSString*)getYoutubeURL{
    if(self.streamURL){
        return self.streamURL;
    } else {
        return nil;
    }
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * locDate = localDate;
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

-(NSDate*)adjustForTimeZone:(NSDate*)thisDate withOriginalDate:(NSDate*)originalDate{
    //accomodate time change
    int eventOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:originalDate];
    int nowOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:thisDate];
    return [thisDate dateByAddingTimeInterval:(eventOffset - nowOffset)];
}



@end
