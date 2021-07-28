//
//  SupportViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 9/18/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "SupportViewController.h"
#import "RadioKit.h"

@interface SupportViewController ()

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //format views
    _supportView.layer.cornerRadius = 10.0f;
    _supportView.layer.shadowRadius  = 1.5f;
    _supportView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _supportView.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
    _supportView.layer.shadowOpacity = 0.5f;
    _supportView.layer.masksToBounds = NO;
    
    //load youtube video, cut out video id
    NSString * youtubeVideoId = @"FknatStJx8E";
    NSString * ytURL = [[RadioKit radioKit] getYoutubeURL];
    if(ytURL){
        NSArray *arrayWithTwoStrings = [[[RadioKit radioKit] getYoutubeURL] componentsSeparatedByString:@"v="];
        if([arrayWithTwoStrings count] == 2){
            if(((NSString*)[arrayWithTwoStrings objectAtIndex:1]).length < 20){
                youtubeVideoId = ((NSString*)[arrayWithTwoStrings objectAtIndex:1]);
            }
        } else {
            arrayWithTwoStrings = [[[RadioKit radioKit] getYoutubeURL] componentsSeparatedByString:@"be/"];
            if([arrayWithTwoStrings count] == 2){
                if(((NSString*)[arrayWithTwoStrings objectAtIndex:1]).length < 20){
                    youtubeVideoId = ((NSString*)[arrayWithTwoStrings objectAtIndex:1]);
                }
            }
        }
    }
    
    [self.youtubePlayerView loadWithVideoId:youtubeVideoId];
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
