//
//  ScheduleTableViewCell.m
//  KPISS Radio
//
//  Created by Jack Bauman on 8/5/20.
//  Copyright © 2020 Jack Bauman. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "RadioKit.h"

@implementation ScheduleTableViewCell

-(void)prepareForReuse{
    [super prepareForReuse];
    self.showNameLabel.text = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showDetails = @"NO";
    [self layoutSubviews];
}

-(void)layoutSubviews{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor redColor];
    self.contentView.layer.cornerRadius = 5;
     //format views
     self.contentView.layer.cornerRadius = 10.0f;
     self.contentView.layer.shadowRadius  = 1.5f;
     self.contentView.layer.shadowColor   = [UIColor blackColor].CGColor;
     self.contentView.layer.shadowOffset  = CGSizeMake(0.0f, 1.0f);
     self.contentView.layer.shadowOpacity = 0.5f;
    self.timeLbl.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:72.0/255.0 blue:105.0/255.0 alpha:1.0];
     self.contentView.backgroundColor = [UIColor yellowColor];
     self.contentView.frame = CGRectMake(self.bounds.origin.x + 10,
                                          self.bounds.origin.y + 5,
                                          self.bounds.size.width - 20,
                                          self.bounds.size.height - 10);
    self.timeLbl.layer.shadowRadius  = 1.5f;
    self.timeLbl.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.timeLbl.layer.shadowOffset  = CGSizeMake(0.0f, 1.0f);
    self.timeLbl.layer.shadowOpacity = 0.5f;

     self.contentView.layer.masksToBounds = YES;
     self.contentView.clipsToBounds = NO;
     self.timeLbl.layer.cornerRadius = 5;
    if([self.isSpecialShow isEqualToString:@"true"]){
        self.contentView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:224.0/255.0 blue:208.0/255.0 alpha:1.0];
        [self.websiteBtn setTitle:@"SPECIAL EPISODE!" forState:UIControlStateNormal];
    } else {
        self.contentView.backgroundColor = [UIColor yellowColor];
        [self.websiteBtn setTitle:@"MORE EPISODES" forState:UIControlStateNormal];
    };
    [self.descriptionText setContentOffset:CGPointZero animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)websiteBtnPressed:(UIButton*)sender{
}

@end
