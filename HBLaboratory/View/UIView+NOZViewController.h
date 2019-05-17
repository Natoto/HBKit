//
//  UIView+SODAViewController.h
//  SODA
//
//  Created by peng jun on 2017/12/5.
//  Copyright © 2017年 YY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include( <HBTesterKit/HBTesterKit.h>)
#import <HBTesterKit/HBTesterKit.h>
#elif  __has_include( <HBKit/HBKit.h>)
#import <HBKit/HBKit.h>
#endif

@interface UIWindow(shake)

@end

@interface UIView (NOZViewController)

+ (UIViewController *)noz_currentViewController;
- (UIViewController *)noz_currentViewController;

@end
 
