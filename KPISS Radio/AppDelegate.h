//
//  AppDelegate.h
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;



- (void)saveContext;


@end

