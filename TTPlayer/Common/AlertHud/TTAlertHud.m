//
//  TTAlertHud.m
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/22.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
/**
 HUD 和 Alert
 */

#import "TTAlertHud.h"
#import "TTConfiguration.h"
#import "TTProgressHUD.h"
#import <UIKit/UIKit.h>

const NSInteger kAlertCancelButtonIndex = 0;
const NSInteger kAlertDestructiveButtonIndex = 1;
const NSInteger kAlertFirstDefaultButtonIndex = 2;

static CGFloat const kHudDuration = 2.0;    //kHudDuration 秒后hud隐藏

@interface TTAlertHud ()

@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) TTProgressHUD *hud;

@end

@implementation TTAlertHud

+ (instancetype)sharedAlertHud {
    
    static TTAlertHud *alert = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[self alloc] init];
    });
    
    return alert;
}

#pragma mark - Alert

- (void)showAlertControllInController:(UIViewController *)controller
                            withTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                     destructiveTitle:(NSString *)destructiveTitle
                        defaultTitles:(NSArray<NSString *> *)defaultTitles
                             tapBlock:(AlertCompletionBlock)tapBlock {
    
    [self showAlertControllInController:controller
                              withTitle:title
                                message:message
                         preferredStyle:UIAlertControllerStyleAlert
                            cancelTitle:cancelTitle
                       destructiveTitle:destructiveTitle
                          defaultTitles:defaultTitles
                    popoverResourceView:nil
                               tapBlock:tapBlock];
}

- (void)showAlertSheetInController:(UIViewController *)controller
                         withTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                  destructiveTitle:(NSString *)destructiveTitle
                     defaultTitles:(NSArray <NSString *>*)defaultTitles
               popoverResourceView:(UIView *)sourceView
                          tapBlock:(AlertCompletionBlock)tapBlock {
    
    [self showAlertControllInController:controller
                              withTitle:title
                                message:message
                         preferredStyle:UIAlertControllerStyleActionSheet
                            cancelTitle:cancelTitle
                       destructiveTitle:destructiveTitle
                          defaultTitles:defaultTitles
                    popoverResourceView:sourceView
                               tapBlock:tapBlock];
}

- (void)showAlertControllInController:(UIViewController *)controller
                            withTitle:(NSString *)title
                              message:(NSString *)message
                       preferredStyle:(UIAlertControllerStyle)style
                          cancelTitle:(NSString *)cancelTitle
                     destructiveTitle:(NSString *)destructiveTitle
                        defaultTitles:(NSArray *)defaultTitles
                  popoverResourceView:(UIView *)sourceView
                             tapBlock:(AlertCompletionBlock )tapBlock
{
    [self dismissAnimated:NO];
    
    self.alert = [UIAlertController alertControllerWithTitle:title
                                                     message:message
                                              preferredStyle:style];
    if (TT_STRING_NOT_EMPTY(cancelTitle)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action)
        {
            if (tapBlock) {
                tapBlock(action, kAlertCancelButtonIndex);
            }
        }];
        [self.alert addAction:cancel];
    }
    
    if (TT_STRING_NOT_EMPTY(destructiveTitle)) {
        UIAlertAction *destructive = [UIAlertAction actionWithTitle:destructiveTitle
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction * _Nonnull action)
        {
            if (tapBlock) {
                tapBlock(action, kAlertDestructiveButtonIndex);
            }
        }];
        [self.alert addAction:destructive];
    }
    
    if (TT_ARRAY_NOT_EMPTY(defaultTitles)) {
        for (NSInteger i = 0; i < defaultTitles.count; i++) {
            NSString *title = defaultTitles[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         if (tapBlock) {
                                             tapBlock(action, i + kAlertFirstDefaultButtonIndex);
                                         }
                                     }];
            [self.alert addAction:action];
        }
    }
    
    if (sourceView) {
        UIPopoverPresentationController *popover = self.alert.popoverPresentationController;
        
        if (popover) {
            popover.sourceView = sourceView;
            popover.sourceRect = sourceView.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    
    [[self topViewControllerOnController:controller] presentViewController:self.alert
                                                                  animated:YES
                                                                completion:nil];
}

#pragma mark - Hud

- (void)showMessage:(NSString *)message inView:(UIView *)view {
    
    [self showMessage:message inView:view duration:kHudDuration];
}

- (void)showMessage:(NSString *)message inView:(UIView *)view duration:(CGFloat)duration {
    
    [self dismissAnimated:NO];
    
    TTProgressHUD *hud = [TTProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    self.hud = hud;
    
    [hud hideAnimated:YES afterDelay:duration];
}

- (void)showMessage:(NSString *)message toView:(UIView *)view completionBlock:(void(^)(void))completion {
    
    [self dismissAnimated:NO];
    
    TTProgressHUD *hud = [TTProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    self.hud = hud;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(kHudDuration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^
    {
        [hud hideAnimated:YES];
        if (completion) completion();
    });
}

#pragma mark - UI

- (void)showHudAddTo:(UIView *_Nonnull)view animated:(BOOL)animated {
    
    TTProgressHUD *hud = [TTProgressHUD showHUDAddedTo:view animated:YES];
    self.hud = hud;
}

/**
 保证当前视图只显示一个Alert或Hud
 */
- (void)dismissAnimated:(BOOL)animated {
    
    if (self.alert) {
        [self.alert dismissViewControllerAnimated:animated completion:^{
            self.alert = nil;
        }];
    }
    
    if (self.hud) {
        [self.hud hideAnimated:animated];
        [self.hud removeFromSuperview];
        self.hud = nil;
    }
}

- (UIViewController *)topViewControllerOnController:(UIViewController *)controller {
    
    UIViewController *top = controller;
    
    UIViewController *above;
    while ((above = top.presentedViewController)) {
        if ([above isKindOfClass:[UIAlertController class]]) {
            break;
        }
        top = above;
    }
    
    return top;
}

@end
