//
//  NSObject+HETAdditions.h
//  CSleepNew
//
//  Created by JustinYang on 12/31/15.
//  Copyright © 2015 JustinYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HETAdditions)
/**
 *  将model中的属性转换为字典
 *
 *  @param model model
 *
 *  @return 转换后的字典
 */
+(NSDictionary *)dictionaryFromModel:(id)model;

/**
 *  将model转换为json字符串，model中只能包含isValidJSONObject的对象
 *  想UIImage等对象不能通过这个方法直接转化为json String
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)jsonStrFromModel:(id)model;

/**
 *  多级model转化为字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)dictionaryFromCouldJsonModel:(id)model;

/**
 *  json字符串转换为字典
 *
 *  @param jsonString 只能是1级字典转换而来的json str
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
