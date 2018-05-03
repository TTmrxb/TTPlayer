//
//  TTAlertHud.h
//  TTPlayer
//
//  Created by jyzx101 on 2017/12/22.
//  Copyright © 2017年 Elliot Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const NSInteger kAlertCancelButtonIndex;
extern const NSInteger kAlertDestructiveButtonIndex;
extern const NSInteger kAlertFirstDefaultButtonIndex;

typedef void(^AlertCompletionBlock)(UIAlertAction * _Nonnull action, NSInteger buttonIndex);

@interface TTAlertHud : NSObject

+ (instancetype _Nullable)sharedAlertHud;

- (instancetype _Nullable)init __attribute__((unavailable("请使用单例方法获取AlertHud")));

#pragma mark - Alert

- (void)showAlertControllInController:(UIViewController *_Nonnull)controller
                            withTitle:(NSString *_Nullable)title
                              message:(NSString *_Nullable)message
                          cancelTitle:(NSString *_Nullable)cancelTitle
                     destructiveTitle:(NSString *_Nullable)destructiveTitle
                        defaultTitles:(NSArray <NSString *>*_Nullable)defaultTitles
                             tapBlock:(AlertCompletionBlock _Nullable)tapBlock;

- (void)showAlertSheetInController:(UIViewController *_Nonnull)controller
                         withTitle:(NSString *_Nullable)title
                           message:(NSString *_Nullable)message
                       cancelTitle:(NSString *_Nullable)cancelTitle
                  destructiveTitle:(NSString *_Nullable)destructiveTitle
                     defaultTitles:(NSArray <NSString *>*_Nullable)defaultTitles
               popoverResourceView:(UIView *_Nullable)sourceView
                          tapBlock:(AlertCompletionBlock _Nullable)tapBlock;

#pragma mark - Hud

- (void)showMessage:(NSString *_Nullable)message inView:(UIView *_Nonnull)view;

- (void)showMessage:(NSString *_Nullable)message
             inView:(UIView *_Nonnull)view
           duration:(CGFloat)duration;

- (void)showMessage:(NSString *_Nullable)message
             toView:(UIView *_Nonnull)view
    completionBlock:(void(^_Nullable)(void))completion;

#pragma mark - UI

- (void)showHudAddTo:(UIView *_Nonnull)view animated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

@end
