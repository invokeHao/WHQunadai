//
//  NSString+extention.h
//  Yizhenapp
//
//  Created by augbase on 16/5/14.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extention)
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

-(CGSize)sizeWithWordWrapFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *) sha1:(NSString *)input;


+(id)toArrayOrNSDictionary:(NSString*)NOjsonString;

#pragma mark- 金额逗号分开
+(NSMutableString*)getTheMutableStringWithString:(NSString*)str;

@end
