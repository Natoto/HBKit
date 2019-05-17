//
//  NOZLabCommon.h
//  NOZLaboratory
//
//  Created by boob on 2019/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NOZLabCommon : NSObject

+(void)exitApp;

+ (void)clearCacheData;

+ (void)clearUserDefaultData;

+ (void)showAlert:(NSString *)message
             from:(UIViewController *)from
     comfirmBlock:(void (^)(void))comfirmBlock
     dismissBlock:(void (^)(void))dismissBlock;

@end

NS_ASSUME_NONNULL_END
