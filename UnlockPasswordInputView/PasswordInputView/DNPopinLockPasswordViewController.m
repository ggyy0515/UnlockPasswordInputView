//
//  DNPopinLockPasswordViewController.m
//  NDanale
//
//  Created by Tristan on 2017/4/19.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "DNPopinLockPasswordViewController.h"
#import "UIViewController+MaryPopin.h"



static CGFloat const passwordVCWidth = 295.f;


static CGFloat const passwordVCHeight = 420.f;


#pragma mark ============================   interface board view    =================================

@interface DNPopinLockerInputPasswordBoard : UIView
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^didInputNumber)(NSString *);

@end

#pragma mark ============================     interface dot cell     =================================

@interface DNPopinLockerInputDotCell : UICollectionViewCell

@property (nonatomic, strong) UIView *dot;

- (void)beEmptyState;
- (void)beFilledState;

@end

#pragma mark ============================    interface board cell    =================================

@interface DNPopinLockerInputBoardCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, copy) void(^numberClickAction)(NSString *, UIButton *);

@end


#pragma mark ============================interface password controller=================================

@interface DNPopinLockPasswordViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, weak) UIViewController *superVC;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DNPopinLockerInputPasswordBoard *board;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableString *password;
@property (nonatomic, copy) void(^completeBlock)(NSString *password, DNPopinLockPasswordViewController *vc);
@property (nonatomic, copy) void(^forgetPasswordAction)(DNPopinLockPasswordViewController *vc);
@property (nonatomic, copy) void(^dismissBlock)();

@end

#pragma mark ============================IPM password controller=================================

@implementation DNPopinLockPasswordViewController

#pragma mark - Life Cycle

+ (void)showWithTitle:(NSString *)title
              superVC:(UIViewController *)superVC
        completeBlock:(void(^)(NSString *password, DNPopinLockPasswordViewController *passwordVC))completeBlock
 forgetPasswordAction:(void(^)(DNPopinLockPasswordViewController *passwordVC))forgetPasswordAction
         dismissBlock:(void(^)())dismissBlock {
    DNPopinLockPasswordViewController *vc = [[self alloc] initWithTitle:title];
    vc.superVC = superVC;
    vc.completeBlock = completeBlock;
    vc.forgetPasswordAction = forgetPasswordAction;
    vc.dismissBlock = dismissBlock;
    
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleSnap];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    vc.popinOptions = BKTPopinDisableAutoDismiss;
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    vc.view.layer.cornerRadius = 15.f;
    [vc setDimmingViewStyle:BKTDimmingViewStyleBlurred];
    [vc setBlurParameters:blurParameters];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionRight];
    
    [vc.superVC presentPopinController:vc
                              fromRect:CGRectMake((SCREEN_WIDTH - passwordVCWidth) / 2.f,
                                                  superVC.view.center.y - passwordVCHeight / 2.f,
                                                  passwordVCWidth,
                                                  passwordVCHeight)
                      needComputeFrame:NO
                              animated:YES
                            completion:nil];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _password = [NSMutableString string];
        _titleString = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WEAK_SELF
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *closeImage = [UIImage imageNamed:@"lock_popin_close"];
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
    }
    [self.view addSubview:_closeBtn];
    [_closeBtn setImage:closeImage forState:UIControlStateNormal];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_right).offset(-10.f);
        make.centerY.mas_equalTo(weakSelf.view.mas_top).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf dismissComplete:^{
            
        }];
    }];
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    [self.view addSubview:_leftBtn];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _leftBtn.backgroundColor = CLEAR_COLOR;
    [_leftBtn setTitle:LString(@"Forgot password?") forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromHexString(@"#0ACC7A") forState:UIControlStateNormal];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-35.f);
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
    [self.view addSubview:_rightBtn];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _rightBtn.backgroundColor = CLEAR_COLOR;
    [_rightBtn setTitle:LString(@"Cancel") forState:UIControlStateNormal];
    [_rightBtn setTitleColor:UIColorFromHexString(@"#0ACC7A") forState:UIControlStateNormal];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftBtn.mas_right);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-35.f);
        make.height.mas_equalTo(weakSelf.rightBtn.titleLabel.font.lineHeight);
    }];
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.password.length == 0) {
            [weakSelf dismissComplete:^{
                
            }];
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
    [self.view addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    _titleLabel.textColor = UIColorFromHexString(@"#999999");
    _titleLabel.text = _titleString;
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(30.f);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(10.f);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10.f);
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.itemSize = CGSizeMake(30.f, 30.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = CLEAR_COLOR;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(40.f);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180.f, 30.f));
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[DNPopinLockerInputDotCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNPopinLockerInputDotCell)];
    
    if (!_board) {
        _board = [[DNPopinLockerInputPasswordBoard alloc] initWithFrame:CGRectZero];
    }
    [self.view addSubview:_board];
    [_board mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).offset(40.f);
        make.size.mas_equalTo(CGSizeMake(passwordVCWidth, 201.f));
    }];
    [_board setDidInputNumber:^(NSString *number){
        if (weakSelf.password.length < 6) {
            [weakSelf.password appendString:number];
            [weakSelf.rightBtn setTitle:LString(@"Delete") forState:UIControlStateNormal];
            [weakSelf.collectionView reloadData];
            if (weakSelf.password.length == 6) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.completeBlock) {
                        weakSelf.completeBlock(weakSelf.password, weakSelf);
                    }
                });
            }
        }
    }];
}

#pragma mark - Actions

- (void)dismissComplete:(void(^)())callBack {
    WEAK_SELF
    [self.superVC dismissCurrentPopinControllerAnimated:YES completion:^{
        STRONG_SELF
        if (strongSelf.dismissBlock) {
            strongSelf.dismissBlock();
        }
        if (callBack) {
            callBack();
        }
    }];
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
    DNPopinLockerInputDotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNPopinLockerInputDotCell)
                                                                                forIndexPath:indexPath];
    if (indexPath.row + 1 > _password.length) {
        [cell beEmptyState];
    } else {
        [cell beFilledState];
    }
    return cell;
}


@end

#pragma mark ============================     IPM dot cell     =================================

@implementation DNPopinLockerInputDotCell

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
    _dot.layer.borderColor = UIColorFromHexString(@"#CBCBCB").CGColor;
    _dot.backgroundColor = CLEAR_COLOR;
}

- (void)beFilledState {
    _dot.layer.borderWidth = 0.f;
    _dot.backgroundColor = UIColorFromHexString(@"#222222");
}

@end

#pragma mark ============================   IPM board view    =================================

@implementation DNPopinLockerInputPasswordBoard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createUI];
    }
    return self;
}

- (void)initData {
    _dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0"];
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = CLEAR_COLOR;
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(57.f, 39.f);
        layout.minimumLineSpacing = 15.f;
        layout.minimumInteritemSpacing = 22.f;
        layout.sectionInset = UIEdgeInsetsMake(0, 40.f, 0, 40.f);
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
    [_collectionView registerClass:[DNPopinLockerInputBoardCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNPopinLockerInputBoardCell)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    DNPopinLockerInputBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(DNPopinLockerInputBoardCell)
                                                                                  forIndexPath:indexPath];
    NSString *title = [_dataSource objectAtIndex:indexPath.row];
    [cell.btn setTitle:title forState:UIControlStateNormal];
    cell.btn.hidden = NO;
    if (indexPath.row == 9) {
        cell.btn.hidden = YES;
    }
    [cell setNumberClickAction:^(NSString *number, UIButton *sender){
        if (weakSelf.didInputNumber) {
            weakSelf.didInputNumber(number);
        }
    }];
    return cell;
}

@end

#pragma mark ============================    IPM board cell    =================================

@implementation DNPopinLockerInputBoardCell

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
    
    if (!_btn) {
        _btn = [UIButton new];
    }
    [self.contentView addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
    }];
    [_btn setTitleColor:UIColorFromHexString(@"#CCCCCC") forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [_btn setBackgroundImage:[UIImage imageNamed:@"lock_input_board_btn"] forState:UIControlStateNormal];
    [_btn handleControlEvent:UIControlEventTouchDown withBlock:^(UIButton *sender) {
        if (weakSelf.numberClickAction) {
            weakSelf.numberClickAction(sender.titleLabel.text, sender);
        }
    }];
}

@end

