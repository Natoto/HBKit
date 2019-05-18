//
//  ArichiveObject.h
//  SODA
//
//  Created by boob on 2017/12/7.
//  Copyright © 2017年 YY.Inc. All rights reserved.
//
 
#import <Foundation/Foundation.h>

@interface NSString(hbcache)
- (NSString *)md532BitLower;
@end

#pragma mark - 这个是基类，用于归档 打印 校验
//如 HBOBJ_SETVALUE_FORPATH(self, @"UserInfo", @"infos");
#define HBOBJ_SETVALUE_FORPATH(OBJ,VALUE,PATH) [OBJ setValue:VALUE forKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@",PATH]];

@interface SODALaboratoryArchiveObject : NSObject <NSCoding,NSCopying,NSMutableCopying>

@end

/**
 * 实验室的配置，切换正式测试环境
 */
@interface SODALaboratoryEntity:SODALaboratoryArchiveObject

@property (nonatomic, strong) NSString *hiidoTestDomain;
@property (nonatomic, assign) BOOL isConnecTestServer; 
@end
 
