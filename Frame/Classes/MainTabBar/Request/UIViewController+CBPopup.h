//
//  UIViewController+CBPopup.h
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CBPopupViewAnimation) {
    CBPopupViewAnimationFade = 0,
    CBPopupViewAnimationSlideFromBottom,
    CBPopupViewAnimationSlideFromTop,
    CBPopupViewAnimationSlideFromLeft,
    CBPopupViewAnimationSlideFromRight
};

typedef NS_ENUM(NSInteger, CBPopupViewAligment) {
    CBPopupViewAligmentCenter = 0,
    CBPopupViewAligmentTop,
    CBPopupViewAligmentBottom,
    CBPopupViewAligmentLeft,
    CBPopupViewAligmentRight
};

@interface UIViewController (CBPopup)
- (void)cb_removePresentPopupView;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                             aligment:(CBPopupViewAligment)aligment
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                             aligment:(CBPopupViewAligment)aligment
                overlayDismissEnabled:(BOOL)overlayDismissEnabled
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_dismissPopupViewControllerAnimated:(BOOL)animated
                                   completion:(void(^)(void))completion;

- (void)cb_dismissPopupViewControllerToRootAnimated:(BOOL)animated
                                         completion:(void(^)(void))completion;
@end

