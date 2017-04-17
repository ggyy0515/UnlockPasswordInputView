# UnlockPasswordInputView

一个方法即可完成调用
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
