//
//  NSArray+JsonConversion.m
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "NSArray+JsonConversion.h"

@implementation NSArray (JsonConversion)

- (NSString *)conversionToJson
{
    NSJSONWritingOptions JSONWritingOptions = NSJSONWritingPrettyPrinted;
    if (@available(iOS 11.0, *))
    {
        JSONWritingOptions = NSJSONWritingSortedKeys;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:JSONWritingOptions error:nil];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return json;
}

@end
