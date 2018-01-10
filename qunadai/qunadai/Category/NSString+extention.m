//
//  NSString+extention.m
//  Yizhenapp
//
//  Created by augbase on 16/5/14.
//  Copyright © 2016年 wang. All rights reserved.
//
#import<CommonCrypto/CommonDigest.h>
#import "NSString+extention.h"

@implementation NSString (extention)
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(CGSize)sizeWithWordWrapFont:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading  attributes:attrs context:nil].size;
}

//sha1加密方式
+ (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

//字典转json字符串

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+(id)toArrayOrNSDictionary:(NSString*)NOjsonString

{
    
    if(NOjsonString.length==0) {
        
        return nil;
        
    }
    
    NSError*error =nil;
    
    NSData*StatusData = [NOjsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",StatusData);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:StatusData
                     
                                                    options:NSJSONReadingAllowFragments
                     
                                                      error:&error];
    if(jsonObject !=nil&& error ==nil){
        
        return jsonObject;
        
    }else{
        //解析错误
        return nil;
    }
}

+(NSMutableString*)getTheMutableStringWithString:(NSString*)str{
    //插入逗号
    NSMutableString * finishStr = [NSMutableString stringWithString:str];
    //1.拿出整数部分
    NSArray * arr = [str componentsSeparatedByString:@"."];
    NSString * preStr = arr[0];
    //2.判断长度，是否需要加
    if (preStr.length<4) {
        return finishStr;
        //依然用firstStr
    }else if (preStr.length<7){
        //需要加入一个逗号
        [finishStr insertString:@"," atIndex:preStr.length-3];
        return finishStr;
    }else if (preStr.length<10){
        //需要加入两个逗号
        [finishStr insertString:@"," atIndex:preStr.length-6];
        [finishStr insertString:@"," atIndex:preStr.length-3+1];
        return finishStr;
    }else{
        return finishStr;
    }
}


@end
