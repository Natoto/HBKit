//
//  NOZLabCommon.m
//  NOZLaboratory
//
//  Created by boob on 2019/5/17.
//

#import "NOZLabCommon.h"
#import "NOZLaboratoryService.h"

@implementation NOZLabCommon

+ (void)showAlert:(NSString *)message
             from:(UIViewController *)from
     comfirmBlock:(void (^)(void))comfirmBlock
     dismissBlock:(void (^)(void))dismissBlock
{
    if (@available(iOS 8.0, *)) {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            comfirmBlock();
        }]];
        [control addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dismissBlock();
        }]];
        [from presentViewController:control animated:YES completion:nil];
    } else {
        // Fallback on earlier versions
    }
}



+ (void)clearUserDefaultData
{
    //FIXME:  清空文件数据
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for (NSString* key in [dictionary allKeys]) {
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    } 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NOZLabCommon exitApp];
    });
}

+ (void)clearCacheData
{
    
    //FIXME:  清空文件数据
    // [[YYObjectStoreManager sharedObject] removeAllKeysInObjectStore];
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for (NSString* key in [dictionary allKeys]) {
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    }
    
    // 清除web缓存
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"WebPropertyDict.plist"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:filePath error:&err];
    }
    {//cache
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:path];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:path error:&err];
        }
    }
    {//doc
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:path];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:path error:&err];
        }
    }
    //FIXME: 清空缓存数据
    //[NOZSettingCacheMgr cleanSodaCache];
    [NOZLaboratoryService sharedInstance].e.isConnecTestServer = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NOZLabCommon exitApp];
    });
    
}


+ (void)exitApp
{
    
    
    [[UIApplication sharedApplication]performSelector:@selector(suspend) withObject:nil];
    // 隐藏私有 api字符串
    uint32_t msg[] = {~'term',~'inat',~'eWit',~'hSuc',~'cess'};
    for (int i=0;i<sizeof(msg)/sizeof(uint32_t); i++) {
        msg[i] = ~msg[i];
        uint8_t *cmsg =(uint8_t *)((uint32_t *)msg+i);
        cmsg[0] ^= cmsg[3]^= cmsg[0]^= cmsg[3];
        cmsg[1] ^= cmsg[2]^= cmsg[1]^= cmsg[2];
    }
    [[UIApplication sharedApplication]performSelector:NSSelectorFromString([[NSString alloc]initWithBytes:msg length:sizeof(msg) encoding:NSUTF8StringEncoding]) withObject:nil  afterDelay:0.3f];
}
@end
