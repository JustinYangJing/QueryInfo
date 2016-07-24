//
//  NSString+Util.m
//  GoGo
//
//  Created by GuoChengHao on 14-4-21.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (BOOL)isBlankString:(NSString *)string {
    
    if ( ![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

+ (NSMutableAttributedString *)nameFont:(UIFont *)font name:(NSString *)name string:(NSString *)string;
{
    NSMutableAttributedString *fontString=[[NSMutableAttributedString alloc]initWithString:string];
    if ([name isKindOfClass:[NSString class]]) {
        NSRange rang=[string rangeOfString:name];
        [fontString addAttribute:NSFontAttributeName value:font range:rang];
    }
    return fontString;
}
+ (NSMutableAttributedString *)nameColor:(UIColor *)color name:(NSString *)name string:(NSString *)string
{
    NSMutableAttributedString *retStr = [[NSMutableAttributedString alloc] initWithString:string];
    if ([name isKindOfClass:[NSString class]]) {
        NSRange range = [string rangeOfString:name];
        [retStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return retStr;
    
}



//保留小数有效位
+ (NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

//自动计算文本宽度
+ (CGSize)sizeWidthWithString:(NSString *)string font:(UIFont *)font constraintHeight:(CGFloat)constraintHeight{
    CGSize linesSz;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    linesSz = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, constraintHeight)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes context:nil].size;
    
    
    return linesSz;
}

//自动计算文本高度
+ (CGSize)sizeHeightWithString:(NSString *)string font:(UIFont *)font constraintWidth:(CGFloat)constraintWidth{
    CGSize linesSz;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    linesSz = [string boundingRectWithSize:CGSizeMake(constraintWidth, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes context:nil].size;
    
    
    return linesSz;
}

//字典转为json数据
+ (NSString *)toJsonStringWithDictionary:(NSDictionary *)dictionary{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&err];
    if (err) {
        return nil;
    }
    NSString * json = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    return json;
}

//数组转为json数据
+ (NSString *)toJsonStringWithNSArray:(NSArray *)array{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&err];
    if (err) {
        return nil;
    }
    NSString * json = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    return json;
}
@end
