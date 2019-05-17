//
//  ArichiveObject.m
//  SODA
//
//  Created by boob on 2017/12/7.
//  Copyright © 2017年 YY.Inc. All rights reserved.
//

#import "NOZLaboratoryArchiveObject.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

@implementation SODALaboratoryArchiveObject

-(id)mutableCopyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [self valueForKey:key];
                [object setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return object;
}

-(id)copyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    if (object) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [self valueForKey:key];
                [object setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return object;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [aDecoder decodeObjectForKey:key];
                @try {
                    if ([self.ocreservedwords containsObject:key]) {
                        continue;
                    }
                    if (value) {
                        [self setValue:value forKey:key];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s %@ 不能正常赋值",__FUNCTION__, key);
                }
                @finally {
                    
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return self;
}

/**
 * 保留字
 */
-(NSArray *)ocreservedwords{
    
    return @[@"debugDescription",@"description",@"hash",@"superclass"];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                               encoding:NSUTF8StringEncoding];
        
        if ([self.ocreservedwords containsObject:key]) {
            continue;
        }
        id value=[self valueForKey:key];
        if (value && key) {
            @try{
                if ([value isKindOfClass:[NSObject class]]) {
                    [aCoder encodeObject:value forKey:key];
                } else {
                    NSNumber * v = [NSNumber numberWithInt:(int)value];
                    [aCoder encodeObject:v forKey:key];
                }
            }
            @catch(NSException * ex){
                NSLog(@"😑，序列号出了一个错，%@",ex.description);
            }
        }
    }
    free(properties);
    properties = NULL;
}

@end




@implementation NSString(hbcache)

//md5 32位 加密 （小写）
- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end


@implementation SODALaboratoryEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
} 
@end
 
