# UnlockPasswordInputView

+ 一个方法即可完成调用

  type1: DNLockerInputPasswordView 

  /**

 显示输入密码界面

 @param title 界面标题

 @param completeBlock 完成输入的回调

 @param forgetPasswordAction 忘记密码的回调

 @param dismissBlock 消失回调`

 */

  \+ (void)showWithTitle:(NSString *)title

  completeBlock:(void(^)(NSString *password, DNLockerInputPasswordView *view))completeBlock

  forgetPasswordAction:(void(^)(DNLockerInputPasswordView *view))forgetPasswordAction

  dismissBlock:(void(^)())dismissBlock;

  /**

  移除界面

  */

  \- (void)dismiss;

  /**

  清空输入

  */

  \- (void)clearInput;

  type2: DNPopinLockerInputPasswordBoard

  /**

  显示输入密码界面

  @param title 界面标题

  @param superVC 父控制器

  @param completeBlock 完成输入的回调

  @param forgetPasswordAction 忘记密码的回调

  @param dismissBlock 消失回调

  */

  \+ (void)showWithTitle:(NSString *)title

    superVC:(UIViewController *)superVC

    completeBlock:(void(^)(NSString *password, DNPopinLockPasswordViewController *passwordVC))completeBlock

    forgetPasswordAction:(void(^)(DNPopinLockPasswordViewController *passwordVC))forgetPasswordAction

    dismissBlock:(void(^)())dismissBlock;

  /**

  移除界面

  @param callBack 完成移除后的回调

  */

  \- (void)dismissComplete:(void(^)())callBack;

  /**

  清空输入

  */

  \- (void)clearInput;

