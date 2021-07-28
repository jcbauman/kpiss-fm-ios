//
//  AppDelegate.m
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "TabBarController.h"
#import "RadioKit.h"
#import <UserNotifications/UNNotificationCategory.h>
#import <UserNotifications/UNUserNotificationCenter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    // Apple documentation says you don't need the following if you are using
    // the MPRemoteCommandCenter, but that is not true. It is needed.
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    [RadioKit radioKit];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.togglePlayPauseCommand setEnabled:YES];
    [commandCenter.playCommand setEnabled:YES];
    [commandCenter.playCommand addTarget:self action:@selector(playPlayer:)];
    [commandCenter.pauseCommand setEnabled:YES];
    [commandCenter.pauseCommand addTarget:self action:@selector(pausePlayer:)];
    [commandCenter.nextTrackCommand setEnabled:NO];
    [commandCenter.previousTrackCommand setEnabled:NO];
    [commandCenter.nextTrackCommand setEnabled:NO];
    [commandCenter.previousTrackCommand setEnabled:NO];
    
    [commandCenter.stopCommand setEnabled:NO];
    [commandCenter.skipForwardCommand setEnabled:NO];
    [commandCenter.skipBackwardCommand setEnabled:NO];
    [commandCenter.enableLanguageOptionCommand setEnabled:NO];
    [commandCenter.disableLanguageOptionCommand setEnabled:NO];
    [commandCenter.changeRepeatModeCommand setEnabled:NO];
    [commandCenter.changePlaybackRateCommand setEnabled:NO];
    [commandCenter.changeShuffleModeCommand setEnabled:NO];
    // Seek Commands
    [commandCenter.seekForwardCommand setEnabled:NO];
    [commandCenter.seekBackwardCommand setEnabled:NO];
    [commandCenter.changePlaybackPositionCommand setEnabled:NO];
    // Rating Command
    [commandCenter.ratingCommand setEnabled:NO];

    // Feedback Commands
    // These are generalized to three distinct actions. Your application can provide
    // additional context about these actions with the localizedTitle property in
    // MPFeedbackCommand.
    [commandCenter.likeCommand setEnabled:NO];
    [commandCenter.dislikeCommand setEnabled:NO];
    [commandCenter.bookmarkCommand setEnabled:NO];

    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    //set nowplaying info
    NSMutableDictionary *nowPlayingInfo = [[NSMutableDictionary alloc] init];
    MPMediaItemArtwork *logo = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"logoFront"]];
    [nowPlayingInfo setObject:@"KPISS Radio" forKey:MPMediaItemPropertyTitle];
    [nowPlayingInfo setObject:@"The Golden Stream" forKey:MPMediaItemPropertyAlbumTitle];
    [nowPlayingInfo setObject:logo forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
    
    return YES;
}

-(MPRemoteCommandHandlerStatus)pausePlayer:(id)sender{
    [[RadioKit radioKit].player pause];
    [RadioKit radioKit].isPlaying = @"NO";
    return MPRemoteCommandHandlerStatusSuccess;
}

-(MPRemoteCommandHandlerStatus)playPlayer:(MPRemoteCommandHandlerStatus*)event{
    [[RadioKit radioKit].player play];
    [RadioKit radioKit].isPlaying = @"YES";
    return MPRemoteCommandHandlerStatusSuccess;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    UNNotificationPresentationOptions presentationOptions = UNNotificationPresentationOptionAlert;
    completionHandler(presentationOptions);
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"KPISS_Radio"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
