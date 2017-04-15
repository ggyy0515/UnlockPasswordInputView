//
//  DNLockerInputPasswordView.m
//  Tristan
//
//  Created by Tristan on 2017/4/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//



#import "DNLockerInputPasswordView.h"
#import "DNLockerInputPasswordCell.h"
#import "DNLockerInputBoardCell.h"
#import "Masonry.h"

@interface DNLockerInputPasswordBoard : UIView
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *alphaDataSource;
@property (nonatomic, copy) void(^didInputNumber)(NSString *);

@end

@interface DNLockerInputPasswordView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DNLockerInputPasswordBoard *board;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableString *password;
@property (nonatomic, copy) void(^completeBlock)(NSString *password, DNLockerInputPasswordView *view);
@property (nonatomic, copy) void(^forgetPasswordAction)(DNLockerInputPasswordView *view);
@property (nonatomic, copy) void(^dismissBlock)();

@end

@implementation DNLockerInputPasswordView

#pragma mark - Life Cycle

+ (void)showWithTitle:(NSString *)title
        completeBlock:(void(^)(NSString *password, DNLockerInputPasswordView *view))completeBlock
 forgetPasswordAction:(void(^)(DNLockerInputPasswordView *view))forgetPasswordAction
         dismissBlock:(void(^)())dismissBlock {
    DNLockerInputPasswordView *passwordView = [[self alloc] initWithTitle:title];
    passwordView.completeBlock = completeBlock;
    passwordView.forgetPasswordAction = forgetPasswordAction;
    passwordView.dismissBlock = dismissBlock;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _password = [NSMutableString string];
        _title = title;
        _bgImage = [self getSnapshotImage];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window).insets(UIEdgeInsetsZero);
    }];
    
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    [self addSubview:_bgImageView];
    _bgImageView.userInteractionEnabled = YES;
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
    [_bgImageView setImage:_bgImage];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.95;
    [_bgImageView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.bgImageView).insets(UIEdgeInsetsZero);
    }];
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    [self addSubview:_leftBtn];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _leftBtn.backgroundColor = CLEAR_COLOR;
    [_leftBtn setTitle:LString(@"Forgot password?") forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromHexString(@"#FFFFFF") forState:UIControlStateNormal];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-25.f);
        make.height.mas_equalTo(weakSelf.leftBtn.titleLabel.font.lineHeight);
    }];
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.forgetPasswordAction) {
            weakSelf.forgetPasswordAction(weakSelf);
        }
    }];
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    [self addSubview:_rightBtn];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _rightBtn.backgroundColor = CLEAR_COLOR;
    [_rightBtn setTitle:LString(@"Cancel") forState:UIControlStateNormal];
    [_rightBtn setTitleColor:UIColorFromHexString(@"#FFFFFF") forState:UIControlStateNormal];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftBtn.mas_right);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-25.f);
        make.height.mas_equalTo(weakSelf.rightBtn.titleLabel.font.lineHeight);
    }];
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.password.length == 0) {
            [weakSelf dismiss];
            if (weakSelf.dismissBlock) {
                weakSelf.dismissBlock();
            }
        } else {
            [weakSelf.password deleteCharactersInRange:NSMakeRange(weakSelf.password.length - 1, 1)];
            if (weakSelf.password.length == 0) {
                [weakSelf.rightBtn setTitle:LString(@"Cancel") forState:UIControlStateNormal];
            }
        }
        [weakSelf.collectionView reloadData];
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    _titleLabel.textColor = UIColorFromHexString(@"#FFFFFF");
    _titleLabel.text = _title;
    _titleLabel.numberOfLines = 0;
    CGFloat topSpace = 80.f / 667.f * SCREEN_HEIGHT;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(topSpace);
        make.left.mas_equalTo(weakSelf.mas_left).offset(20.f);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-20.f);
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.itemSize = CGSizeMake(30.f, 30.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = CLEAR_COLOR;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(35.f);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180.f, 30.f));
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[DNLockerInputPasswordCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNLockerInputPasswordCell)];
    
    if (!_board) {
        _board = [[DNLockerInputPasswordBoard alloc] initWithFrame:CGRectZero];
    }
    [self addSubview:_board];
    [_board mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).offset(35.f);
        make.size.mas_equalTo(CGSizeMake(271.f, 369.f));
    }];
    [_board setDidInputNumber:^(NSString *number){
        if (weakSelf.password.length < 6) {
            [weakSelf.password appendString:number];
            [weakSelf.rightBtn setTitle:LString(@"Delete") forState:UIControlStateNormal];
            [weakSelf.collectionView reloadData];
            if (weakSelf.password.length == 6) {
                if (weakSelf.completeBlock) {
                    weakSelf.completeBlock(weakSelf.password, weakSelf);
                }
            }
        }
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }

}

#pragma mark - Actions

- (UIImage *)getSnapshotImage {
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 1);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)clearInput {
    _password = [NSMutableString string];
    [_collectionView reloadData];
    [_rightBtn setTitle:LString(@"Cancel") forState:UIControlStateNormal];
}

#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DNLockerInputPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNLockerInputPasswordCell)
                                                                                forIndexPath:indexPath];
    if (indexPath.row + 1 > _password.length) {
        [cell beEmptyState];
    } else {
        [cell beFilledState];
    }
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation DNLockerInputPasswordBoard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createUI];
    }
    return self;
}

- (void)initData {
    _dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0"];
    _alphaDataSource = @[@"",
                         @"ABC",
                         @"DEF",
                         @"GHI",
                         @"JKL",
                         @"MNO",
                         @"PQRS",
                         @"TUV",
                         @"WXYZ",
                         @"",
                         @""];
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = CLEAR_COLOR;
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(75.f, 75.f);
        layout.minimumLineSpacing = 23.f;
        layout.minimumInteritemSpacing = 23.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = CLEAR_COLOR;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.delaysContentTouches = NO;
    [_collectionView registerClass:[DNLockerInputBoardCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNLockerInputBoardCell)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    DNLockerInputBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNLockerInputBoardCell)
                                                                             forIndexPath:indexPath];
    NSString *title = [_dataSource objectAtIndex:indexPath.row];
    NSString *alpha = [_alphaDataSource objectAtIndex:indexPath.row];
    [cell.btn setTitle:title forState:UIControlStateNormal];
    cell.alphaLabel.text = alpha;
    cell.btn.hidden = NO;
    cell.alphaLabel.hidden = NO;
    if (indexPath.row == 9) {
        cell.btn.hidden = YES;
        cell.alphaLabel.hidden = YES;
    }
    [cell setNumberClickAction:^(NSString *number, UIButton *sender){
        if (weakSelf.didInputNumber) {
            weakSelf.didInputNumber(number);
        }
    }];
    return cell;
}

@end
