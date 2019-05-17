//
//  OnOffTableViewCell.m
//  NOZLaboratory
//
//  Created by boob on 2019/5/17.
//

#import "OnOffTableViewCell.h"

@interface OnOffTableViewCell()
@property (nonatomic, strong) UISwitch * onOffswitch;

@end

@implementation OnOffTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self onOffswitch];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.onOffswitch.center = CGPointMake(self.contentView.frame.size.width - 30, self.contentView.frame.size.height/2.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setcelldetailtitle:(NSString *)detailtitle{
    
    if ([detailtitle isEqualToString:@"√"]) {
        self.onOffswitch.on = YES;
    }else{
        self.onOffswitch.on = NO;
    }
}
- (UISwitch *)onOffswitch {
    if (!_onOffswitch) {
        _onOffswitch = [[UISwitch alloc] init];
        _onOffswitch.userInteractionEnabled = NO;
        [self.contentView addSubview:_onOffswitch];
    }
    return _onOffswitch;
}
@end

@implementation ShowValueTableViewCell

@end
