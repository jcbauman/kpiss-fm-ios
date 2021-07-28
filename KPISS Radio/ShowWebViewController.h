//
//  ShowWebViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 8/9/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowWebViewController : UIViewController <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (strong,nonatomic) NSURL* websiteLink;
- (IBAction)dismissThisSucka:(id)sender;

@end

NS_ASSUME_NONNULL_END
