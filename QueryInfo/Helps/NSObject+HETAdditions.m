//
//  NSObject+HETAdditions.m
//  CSleepNew
//
//  Created by JustinYang on 12/31/15.
//  Copyright © 2015 JustinYang. All rights reserved.
//

#import "NSObject+HETAdditions.h"
#import <objc/runtime.h>
@implementation NSObject (HETAdditions)
+(NSDictionary *)dictionaryFromModel:(id)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([model class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [model valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        [dic setObject:value forKey:propName];
    }
    free(props);
    
    return [NSDictionary dictionaryWithDictionary:dic];
}

+(NSDictionary *)dictionaryFromCouldJsonModel:(id)model{
    if ([model isKindOfClass:[NSArray class]]) {
        return  [self getObjectInternal:model];
    }
    if ([model isKindOfClass:[NSDictionary class]]) {
        return [self getObjectInternal:model];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([model class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [model valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    free(props);
    
    return [NSDictionary dictionaryWithDictionary:dic];
}


+(id)getObjectInternal:(id)obj

{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self dictionaryFromCouldJsonModel:obj];
}

+(NSString *)jsonStrFromModel:(id)model{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionaryFromCouldJsonModel:model] options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
