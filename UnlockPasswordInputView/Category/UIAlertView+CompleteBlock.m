//
//  UIAlertView+CompleteBlock.m
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIAlertView+CompleteBlock.h"
#import <objc/runtime.h>

static NSString * const kCompletionBlockIdentify = @"kCompletionBlockIdentify";

@interface UIAlertView ()
<
    UIAlertViewDelegate
>

@property (copy, nonatomic) void (^CompletionBlock) (UIAlertView *, NSInteger);

@end

@implementation UIAlertView (CompleteBlock)


- (void (^)())CompletionBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)(kCompletionBlockIdentify));
}
- (void)setCompletionBlock:(void (^)())CompletionBlock{
    objc_setAssociatedObject(self, (__bridge const void *)(kCompletionBlockIdentify), CompletionBlock, OBJC_ASSOCIATION_COPY);
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle btnClickBlock:(void (^)(UIAlertView *, NSInteger))btnClickBlock{
    if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil]) {
        self.CompletionBlock = [btnClickBlock copy];
    }
    return self;
}

#pragma mark - uialertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.CompletionBlock) {
        self.CompletionBlock(alertView,buttonIndex);
    }
}



@end
