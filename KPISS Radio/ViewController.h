//
//  ViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KPISSShow.h"
#import "ScheduleViewController.h"


@interface ViewController :  UIViewController <AVPlayerViewControllerDelegate, AVPlayerItemMetadataOutputPushDelegate>{
}

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic, strong) AVPlayerItemMetadataCollector* metadataCollector;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *nowPlayingView;
@property (weak, nonatomic) IBOutlet UILabel *liveLbl;
@property (weak, nonatomic) IBOutlet UILabel *trackDetails;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *currentShowLbl;
@property (strong, nonatomic) NSString *API_KEY;
@property (strong,nonatomic) NSMutableArray<KPISSShow*> * showContent;
@property (strong,nonatomic) ScheduleViewController * schedVC;
@property (weak, nonatomic) IBOutlet UIButton *verboseMetadataBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshStreamBtn;
@property (strong, nonatomic) NSString* metadataOn;

-(void)playBtnTapped:(id)sender;



@end

