//
//  ViewController.m
//  UnlockPasswordInputView
//
//  Created by Tristan on 2017/4/14.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ViewController.h"
#import "DNLockerInputPasswordView.h"
#import "DNPopinLockPasswordViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show];
        });
    });
    
}

-(void)setBackground{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#404660"];
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#404660"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#6c728b"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (IBAction)show {
    WEAK_SELF
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"choose type"
                                          cancelButtonTitle:@"type1"
                                          otherButtonTitles:@"type2"
                                              btnClickBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                  [weakSelf showWithType:buttonIndex];
                                              }];
    [alert show];
}

- (void)showWithType:(NSInteger)type {
    switch (type) {
        case 0:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DNLockerInputPasswordView showWithTitle:@"please input password"
                                               completeBlock:^(NSString *password, DNLockerInputPasswordView *view) {
                                                   //do something...
                                               }
                                        forgetPasswordAction:^(DNLockerInputPasswordView *view) {
                                            //do something...
                                        }
                                                dismissBlock:^{
                                                    //do something...
                                                }];
                });
            });
        }
            break;
        case 1:
        {
            [DNPopinLockPasswordViewController showWithTitle:@"please input password"
                                                     superVC:self
                                               completeBlock:^(NSString *password, DNPopinLockPasswordViewController *passwordVC) {
                                                   [passwordVC dismissComplete:^{
                                                       //do something
                                                   }];
                                               }
                                        forgetPasswordAction:^(DNPopinLockPasswordViewController *passwordVC) {
                                            [passwordVC dismissComplete:^{
                                                //do something
                                            }];
                                        }
                                                dismissBlock:^{
                                                    //do something
                                                }];
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
