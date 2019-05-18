//
//  UIView+SODAViewController.m
//  SODA
//
//  Created by peng jun on 2017/12/5.
//  Copyright © 2017年 YY.Inc. All rights reserved.
//

#import "UIView+NOZViewController.h"
#import "NOZLaboratoryService.h"

@implementation UIWindow(shake)

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"📳 摇晃了手机");
        [self showHBTester];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)showHBTester
{

    NOZLabCallBackObject *obj = [NOZLabCallBackObject notifyWithType:klab_notifytype_showlab];
    if ([[NOZLaboratoryService sharedInstance].dataSource lab_shakeToShow]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:klab_notify_name object:obj];
    }
    if (NOZLaboratoryService.sharedInstance.delegate) {
        [NOZLaboratoryService.sharedInstance.delegate lab_configSelectedWithNotifyObject:obj];
    }
    
}
 
@end



@implementation UIView (NOZViewController)

#pragma mark - viewcontroller cycle

- (UIViewController *)noz_currentViewController
{
    return [UIView noz_currentViewController];
}
+ (UIViewController *)noz_currentViewController
{
    
    UIViewController *vc = [self currentVisiableRootViewController];
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    return vc;
    
    
}

+ (UIViewController *) currentVisiableRootViewController
{
    
    __block UIViewController *result = nil;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    NSArray *windowSubviews = [topWindow subviews];
    
    [windowSubviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {
         UIView *rootView = obj;
         
         if ([NSStringFromClass([rootView class]) isEqualToString:@"UITransitionView"]) {
             
             NSArray *aSubViews = rootView.subviews;
             
             [aSubViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 UIView *tempView = obj;
                 
                 id nextResponder = [tempView nextResponder];
                 
                 if ([nextResponder isKindOfClass:[UIViewController class]]) {
                     result = nextResponder;
                     *stop = YES;
                 }
             }];
             *stop = YES;
         } else {
             
             id nextResponder = [rootView nextResponder];
             
             if ([nextResponder isKindOfClass:[UIViewController class]]) {
                 result = nextResponder;
                 *stop = YES;
             }
         }
     }];
    
    if (result == nil && [topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
    }
    
    return result;
}

@end
