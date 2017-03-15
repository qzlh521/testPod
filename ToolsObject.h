//
//  ToolsObject.h
//  Naton
//
//  Created by nato on 16/7/8.
//  Copyright © 2016年 naton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsObject : NSObject

+(NSString*)translation:(NSString *)arebic;
/**
 *  unit时间转化
 */
+ (NSString *)exChangeUnitTimeWithTime:(NSInteger)time;
/**
 *  获得当前时间是本年的第几个周
 *
 */
+ (NSInteger)getOutTheWeekForYear;
/**
 *  获得当前的Unix时间
 *
 *  @return Unix时间
 */
+ (NSTimeInterval)getNowUnixTime;
//字典转化为字符串
+ (NSString*)convertToJSONData:(NSDictionary *)infoDict;
//将json字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//去除字典中值为@"" 的值
+ (NSDictionary *)dictionaryOption:(NSDictionary *)dict;
/// 处理 AES加密后 session 字符串中的 '/' 导致编码问题
+ (NSString *)encodeingUrlString:(NSString *)string;
@end
