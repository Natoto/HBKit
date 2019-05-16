//
//  CrowdFoundHeaderCell.m
//  PENG
//
//  Created by HUANGBO on 15/8/7.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import "CF_CrowdFoundHeaderCell.h"
@interface CF_CrowdFoundHeaderCell()
@property (nonatomic, weak) IBOutlet UIImageView *img_profile;
@property (nonatomic, weak) IBOutlet UILabel *lbl_title;
@property (nonatomic, weak) IBOutlet UILabel *lbl_detail;
@property (nonatomic, weak) IBOutlet UISlider *slider_progress;
@property (nonatomic, weak) IBOutlet UILabel *lbl_progress;
@property (nonatomic, weak) IBOutlet UILabel *lbl_currentmoney;
@property (nonatomic, weak) IBOutlet UILabel *lbl_remaintime;
@property (nonatomic, weak) IBOutlet UIView *backgroundview;
@property (nonatomic, weak) IBOutlet UIButton *btn_comment;
@property (nonatomic, weak) IBOutlet UILabel *lbl_state;
@property (nonatomic, weak) IBOutlet UIButton *btn_zan;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@end
@implementation CF_CrowdFoundHeaderCell


+ (CGFloat)heightOfCell
{
    return 252.;
}
- (void)setcellTitle:(NSString *)title
{
}
- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self.slider_progress setThumbImage:[UIImage new] forState:UIControlStateNormal];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.bottomView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
