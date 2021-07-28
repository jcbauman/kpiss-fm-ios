//
//  AboutViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 7/27/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "AboutViewController.h"
#import "ShowWebViewController.h"
#import "RadioKit.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //format views
    _basicInfoView.layer.cornerRadius = 10.0f;
    _basicInfoView.layer.shadowRadius  = 1.5f;
    _basicInfoView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _basicInfoView.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    _basicInfoView.layer.shadowOpacity = 0.5f;
    _basicInfoView.layer.masksToBounds = NO;
    
    _appInfoView.layer.cornerRadius = 10.0f;
    _appInfoView.layer.shadowRadius  = 1.5f;
    _appInfoView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _appInfoView.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    _appInfoView.layer.shadowOpacity = 0.5f;
    _appInfoView.layer.masksToBounds = NO;
    
    [_aboutRockoView sizeToFit];
    self.twitterButton.clipsToBounds = YES;
    self.twitterButton.layer.cornerRadius = 8;
    
    self.tiktokIcon.clipsToBounds = YES;
    self.tiktokIcon.layer.cornerRadius = 8;
//    if(![RadioKit radioKit].aboutPageDescription){
//        BOOL sah = [[RadioKit radioKit] getImageFromWeblink:-1];
//    }
//    self.aboutKpissTextView.text = [RadioKit radioKit].aboutPageDescription;
}


- (IBAction)linkedinTapped:(id)sender {
    NSURL * URL = [NSURL URLWithString:@"https://www.linkedin.com/in/jackcaseybauman/"];
    if( [[UIApplication sharedApplication] canOpenURL:URL])
           [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
               return;
           }];
}

- (IBAction)dismissThisSucka:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lunarTapped:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://kpiss.fm/show/lunar-rotation/"];
    if( [[UIApplication sharedApplication] canOpenURL:URL])
           [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
               return;
           }];
}

- (IBAction)emailTapped:(id)sender {
    NSURL * URL = [NSURL URLWithString:@"mailto:sheri@kpiss.fm"];
    if( [[UIApplication sharedApplication] canOpenURL:URL])
           [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
               return;
           }];
}

- (IBAction)igTapped:(id)sender {
    NSURL * URL = [NSURL URLWithString:@"https://www.instagram.com/kpissfm/"];
    if( [[UIApplication sharedApplication] canOpenURL:URL])
           [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
               return;
           }];
}
- (IBAction)twitterTapped:(id)sender {
    NSURL * URL = [NSURL URLWithString:@"https://twitter.com/kpissfm"];
        if( [[UIApplication sharedApplication] canOpenURL:URL])
               [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
                   return;
               }];
}

- (IBAction)tiktokTapped:(id)sender {
    NSURL * URL = [NSURL URLWithString:@"https://www.tiktok.com/@kpissradio"];
        if( [[UIApplication sharedApplication] canOpenURL:URL])
               [[UIApplication sharedApplication] openURL:URL options:nil completionHandler:^(BOOL success) {
                   return;
               }];
}

@end
