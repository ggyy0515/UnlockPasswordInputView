//
//  DNLockerInputPasswordView.h
//  Tristan
//
//  Created by Tristan on 2017/4/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNLockerInputPasswordView : UIView


/**
 显示输入密码界面

 @param title 界面标题
 @param completeBlock 完成输入的回调
 @param forgetPasswordAction 忘记密码的回调
 @param dismissBlock 消失回调
 */

+ (void)showWithTitle:(NSString *)title
        completeBlock:(void(^)(NSString *password, DNLockerInputPasswordView *view))completeBlock
 forgetPasswordAction:(void(^)(DNLockerInputPasswordView *view))forgetPasswordAction
         dismissBlock:(void(^)())dismissBlock;

/**
 移除界面
 */
- (void)dismiss;

/**
 清空输入
 */
- (void)clearInput;

@end
