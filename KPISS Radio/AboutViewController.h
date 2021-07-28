//
//  AboutViewController.h
//  KPISS Radio
//
//  Created by Jack Bauman on 7/27/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *basicInfoView;
@property (weak, nonatomic) IBOutlet UIView *appInfoView;
- (IBAction)linkedinTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *aboutRockoView;
- (IBAction)igTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)lunarTapped:(id)sender;
- (IBAction)dismissThisSucka:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
- (IBAction)twitterTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *aboutKpissTextView;
@property (weak, nonatomic) IBOutlet UIButton *tiktokIcon;

@end

NS_ASSUME_NONNULL_END
