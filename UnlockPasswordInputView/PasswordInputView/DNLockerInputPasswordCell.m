//
//  DNLockerInputPasswordCell.m
//  Tristan
//
//  Created by Tristan on 2017/4/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "DNLockerInputPasswordCell.h"

@interface DNLockerInputPasswordCell ()

@property (nonatomic, strong) UIView *dot;

@end

@implementation DNLockerInputPasswordCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = CLEAR_COLOR;
    self.backgroundColor = CLEAR_COLOR;
    if (!_dot) {
        _dot = [UIView new];
    }
    [self.contentView addSubview:_dot];
    [_dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(10.f, 10.f));
    }];
    _dot.layer.cornerRadius = 5.f;
    _dot.layer.masksToBounds = YES;
    _dot.clipsToBounds = YES;
    [self beEmptyState];
    
}

#pragma mark - Actions

- (void)beEmptyState {
    _dot.layer.borderWidth = 1.5f;
    _dot.layer.borderColor = UIColorFromHexString(@"#A2A3A7").CGColor;
    _dot.backgroundColor = CLEAR_COLOR;
}

- (void)beFilledState {
    _dot.layer.borderWidth = 0.f;
    _dot.backgroundColor = UIColorFromHexString(@"#FFFFFF");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
