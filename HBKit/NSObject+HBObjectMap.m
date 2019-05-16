//Copyright (c) 2012 The Board of Trustees of The University of Alabama
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions
//are met:
//
//1. Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//3. Neither the name of the University nor the names of the contributors
//may be used to endorse or promote products derived from this software
//without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//OF THE POSSIBILITY OF SUCH DAMAGE.


#import "NSObject+HBObjectMap.h"

static const char _hbbase64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@implementation NSScanner (HBXMLScan)

- (BOOL)hb_isAtEndOfTag:(NSString *)tag
{
    NSInteger scanPos = [self scanLocation];
    NSString *trash = @"";
    [self scanUpToString:[NSString stringWithFormat:@"</%@", tag] intoString:&trash];
    if (trash.length > 0) {
        [self setScanLocation:scanPos];
        return NO;
    }
    else {
        [self setScanLocation:scanPos];
        return YES;
    }
}

- (NSString *)hb_nextXMLTag
{
    NSString *trash = @"", *tag = @"";
    NSInteger scanPos = [self scanLocation];
    [self scanUpToString:@"<" intoString:&trash];
    [self scanString:@"<" intoString:&trash];
    if ([[self hb_nextCharacter] isEqualToString:@"/"]) {
        [self scanUpToString:@">" intoString:&trash];
        scanPos = [self scanLocation];
        [self scanUpToString:@"<" intoString:&trash];
        [self scanString:@"<" intoString:&trash];
    }
    [self scanUpToString:@">" intoString:&tag];
    [self setScanLocation:scanPos];
    tag = [tag stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return tag;
}

- (NSString *)hb_nextCharacter
{
    NSInteger scanPos = [self scanLocation];
    if (scanPos < [self string].length - 1) {
        return [[self string] substringWithRange:NSMakeRange(scanPos+1, 1)];
    }
    return nil;
}

- (void)hb_skipTag:(NSString *)tag
{
    NSString *trash = @"";
    if ([tag rangeOfString:@" "].location != NSNotFound) {
        [self scanUpToString:@">" intoString:&trash];
        [self scanString:@">" intoString:&trash];
    }
    else if ([tag rangeOfString:@"/"].location != NSNotFound) {
        [self scanUpToString:@"/" intoString:&trash];
        [self scanString:@"/" intoString:&trash];
    }
    else {
        [self scanUpToString:[NSString stringWithFormat:@"</%@", tag] intoString:&trash];
        [self scanString:[NSString stringWithFormat:@"</%@", tag] intoString:&trash];
        [self scanUpToString:@">" intoString:&trash];
        [self scanString:@">" intoString:&trash];
    }
}

- (NSString *)hb_getNextValue
{
    NSString *trash = @"", *value = @"";
    [self scanUpToString:@">" intoString:&trash];
    [self scanString:@">" intoString:&trash];
    [self scanUpToString:@"<" intoString:&value];
    return value;
}

@end

//////////


@implementation NSObject (HBObjectMap)

#pragma mark - Init Methods
- (instancetype)hb_initWithJSONData:(NSData *)data
{
    
    @try {
        return [self hb_initWithObjectData:data type:HBCAPSDataTypeJSON];
    }
    @catch (NSException *exception) {
        NSLog(@"🙅 发生了一个错误! %s \n%@",__FUNCTION__,exception.description);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HBUncaughtExceptionHandler**notify_CrachReport" object:exception.description];
        return nil;
    }
    @finally {
        
    }
}

- (void)hbO_setValue:(id)value forKey:(NSString *)key
{
    
    @try {
        [self setValue:value forKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"出错了，没有这个key %@",key);
    }
}

- (instancetype)hb_initWithXMLData:(NSData *)data
{
    return [self hb_initWithObjectData:data type:HBCAPSDataTypeXML];
}

- (instancetype)hb_initWithSOAPData:(NSData *)data
{
    return [self hb_initWithObjectData:data type:HBCAPSDataTypeSOAP];
}

- (instancetype)hb_initWithObjectData:(NSData *)data type:(HBCAPSDataType)type
{
    if (!data) {
        return nil;
    }
    switch (type) {
        case HBCAPSDataTypeJSON:
            return [NSObject hb_objectOfClass:[self class] fromJSONData:data];
            break;
        case HBCAPSDataTypeXML:
            return [NSObject hb_objectOfClass:NSStringFromClass([self class]) fromXML:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            break;
        case HBCAPSDataTypeSOAP:
            return [NSObject hb_objectOfClass:NSStringFromClass([self class]) fromXML:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)hb_arrayOfType:(Class)objectClass FromJSONData:(NSData *)data
{
    return [NSObject hb_objectOfClass:objectClass fromJSONData:data];
}


#pragma mark - XML to Object
+ (id)hb_objectOfClass:(NSString *)object fromXML:(NSString *)xml
{
    // Create your object
    id newObject = [[NSClassFromString(object) alloc] init];
    
    // Create NSScanner from XML
    // - Use it to remove crap from beginning
    NSScanner *scanner = [NSScanner scannerWithString:xml];
    NSString *trash = @"";
    [scanner scanUpToString:[NSString stringWithFormat:@"%@", object] intoString:&trash];
    [scanner scanUpToString:@">" intoString:&trash];
    [scanner scanString:@">" intoString:&trash];
    
    // Create your object from the XML using the scanner
    newObject = [newObject hb_newObjectFromXMLScanner:scanner];
    
    // Return the object
    return newObject;
}

- (id)hb_newObjectFromXMLScanner:(NSScanner *)scanner
{
    // Scan the object and create properties of the object
    // until the scanner has reached the end tag
    while (![scanner hb_isAtEndOfTag:[self hb_nameOfClass]]) {
        NSDictionary *mapDictionary = [self hb_propertyDictionary];
        NSString *nextTag = [scanner hb_nextXMLTag];
        
        // If the upcoming tag is a property of the object: create it.
        // Else: Skip it.
        if (mapDictionary[nextTag]) {
            if ([nextTag rangeOfString:@" /"].location != NSNotFound) {
                [scanner hb_skipTag:nextTag];
                continue;
            }
            [self hbO_setValue:[self hb_nextXMLValueForTag:nextTag withScanner:scanner] forKey:nextTag];
        }
        else {
            [scanner hb_skipTag:nextTag];
        }
    }
    
    return self;
}

- (id)hb_nextXMLValueForTag:(NSString *)tag withScanner:(NSScanner *)scanner
{
    // Get the name of the class to check type
    objc_property_t property = class_getProperty([self class], [tag UTF8String]);
    NSString *className = [[self hb_typeFromProperty:property] substringWithRange:NSMakeRange(3, [self hb_typeFromProperty:property].length - 4)];
    
    // Get the value from the Scanner
    NSString *value = [scanner hb_getNextValue];
    
    // Create your object
    id objForKey;
    
    // Check Types / Assign *value accordingly
    if ([className isEqualToString:@"NSString"]) {
        objForKey = value;
    }
    else if ([className isEqualToString:@"NSDate"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:OMDateFormat];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
        objForKey = [formatter dateFromString:value];
    }
    else if ([className isEqualToString:@"NSNumber"]) {
        if ([value isEqualToString:@"true"]) {
            objForKey = @(YES);
        }
        else if ([value isEqualToString:@"false"]) {
            objForKey = @(NO);
        }
        else {
            objForKey = @([value floatValue]);
        }
    }
    else if ([className isEqualToString:@"NSArray"]) {
        NSMutableArray *oArray = [@[] mutableCopy];
        NSString *nextTag = [scanner hb_nextXMLTag];
        while (![scanner hb_isAtEndOfTag:tag]) {
            [oArray addObject:[self hb_nextArrayValueForTag:nextTag fromScanner:scanner]];
        }
        objForKey = oArray;
    }
    else if ([className isEqualToString:@"NSData"]) {
        objForKey = [NSObject hb_base64DataFromString:value];
    }
    else {
        objForKey = [[NSClassFromString(className) alloc] init];
        objForKey = [objForKey hb_newObjectFromXMLScanner:scanner];
    }
    
    
    // Scan until start of next Tag
    [scanner hb_skipTag:tag];
    
    // Return the object
    return objForKey;
}

- (id)hb_nextArrayValueForTag:(NSString *)tag fromScanner:(NSScanner *)scanner
{
    // Get the value from the Scanner
    NSString *value = [scanner hb_getNextValue];
    
    // Create the object
    id returnObj;
    
    // Check types / Assign *value to object
    if ([tag isEqualToString:@"string"]) {
        returnObj = (NSString *)value;
    }
    else if ([tag isEqualToString:@"boolean"]) {
        if ([value isEqualToString:@"true"]) {
            returnObj = @(YES);
        }
        else {
            returnObj = @(NO);
        }
    }
    else if ([tag isEqualToString:@"decimal"] || [tag isEqualToString:@"float"] || [tag isEqualToString:@"double"]) {
        returnObj = @([value floatValue]);
    }
    else {
        returnObj = [[NSClassFromString(tag) alloc] init];
        returnObj = [returnObj hb_newObjectFromXMLScanner:scanner];
    }
    
    // Scan until start of next Tag
    [scanner hb_skipTag:tag];
    
    // Return the object
    return returnObj;
}


#pragma mark - JSONData to Object
+ (id)hb_objectOfClass:(Class)objectClass fromJSONData:(NSData *)jsonData
{
    NSError *error;
    id newObject = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    // If jsonObject is a top-level object already
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        newObject = [NSObject hb_objectOfClass:objectClass fromJSON:jsonObject];
    }
    // Else it is an array of objects
    else if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSInteger length = [((NSArray *) jsonObject) count];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:length];
        for (NSInteger i = 0; i < length; i++) {
            [resultArray addObject:[NSObject hb_objectOfClass:objectClass fromJSON:[(NSArray *)jsonObject objectAtIndex:i]]];
        }
        newObject = [[NSArray alloc] initWithArray:resultArray];
    }
    
    return newObject;
}


#pragma mark - Dictionary to Object
+ (id)hb_objectOfClass:(Class)objectClass fromJSON:(NSDictionary *)dict
{
    if ([NSStringFromClass(objectClass) isEqualToString:@"NSDictionary"]) {
        return dict;
    }
    
    id newObject = [[objectClass alloc] init];
    NSDictionary *mapDictionary = [newObject hb_propertyDictionary];
    
    for (NSString *key in [dict allKeys]) {
        NSString *propertyName = [mapDictionary objectForKey:key];
        
        if (!propertyName) {
            continue;
        }
        
        // If it's null, set to nil and continue
        if ([dict objectForKey:key] == [NSNull null]) {
            [newObject hbO_setValue:nil forKey:propertyName];
            continue;
        }
        
        // If it's a Dictionary, make into object
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            //id newObjectProperty = [newObject valueForKey:propertyName];
            NSString *propertyType = [newObject hb_classOfPropertyNamed:propertyName];
            id nestedObj = [NSObject hb_objectOfClass:NSClassFromString(propertyType) fromJSON:[dict objectForKey:key]];
            [newObject hbO_setValue:nestedObj forKey:propertyName];
        }
        
        // If it's an array, check for each object in array -> make into object/id
        else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *nestedArray = [dict objectForKey:key];
            NSString *propertyType = [newObject valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@", key]];
            [newObject hbO_setValue:[NSObject hb_arrayMapFromArray:nestedArray forPropertyName:propertyType] forKey:propertyName];
        }
        
        // Add to property name, because it is a type already
        else {
            objc_property_t property = class_getProperty([newObject class], [propertyName UTF8String]);
            
            if (property) {
                NSString *classType = [newObject hb_typeFromProperty:property];
                
                // check if NSDate or not
                if ([classType isEqualToString:@"T@\"NSDate\""]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:OMDateFormat];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
                    [newObject hbO_setValue:[formatter dateFromString:[dict objectForKey:key]] forKey:propertyName];
                }
                else {
                    [newObject hbO_setValue:[dict objectForKey:key] forKey:propertyName];
                }
            }
        }
    }
    
    return newObject;
}

- (NSString *)hb_classOfPropertyNamed:(NSString *)propName
{
    objc_property_t theProperty = class_getProperty([self class], [propName UTF8String]);
    
    const char *attributes = property_getAttributes(theProperty);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.*/
            NSString *typeName = [[NSString alloc] initWithData:[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] encoding:NSUTF8StringEncoding];
            return typeName;
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSData *data = [NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4];
            NSString *className = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return className;
        }
    }
    
    return @"";
}

+ (NSArray *)hb_arrayFromJSON:(NSArray *)jsonArray ofObjects:(NSString *)obj
{
    //NSString *filteredObject = [NSString stringWithFormat:@"%@s",obj];
    return [NSObject hb_arrayMapFromArray:jsonArray forPropertyName:obj];
}

- (NSString *)hb_nameOfClass
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSArray *)hb_arrayMapFromArray:(NSArray *)nestedArray forPropertyName:(NSString *)propertyName
{
    // Set Up
    NSMutableArray *objectsArray = [@[] mutableCopy];
    
    // Create objects
    for (NSInteger xx = 0; xx < nestedArray.count; xx++) {
        // If it's an NSDictionary
        if ([nestedArray[xx] isKindOfClass:[NSDictionary class]]) {
            // Create object of filteredProperty type
            id nestedObj = [[NSClassFromString(propertyName) alloc] init];
            
            // Iterate through each key, create objects for each
            for (NSString *newKey in [nestedArray[xx] allKeys]) {
                // If it's null, move on
                if ([nestedArray[xx] objectForKey:newKey] == [NSNull null]) {
                    [nestedObj hbO_setValue:nil forKey:newKey];
                    continue;
                }
                
                // If it's an Array, recur
                if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSArray class]]) {
                    NSString *propertyType = [nestedObj valueForKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@", newKey]];
                    
                    if (propertyType) {
                        [nestedObj hbO_setValue:[NSObject hb_arrayMapFromArray:[nestedArray[xx] objectForKey:newKey]  forPropertyName:propertyType] forKey:newKey];
                    }
                }
                // If it's a Dictionary, create an object, and send to [self objectFromJSON]
                else if ([[nestedArray[xx] objectForKey:newKey] isKindOfClass:[NSDictionary class]]) {
                    NSString *type = [nestedObj hb_classOfPropertyNamed:newKey];
                    id nestedDictObj = [NSObject hb_objectOfClass:NSClassFromString(type) fromJSON:[nestedArray[xx] objectForKey:newKey]];
                    [nestedObj hbO_setValue:nestedDictObj forKey:newKey];
                }
                // Else, it is an object
                else {
                    objc_property_t property = class_getProperty([NSClassFromString(propertyName) class], [newKey UTF8String]);
                    
                    if (property) {
                        NSString *classType = [self hb_typeFromProperty:property];
                        // check if NSDate or not
                        if ([classType isEqualToString:@"T@\"NSDate\""]) {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:OMDateFormat];
                            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
                            [nestedObj hbO_setValue:[formatter dateFromString:[nestedArray[xx] objectForKey:newKey]] forKey:newKey];
                        }
                        else {
                            [nestedObj hbO_setValue:[nestedArray[xx] objectForKey:newKey] forKey:newKey];
                        }
                    }
                    
                }
            }
            
            // Finally add that object
            [objectsArray addObject:nestedObj];
        }
        
        // If it's an NSArray, recur
        else if ([nestedArray[xx] isKindOfClass:[NSArray class]]) {
            [objectsArray addObject:[NSObject hb_arrayMapFromArray:nestedArray[xx] forPropertyName:propertyName]];
        }
        
        // Else, add object directly
        else {
            [objectsArray addObject:nestedArray[xx]];
        }
    }
    
    // This is now an Array of objects
    return objectsArray;
}

- (NSDictionary *)hb_propertyDictionary
{
    // Add properties of Self
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:key forKey:key];
    }
    
    free(properties);
    
    // Add all superclass properties of Self as well, until it hits NSObject
    NSString *superClassName = [[self superclass] hb_nameOfClass];
    if (![superClassName isEqualToString:@"NSObject"]) {
        for (NSString *property in [[[self superclass] hb_propertyDictionary] allKeys]) {
            [dict setObject:property forKey:property];
        }
    }
    
    // Return the Dict
    return dict;
}

- (NSString *)hb_typeFromProperty:(objc_property_t)property
{
    return [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","][0];
}


#pragma mark - Get Property Array Map
// This returns an associated property Dictionary for objects
// You should make an object contain a dictionary in init
// that contains a map for each array and what it contains:
//
// {"arrayPropertyName":"TypeOfObjectYouWantInArray"}
//
// To Set this object in each init method, do something like this:
//
// [myObject hbO_setValue:@"TypeOfObjectYouWantInArray" forKeyPath:@"propertyArrayMap.arrayPropertyName"]
//
- (NSMutableDictionary *)getPropertyArrayMap
{
    if (objc_getAssociatedObject(self, @"propertyArrayMap")==nil) {
        objc_setAssociatedObject(self,@"propertyArrayMap",[[NSMutableDictionary alloc] init],OBJC_ASSOCIATION_RETAIN);
    }
    return (NSMutableDictionary *)objc_getAssociatedObject(self, @"propertyArrayMap");
}


#pragma mark - Copy NSObject (initWithObject)
- (id)hb_initWithObject:(NSObject *)oldObject error:(NSError **)error
{
    NSString *oldClassName = [oldObject hb_nameOfClass];
    NSString *newClassName = [self hb_nameOfClass];
    
    if ([newClassName isEqualToString:oldClassName]) {
        for (NSString *propertyKey in [[oldObject hb_propertyDictionary] allKeys]) {
            [self hbO_setValue:[oldObject valueForKey:propertyKey] forKey:propertyKey];
        }
    }
    else {
        *error = [NSError errorWithDomain:@"MismatchedObjects" code:404 userInfo:@{@"Error":@"Mismatched Object Classes"}];
    }
    
    return self;
}


#pragma mark - Object to Data/String/etc.

- (NSDictionary *)hb_objectDictionary
{
    NSMutableDictionary *objectDict = [@{} mutableCopy];
    for (NSString *key in [[self hb_propertyDictionary] allKeys]) {
        [objectDict hbO_setValue:[self valueForKey:key] forKey:key];
    }
    return objectDict;
}

- (NSData *)hb_JSONData
{
    id dict = [NSObject hb_jsonDataObjects:self];
    return [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)hb_JSONString
{
    id dict = [NSObject hb_jsonDataObjects:self];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

+ (id)hb_jsonDataObjects:(id)obj
{
    id returnProperties = nil;
    if ([self hb_isArray:obj]) {
        NSInteger length =[(NSArray *)obj count];
        returnProperties = [NSMutableArray arrayWithCapacity:length];
        for (NSInteger i = 0; i < length; i++) {
            [returnProperties addObject:[NSObject hb_dictionaryWithPropertiesOfObject:[(NSArray *)obj objectAtIndex:i]]];
        }
    }
    else {
        returnProperties = [NSObject hb_dictionaryWithPropertiesOfObject:obj];
        
    }
    
    return returnProperties;
}

+ (NSDictionary *)hb_dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *propertiesArray = [NSObject hb_propertiesArrayFromObject:obj];
    
    for (NSInteger i = 0; i < propertiesArray.count; i++) {
        NSString *key = propertiesArray[i];
        
        if (![obj valueForKey:key]) {
            continue;
        }
        
        if ([self hb_isArray:obj key:key]) {
            [dict setObject:[self hb_arrayForObject:[obj valueForKey:key]] forKey:key];
        }
        else if ([self hb_isDate:[obj valueForKey:key]]) {
            [dict setObject:[self hb_dateForObject:[obj valueForKey:key]] forKey:key];
        }
        else if ([self hb_isSystemObject:obj key:key]) {
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
        else if ([NSObject hb_isData:[obj valueForKey:key]]) {
            [dict setObject:[NSObject hb_encodeBase64WithData:[obj valueForKey:key]] forKey:key];
        }
        else {
            [dict setObject:[self hb_dictionaryWithPropertiesOfObject:[obj valueForKey:key]] forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSMutableArray *)hb_propertiesArrayFromObject:(id)obj
{
    
    NSMutableArray *props = [NSMutableArray array];
    
    if (!obj) {
        return props;
    }
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    for (NSInteger i = 0; i < count; i++) {
        [props addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    
    free(properties);
    
    NSString *superClassName = [[obj superclass] hb_nameOfClass];
    if (![superClassName isEqualToString:@"NSObject"]) {
        [props addObjectsFromArray:[NSObject hb_propertiesArrayFromObject:[[NSClassFromString(superClassName) alloc] init]]];
    }
    
    return props;
}

- (BOOL)hb_isSystemObject:(id)obj key:(NSString *)key
{
    if ([[obj valueForKey:key] isKindOfClass:[NSString class]] || [[obj valueForKey:key] isKindOfClass:[NSNumber class]] || [[obj valueForKey:key] isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hb_isSystemObject:(id)obj
{
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hb_isArray:(id)obj key:(NSString *)key
{
    if ([[obj valueForKey:key] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hb_isArray:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hb_isDate:(id)obj
{
    if ([obj isKindOfClass:[NSDate class]]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hb_isData:(id)obj
{
    if ([obj isKindOfClass:[NSData class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hb_isData:(id)obj
{
    if ([obj isKindOfClass:[NSData class]]) {
        return YES;
    }
    
    return NO;
}

+ (NSArray *)hb_arrayForObject:(id)obj
{
    NSArray *ContentArray = (NSArray *)obj;
    NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
    for (NSInteger ii = 0; ii < ContentArray.count; ii++) {
        if ([self hb_isArray:ContentArray[ii]]) {
            [objectsArray addObject:[self hb_arrayForObject:[ContentArray objectAtIndex:ii]]];
        }
        else if ([self hb_isDate:ContentArray[ii]]) {
            [objectsArray addObject:[self hb_dateForObject:[ContentArray objectAtIndex:ii]]];
        }
        else if ([self hb_isSystemObject:[ContentArray objectAtIndex:ii]]) {
            [objectsArray addObject:[ContentArray objectAtIndex:ii]];
        }
        else {
            [objectsArray addObject:[self hb_dictionaryWithPropertiesOfObject:[ContentArray objectAtIndex:ii]]];
        }
        
    }
    
    return objectsArray;
}


+ (NSString *)hb_dateForObject:(id)obj
{
    NSDate *date = (NSDate *)obj;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:OMDateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
    return [formatter stringFromDate:date];
}

#pragma mark - SOAP/XML Serialization

- (NSData *)hb_SOAPData
{
    return [[self hb_SOAPString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)hb_XMLData
{
    return [[self hb_XMLString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)hb_XMLString
{
    NSMutableString *xmlString = [@"<?xml version=\"1.0\"?>" mutableCopy];
    [xmlString appendString:[self hb_xmlStringForSelfNamed:nil]];
    return xmlString;
}

- (NSString *)hb_SOAPString
{
    return [self hb_soapStringForDictionary:(hb_SOAPObject *)self];
}

- (NSString *)hb_soapStringForDictionary:(hb_SOAPObject *)obj
{
    // No object, return blank
    if (!obj) {
        return @"";
    }
    
    // Build object
    hb_SOAPObject *soapObject = (hb_SOAPObject *)self;
    NSMutableString *soapString = [[NSMutableString alloc] initWithString:@""];
    
    //Open Envelope
    [soapString appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://tempuri.org/\">"];
    
    //Request Header
    if (obj.Header) {
        if (soapObject.Header) {
            // Add SoapHeader
            [soapString appendString:@"<soap:Header>"];
            [soapString appendString:[soapObject.Header hb_xmlStringForSelfNamed:nil]];
            [soapString appendString:@"</soap:Header>"];
        }
    }
    
    
    if (obj.Body) {
        if (soapObject.Body) {
            // Add SoapBody
            [soapString appendString:@"<soap:Body>"];
            [soapString appendString:[obj.Body hb_xmlStringForSelfNamed:nil]];
            [soapString appendString:@"</soap:Body>"];
        }
    }
    
    //Close Envelope
    [soapString appendString:@"</soap:Envelope>"];
    
    return soapString;
}

#pragma mark - XMLString for Self (The Meat of the Operation)
// Doesn't include <xml> or <soap> cruft - just the inside material
- (NSString *)hb_xmlStringForSelfNamed:(NSString *)name
{
    // XML doesn't handle NSDictionaries (to SPEC)
    if ([self isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@""];
    NSString *className = name ? name : [NSString stringWithFormat:@"%s", class_getName([self class])];
    className = [className stringByReplacingOccurrencesOfString:@"ArrayOf" withString:@""];
    
    // Make opening tag
    [xmlString appendFormat:@"<%@>", className];
    
    // self is a Date
    if ([self isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:OMDateFormat];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:OMTimeZone]];
        [xmlString appendString:[formatter stringFromDate:(NSDate *)self]];
    }
    
    // self is a String or Number
    else if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]) {
        [xmlString appendFormat:@"%@", self];
    }
    
    // self is an Array
    else if ([self isKindOfClass:[NSArray class]]) {
        for (id arrayObj in (NSArray *)self) {
            [xmlString appendString:[arrayObj hb_xmlStringForSelfNamed:nil]];
        }
    }
    
    // self is a Dictionary
    else if ([self isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [(NSDictionary *)self allKeys]) {
            [xmlString appendString:[[(NSDictionary *)self objectForKey:key] hb_xmlStringForSelfNamed:key]];
        }
    }
    
    // self is Data
    else if ([self isKindOfClass:[NSData class]]) {
        [xmlString appendString:[NSObject hb_encodeBase64WithData:(NSData *)self]];
    }
    
    // self is a custom Object
    else {
        NSDictionary *dict = [NSObject hb_dictionaryWithPropertiesOfObject:self];
        for (NSString *innerObj in dict.allKeys) {
            // if innerObj exists, use it
            if ([self valueForKey:innerObj]) {
                [xmlString appendString:[[self valueForKey:innerObj] hb_xmlStringForSelfNamed:innerObj]];
            }
            else {
                [xmlString appendFormat:@"<%@ />", innerObj];
            }
        }
    }
    
    // Append end of class name
    [xmlString appendFormat:@"</%@>", className];
    return xmlString;
}


#pragma mark - Base64 Binary Encode/Decode

+ (NSData *)hb_base64DataFromString:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    tempcstring = (const unsigned char *)[string UTF8String];
    lentext = [string length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext) {
            break;
        }
        
        ch = tempcstring [ixtext++];
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        }
        else if (ch == '+') {
            ch = 62;
        }
        else if (ch == '=') {
            flendtext = true;
        }
        else if (ch == '/') {
            ch = 63;
        }
        else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                }
                else {
                    ctcharsinbuf = 2;
                }
                ixinbuf = 3;
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}

+ (NSString *)hb_encodeBase64WithData:(NSData *)objData
{
    const unsigned char *objRawData = [objData bytes];
    char *objPointer;
    char *strResult;
    
    // Get the Raw Data length and ensure we actually have data
    NSInteger intLength = [objData length];
    if (intLength == 0) {
         return nil;
    }
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _hbbase64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _hbbase64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _hbbase64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _hbbase64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _hbbase64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _hbbase64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _hbbase64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        }
        else {
            *objPointer++ = _hbbase64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Return the results as an NSString object
    return [NSString stringWithCString:strResult encoding:NSUTF8StringEncoding];
}



@end


@implementation hb_SOAPObject

@end
