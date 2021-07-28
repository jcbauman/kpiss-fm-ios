//
//  ViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "KPISSShow.h"
#import "AppDelegate.h"
#import "RadioKit.h"
#import "ShowWebViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showContent = [[NSMutableArray alloc] init];
    
    //update UI
    self.liveLbl.layer.cornerRadius = 2;
    self.liveLbl.clipsToBounds = YES;
    self.supportBtn.layer.cornerRadius =  6;
    [self.supportBtn addTarget:self action:@selector(supportBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.showImageView setImage:[UIImage imageNamed:@"kpissvan"]];
    [self.playBtn addTarget:self action:@selector(playBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.layer.shadowRadius  = 1.5f;
    self.playBtn.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.playBtn.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    self.playBtn.layer.shadowOpacity = 0.5f;
    self.playBtn.layer.masksToBounds = NO;
    self.metadataOn = @"NO";
    self.verboseMetadataBtn.hidden = YES;
    
    //refresh/metdata btns
    self.verboseMetadataBtn.center = CGPointMake(self.view.frame.size.width / 4, self.verboseMetadataBtn.center.y);
    self.refreshStreamBtn.center = CGPointMake(self.view.frame.size.width * 0.75, self.refreshStreamBtn.center.y);
    [self.verboseMetadataBtn addTarget:self action:@selector(setMetadataCollection:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshStreamBtn addTarget:self action:@selector(refreshStream:) forControlEvents:UIControlEventTouchUpInside];
    
    //support btn
    self.supportBtn.layer.cornerRadius = 10.0f;
    self.supportBtn.layer.shadowRadius  = 1.5f;
    self.supportBtn.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.supportBtn.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    self.supportBtn.layer.shadowOpacity = 0.5f;
    self.supportBtn.layer.masksToBounds = NO;
    
    //now playing view
    self.showView.layer.shadowRadius  = 1.5f;
    self.showView.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.showView.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    self.showView.layer.shadowOpacity = 0.5f;
    self.showView.layer.masksToBounds = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromBackground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOnHour:) name:@"refresh_home_on_hour" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNowPlaying:) name:@"refresh_now_playing" object:nil];
    
    [[RadioKit radioKit] getSchedule];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self updatePlayBtn];
}

-(void)updateFromBackground:(NSNotification*)notification{
    [self updatePlayBtn];
    [self setCurrentShow];
    
}

-(void)updatePlayBtn{
    if([[RadioKit radioKit].isPlaying isEqualToString:@"YES"]){
        [self.playBtn setImage:[UIImage imageNamed:@"pauseBtnImage"] forState:UIControlStateNormal];
    } else {
        [self.playBtn setImage:[UIImage imageNamed:@"playBtnImage"] forState:UIControlStateNormal];
    }
}

-(void)playBtnTapped:(id)sender{
    if([[RadioKit radioKit].isPlaying isEqualToString:@"NO"]){
        [RadioKit radioKit].isPlaying = @"YES";
        [self.playBtn setImage:[UIImage imageNamed:@"pauseBtnImage"] forState:UIControlStateNormal];
        [[RadioKit radioKit].player play];
        
    } else {
        [RadioKit radioKit].isPlaying = @"NO";
        [self.playBtn setImage:[UIImage imageNamed:@"playBtnImage"] forState:UIControlStateNormal];
        
        [[RadioKit radioKit].player pause];
    }
    UIImpactFeedbackGenerator * generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
}

-(void)setCurrentShow:(id)sender{
    [self setCurrentShow];
}

-(void)supportBtnTapped:(id)sender{
    
  
}

-(void)refreshStream:(id)sender{
    [self.refreshStreamBtn setTintColor:[UIColor systemPinkColor]];
    if([[RadioKit radioKit].isPlaying isEqualToString:@"YES"]){[[RadioKit radioKit].player pause];}
    [[RadioKit radioKit] configurePlayer];
    if([[RadioKit radioKit].isPlaying isEqualToString:@"YES"]){[[RadioKit radioKit].player play];}
    [UIView animateWithDuration:0.2 //half the label animation duration
                          delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        self.refreshStreamBtn.transform = transform;
    }
                     completion:^(BOOL finished) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.refreshStreamBtn.transform = transform;
        [self.refreshStreamBtn setTintColor:[UIColor blackColor]];
    }];
}

-(void)setMetadataCollection:(id)sender{
    if([self.metadataOn isEqualToString:@"YES"]){
        self.metadataOn = @"NO";
        [self.verboseMetadataBtn setTintColor:[UIColor blackColor]];
        [self setCurrentShow];
    } else {
        self.metadataOn = @"YES";
        [self.verboseMetadataBtn setTintColor:[UIColor systemPinkColor]];
        [self.currentShowLbl setText:[[@"Last Played: \"" stringByAppendingString:[RadioKit radioKit].lastMetadataItem] stringByAppendingString:@"\""]];
    }
}


-(void)refreshOnHour:(NSNotification*)notification{
    NSLog(@"updating on hour");
    if([[RadioKit radioKit] updateScheduleNewTime]){
        [self setCurrentShow];
    }
}

-(void)refreshNowPlaying:(NSNotification*)notification{
    if([self.metadataOn isEqualToString:@"YES"]){
        [self.currentShowLbl setText:[[@"Last Played: \"" stringByAppendingString:[RadioKit radioKit].lastMetadataItem] stringByAppendingString:@"\""]];
    }
}

-(void)setCurrentShow{
//    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://kpiss.fm/wp-content/uploads/2020/03/runemoff-copy-2.jpg"]];
//                            if ( data == nil ){
//                                return;
//                            } else {
//                                self.showImageView.image = [UIImage imageWithData: data];
//                            }
//    self.trackDetails.text = @"Run 'Em Off w/ Owen Kline";
//    self.currentShowLbl.text = @"Next Up: Ennui on Me @ 10PM";
    self.showContent = [RadioKit radioKit].showContent;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.showContent.count > 1){
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"ha"];
            [dateFormat setLocale:[[NSLocale alloc]
                                   initWithLocaleIdentifier:@"en_US_POSIX"]];
            KPISSShow * currentShow = self.showContent[0];
            int nextShow = 1;
            if([currentShow.startTime compare:[NSDate date]] == NSOrderedAscending){
                if(![self.trackDetails.text isEqualToString:currentShow.showName])
                    [self.trackDetails setText:([NSString stringWithFormat:@"%@ w/ %@", currentShow.showName, currentShow.showDJ ])];
            } else {
                [self.trackDetails setText:(@"The Golden Stream")];
                nextShow = 0;
            }
            if([self.metadataOn isEqualToString:@"YES"]){
                [self.currentShowLbl setText:[[@"Last Played: \"" stringByAppendingString:[RadioKit radioKit].lastMetadataItem] stringByAppendingString:@"\""]];
            } else {
                NSString * nextShowText = [@"Next Up: " stringByAppendingString:self.showContent[nextShow].showName];
                nextShowText = [nextShowText stringByAppendingString:@" @ "];
                nextShowText = [nextShowText stringByAppendingString: [dateFormat stringFromDate: self.showContent[nextShow].startTime]];
                [self.currentShowLbl setText:nextShowText];
            }
            if(nextShow == 1){
//            if(nextShow == 100){
                if(currentShow.imageURL){
                    if(![currentShow.imageURL isEqualToString:@""]){
                        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: currentShow.imageURL]];
                        if ( data == nil ){
                            self.showImageView.image = [UIImage imageNamed:@"kpissvan"];
                        } else {
                            self.showImageView.image = [UIImage imageWithData: data];
                        }
                    }
                } else {
                    //[self setImageFromWeblink:0];
                    if(currentShow.websiteLink){
                    [[RadioKit radioKit] makeShowDataRequest:currentShow.websiteLink completionHandler:^(NSArray *returnArray) {
                        if(returnArray.count > 1){
                            currentShow.imageURL = returnArray[0];
                            currentShow.showDescription = returnArray[1];
                            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: currentShow.imageURL]];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                            if ( data == nil ){
                                 self.showImageView.image = [UIImage imageNamed:@"kpissvan"];
                            } else {
                                self.showImageView.image = [UIImage imageWithData: data];
                            }
                            });

                        }
                     }];
                    }
                }
            } else {
                if([RadioKit radioKit].featuredImages.count > 0){
                    uint32_t rnd = arc4random_uniform([RadioKit radioKit].featuredImages.count);
                    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[RadioKit radioKit].featuredImages objectAtIndex:rnd]]];
                    if ( data == nil ){
                         self.showImageView.image = [UIImage imageNamed:@"kpissvan"];
                    } else {
                        self.showImageView.image = [UIImage imageWithData: data];
                    }
                } else {
                    self.showImageView.image = [UIImage imageNamed:@"kpissvan"];
                }
            }
        } else {
            [self.trackDetails setText:(@"The Golden Stream")];
            [self.currentShowLbl setText:@"Streaming Now from Brooklyn, NY"];
        }
    });
}




@end
