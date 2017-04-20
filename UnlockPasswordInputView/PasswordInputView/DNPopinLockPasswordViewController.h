//
//  DNPopinLockPasswordViewController.h
//  NDanale
//
//  Created by Tristan on 2017/4/19.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNPopinLockPasswordViewController : UIViewController

/**
 显示输入密码界面
 
 @param title 界面标题
 @param superVC 父控制器
 @param completeBlock 完成输入的回调
 @param forgetPasswordAction 忘记密码的回调
 @param dismissBlock 消失回调
 */

+ (void)showWithTitle:(NSString *)title
              superVC:(UIViewController *)superVC
        completeBlock:(void(^)(NSString *password, DNPopinLockPasswordViewController *passwordVC))completeBlock
 forgetPasswordAction:(void(^)(DNPopinLockPasswordViewController *passwordVC))forgetPasswordAction
         dismissBlock:(void(^)())dismissBlock;

/**
 移除界面
 */
- (void)dismissComplete:(void(^)())callBack;

/**
 清空输入
 */
- (void)clearInput;

@end
