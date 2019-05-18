//
//  NOZLaboratory.h
//  Pods
//
//  Created by boob on 2018/11/29.
//

#ifndef NOZLaboratory_h
#define NOZLaboratory_h

#ifdef DEBUG

//#define TesterLog(FORMAT,...) //logDebug([NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#define TesterLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define TesterLogMethod NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, NSStringFromClass([self class]));
#else

//#define TesterLog(FORMAT,...) logInfo([NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#  define TesterLog(...) ;
#  define TesterLogMethod ;
#endif



#if __has_include( <HBTesterKit/HBKitWatchDog.h>)
#import <HBTesterKit/HBKitWatchDog.h>
#elif  __has_include( <HBKit/HBKitWatchDog.h>)
#import <HBKit/HBKitWatchDog.h>
#endif
 
#import "NOZLaboratoryService.h"
#import "UIView+NOZViewController.h"
#import "NozUserConfigViewController.h"
#import "NOZLabCommon.h"
#endif /* NOZLaboratory_h */
