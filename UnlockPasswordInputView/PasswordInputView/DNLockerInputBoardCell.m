//
//  DNLockerInputBoardCell.m
//  Tristan
//
//  Created by Tristan on 2017/4/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "DNLockerInputBoardCell.h"


@interface DNLockerInputBoardCell ()

@property (nonatomic, strong) UIImage *hiImage;

@end

@implementation DNLockerInputBoardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = CLEAR_COLOR;
    self.contentView.backgroundColor = CLEAR_COLOR;
    _hiImage = [UIImage imageWithColor:[UIColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:0.9]];
    if (!_alphaLabel) {
        _alphaLabel = [UILabel new];
    }
    [self addSubview:_alphaLabel];
    _alphaLabel.backgroundColor = CLEAR_COLOR;
    _alphaLabel.font = [UIFont systemFontOfSize:11.f];
    _alphaLabel.textAlignment = NSTextAlignmentCenter;
    _alphaLabel.textColor = UIColorFromHexString(@"#FFFFFF");
    [_alphaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(13.f);
    }];
    
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:self.contentView.bounds];
    }
    [self.contentView addSubview:_btn];
    [_btn setTitleColor:UIColorFromHexString(@"#FFFFFF") forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:27.f];
    _btn.layer.cornerRadius = _btn.frame.size.width / 2.f;
    _btn.layer.masksToBounds = YES;
    _btn.clipsToBounds = YES;
    _btn.layer.borderWidth = 1.5f;
    _btn.layer.borderColor = [UIColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:0.9].CGColor;
    [_btn setBackgroundImage:_hiImage forState:UIControlStateHighlighted];
    [_btn handleControlEvent:UIControlEventTouchDown withBlock:^(UIButton *sender) {
        if (weakSelf.numberClickAction) {
            weakSelf.numberClickAction(sender.titleLabel.text, sender);
        }
    }];
    [_btn setTitleEdgeInsets:UIEdgeInsetsMake(-7.f, 0, 7.f, 0)];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
