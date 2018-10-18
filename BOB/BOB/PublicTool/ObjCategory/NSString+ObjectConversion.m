//
//  NSString+ObjectConversion.m
//  BOB
//
//  Created by 汲群英 on 2018/10/18.
//  Copyright © 2018 qunyingji. All rights reserved.
//

#import "NSString+ObjectConversion.h"

@implementation NSString (ObjectConversion)

- (id)conversionToObject
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return obj;
}

@end
