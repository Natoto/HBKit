//
//  HBBaseViewController+DirWatchDog.h
//  Pods
//
//  Created by boob on 16/12/2.
//
//

#import "HBKit.h"

@interface NSObject(DirWatchDog)

/**
 *  从plist,json等文件中加载配置信息
 *
 *  @param filename  文件名字
 *  @param postfix   文件后缀
 *  @param directory 文件所在的目录
 *
 
 1. 需要在info.plist文件中做如下配置 projectPath $(SRCROOT)/$(TARGET_NAME)
 ---
 <key>projectPath</key>
 <string>$(SRCROOT)/$(TARGET_NAME)</string>
 ---
 2. 在工程文件中创建监听的目录 如 resource，将目录拉入工程中，注意Added folders选择Create folder references ,然后选择工程完成
 3. 添加此方法，每次按cmd+s会收到一个block，可以在此回调中完成重新配置,默认回调 configcellstructs 方法
 4. 所有的实时刷新都只在模拟器中进行
 */
- (void)hb_loadfilesConfig:(NSString *)filename
               postfix:(NSString *)postfix
             directory:(NSString *)directory
          infoplistkey:(NSString *)infplistkey
                update:(void(^)(NSString * mainScriptPath))block;
 
@end


