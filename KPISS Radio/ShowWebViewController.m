//
//  ShowWebViewController.m
//  KPISS Radio
//
//  Created by Jack Bauman on 8/9/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "ShowWebViewController.h"

@interface ShowWebViewController ()

@end

@implementation ShowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *req = [NSURLRequest requestWithURL:self.websiteLink];
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor systemYellowColor];
    [self.webView loadRequest:req];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissThisSucka:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
