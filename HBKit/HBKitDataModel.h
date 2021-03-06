//
//  HBKitDataModel.h
//  Pods
//
//  Created by HUANGBO on 16/11/30.
//
//

#import <Foundation/Foundation.h>

@class cell_struct_ARRAY;

@interface HBKitDataModel : NSObject

- (void)setDataDictionary:(NSMutableDictionary *)dataDictionary;
- (NSMutableDictionary *)dataDictionary;
- (NSMutableDictionary *)viewConfigDictionary;
/**
 *  从PLIST 文件中加载配置信息
 *
 *  @param plistname plist文件的名字
 */
- (void)loadplistConfig:(NSString *)plistname
        configViewblock:(void (^)(NSMutableDictionary *dataDictionary))configViewblock;

- (void)loadplistConfig:(NSString *)plistname
               filepath:(NSString *)filepath
        configViewblock:(void (^)(NSMutableDictionary *dataDictionary))configViewblock;

/**
 *  从PLIST 文件中加载配置信息放到一个字典中而不是直接对datadictionary赋值
 *
 *  @param plistname plist文件的名字
 */
- (NSMutableDictionary *)loadplistConfigToDictionary:(NSString *)plistname;
- (NSMutableDictionary *)loadplistConfigToDictionary:(NSString *)plistname filepath:(NSString *)filepath;
/**
 *  从json文件中配置信息
 *
 *  @param jsonfilepath  json文件存放的路径名
 */

- (void)loadjsonfileConfig:(NSString *)jsonfilename
           configViewblock:(void (^)(cell_struct_ARRAY *vclist))configViewblock;

- (void)loadjsonfileConfig:(NSString *)jsonfilename
                  filepath:(NSString *)filepath
           configViewblock:(void (^)(cell_struct_ARRAY *vclist))configViewblock;
@end
