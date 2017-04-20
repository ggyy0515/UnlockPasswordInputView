//
//  UIAlertView+CompleteBlock.h
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CompleteBlock)

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitle
                btnClickBlock:(void(^)(UIAlertView * alertView, NSInteger buttonIndex))btnClickBlock;



@end
