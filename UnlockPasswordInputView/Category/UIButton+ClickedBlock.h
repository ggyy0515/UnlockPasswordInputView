//
//  UIButton+ClickedBlock.h
//  Tristan
//
//  Created by Tristan on 15/12/7.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ClickedBlock)

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(void(^)(UIButton *sender))block;

@end
