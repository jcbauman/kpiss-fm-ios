//
//  ChatViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "ChatViewController.h"
#import <WebKit/WebKit.h>

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize loadingIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOnboarded = @"NO";
    
    NSURL * scheduleURL = [NSURL URLWithString: @"http://kpiss.fm"];
    NSURLRequest *req = [NSURLRequest requestWithURL:scheduleURL];
    self.chatView.navigationDelegate = self;
    self.chatView.backgroundColor = [UIColor systemYellowColor];
    
    //init helper image
    [self.helperImage = [UIImageView alloc] init];
    [self.helperImage setImage:[UIImage imageNamed:@"chatOverlay"]];
    self.helperImage.contentMode = UIViewContentModeScaleToFill;
    self.helperImage.frame = self.chatView.frame;
//    self.chatCover.layer.shadowRadius  = 1.5f;
//    self.chatCover.layer.shadowColor   = [UIColor blackColor].CGColor;
//    self.chatCover.layer.shadowOffset  = CGSizeMake(0.0f, 3.0f);
//    self.chatCover.layer.shadowOpacity = 0.5f;
    self.chatCover.layer.masksToBounds = NO;
    [self.view addSubview:self.helperImage];
    
    //init activityindiactor
    self.loadingIndicator = [[UIImageView alloc] init];
    [self.loadingIndicator setAnimationImages:[[NSArray<UIImage*> alloc]initWithObjects:
                                           [UIImage imageNamed:@"frame_38_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_37_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_36_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_35_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_34_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_33_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_32_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_31_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_30_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_29_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_28_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_27_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_26_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_25_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_24_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_23_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_22_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_21_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_20_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_19_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_18_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_17_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_16_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_15_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_14_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_13_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_12_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_11_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_10_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_09_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_08_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_07_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_06_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_05_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_04_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_03_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_02_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_01_delay-0.04s"],
                                           [UIImage imageNamed:@"frame_00_delay-0.04s"], nil]];
    [self.loadingIndicator setAnimationRepeatCount:0];
    self.loadingIndicator.animationDuration = 2.0f;
    self.loadingIndicator.frame = CGRectMake(0, 0, 300, 300);
    self.loadingIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.loadingIndicator.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.loadingIndicator];
    [self.loadingIndicator startAnimating];
    
    
    // Initialize the html data to webview
    [_chatView loadRequest:req];
    
    self.chatView.scrollView.minimumZoomScale = 1.0;
    self.chatView.scrollView.maximumZoomScale = 1.0;
    
    [self performSelector:@selector(removeOnboarding:) withObject:nil afterDelay:10.0];
    
}

//show chat navigation
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"chat view did finish loading");
    [self removeOnboarding];
}


-(void)removeOnboarding:(id)sender{
    [self removeOnboarding];
}
-(void)removeOnboarding{
    if([self.isOnboarded isEqualToString:@"NO"]){
        self.isOnboarded = @"YES";
        self.helperImage.contentMode = UIViewContentModeScaleToFill;
        self.helperImage.frame = self.chatView.frame;
        [self.loadingIndicator stopAnimating];
        [self.loadingIndicator removeFromSuperview];
        [self.helperImage setImage:[UIImage imageNamed:@"chatOverlayBlank"]];
        [self performSelector:@selector(hideHelperImage:) withObject:nil afterDelay:4.0];
    }
}

-(void)hideHelperImage:(id)sender{
    [UIView animateWithDuration:2 animations:^{
        self.helperImage.hidden = YES;
    }];
}


@end
