//
//  SupportViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 9/18/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupportViewController : UIViewController
- (IBAction)closeTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *supportView;
@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayerView;

@end

NS_ASSUME_NONNULL_END
