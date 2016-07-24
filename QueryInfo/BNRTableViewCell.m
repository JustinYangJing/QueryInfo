//
//  BNRTableViewCell.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRTableViewCell.h"

@interface BNRTableViewCell()
@property (nonatomic,strong) UIView *line;
@end

@implementation BNRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!_line) {
        _line = [UIView new];
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(10);
            make.trailing.equalTo(self.mas_trailing).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
            make.height.equalTo(@0.5);
        }];
        _line.backgroundColor = [UIColor whiteColor];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
