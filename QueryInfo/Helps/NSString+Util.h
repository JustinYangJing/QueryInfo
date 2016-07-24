//
//  NSString+Util.h
//  GoGo
//
//  Created by GuoChengHao on 14-4-21.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Util)
/**
 判断字符串是否为空
 */
+(BOOL)isBlankString:(NSString *)string;

//设置字体大小的接口
+ (NSMutableAttributedString *)nameFont:(UIFont *)font name:(NSString *)name string:(NSString *)string;

//设置名字为制定颜色的接口
+ (NSMutableAttributedString *)nameColor:(UIColor *)color name:(NSString *)name string:(NSString *)string;

/**
 *	@brief	保留小数有效位
 *
 *	@param 	stringFloat 	原数字
 *
 *	@return	去掉0后的数
 */
+ (NSString *)changeFloat:(NSString *)stringFloat;

//自动计算文本宽度
+ (CGSize)sizeWidthWithString:(NSString *)string font:(UIFont *)font constraintHeight:(CGFloat)constraintHeight;

//自动计算文本高度
+ (CGSize)sizeHeightWithString:(NSString *)string font:(UIFont *)font constraintWidth:(CGFloat)constraintWidth;

//字典转为json数据
+ (NSString *)toJsonStringWithDictionary:(NSDictionary *)dictionary;

//数组转为json数据
+ (NSString *)toJsonStringWithNSArray:(NSArray *)array;
@end
