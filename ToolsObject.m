//
//  ToolsObject.m
//  Naton
//
//  Created by nato on 16/7/8.
//  Copyright © 2016年 naton. All rights reserved.
//

#import "ToolsObject.h"

@implementation ToolsObject
+(NSString*)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
//    NSLog(@"%@ to %@",str,chinese);
    return chinese;
}
+ (NSString *)exChangeUnitTimeWithTime:(NSInteger)time{
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time+28800];
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

+(NSInteger)getOutTheWeekForYear{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [calendar components:(NSWeekCalendarUnit | NSWeekOfYearCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:[NSDate date]];
    NSInteger week = [comps weekOfYear]; // 今年的第几周
    return week;
}

//获得当前时间戳
+ (NSTimeInterval)getNowUnixTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}
//字典转化为字符串
+ (NSString*)convertToJSONData:(NSDictionary *)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}
//将json字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSDictionary *)dictionaryOption:(NSDictionary *)dict{
    NSArray * keyArr = [dict allKeys];
    NSMutableDictionary * resul = [dict mutableCopy];
    for (NSString * key in keyArr) {
        Class value = dict[key];
        NSString * valueStr = (NSString *)value;
        if ([valueStr isEqualToString:@""]) {
            [resul removeObjectForKey:key];
        }
    }
    return resul;
}

+ (NSString *)encodeingUrlString:(NSString *)string{
    NSString * kAFCharactersGeneralDelimitersToEncode = @":#[]@?/"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSString * kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

@end
