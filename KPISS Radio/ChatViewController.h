//
//  ChatViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 7/26/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *chatView;
@property (strong, nonatomic) UIImageView *helperImage;
@property (strong, nonatomic) UIImageView * loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *chatCover;
@property (strong,nonatomic)  NSString* isOnboarded;
@end

NS_ASSUME_NONNULL_END
