//
//  DNLockerInputBoardCell.h
//  Tristan
//
//  Created by Tristan on 2017/4/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNLockerInputBoardCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *alphaLabel;
@property (nonatomic, copy) void(^numberClickAction)(NSString *, UIButton *);

@end
