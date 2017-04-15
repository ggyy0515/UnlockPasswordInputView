//
//  UIButton+ClickedBlock.m
//  Tristan
//
//  Created by Tristan on 15/12/7.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIButton+ClickedBlock.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic,copy) void (^ClickedBlock)(UIButton *);

@end

static NSString *kUIButtonClickedBlockIdentify = @"kUIButtonClickedBlockIdentify";

@implementation UIButton (ClickedBlock)

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(void(^)(UIButton *sender))block{
    [self setClickedBlock:block];
    [self addTarget:self action:@selector(buttonClickedAction:) forControlEvents:controlEvent];
}

- (void)buttonClickedAction:(UIButton *)sender{
    self.ClickedBlock(sender);
}

- (void)setClickedBlock:(void (^)(UIButton *))ClickedBlock{
    objc_setAssociatedObject(self, (__bridge const void *)(kUIButtonClickedBlockIdentify), ClickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))ClickedBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)(kUIButtonClickedBlockIdentify));
}


@end
