//
//  UserAvatarModifyApi.m
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import "UserAvatarModifyApi.h"

@implementation UserAvatarModifyApi
{
    UIImage * _avatarImage;
}

-(instancetype)initWithimage:(UIImage *)avatarImage{
    self= [super init];
    if (self) {
        _avatarImage = avatarImage;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"user/addHeadPic";
}

-(id)requestArgument{
//    NSNumber * floatNum = [NSNumber numberWithFloat:20.0];
//    NSNumber * boolNum = [NSNumber numberWithBool:YES];
//    return @{@"image":[self configTheImage:_avatarImage],@"configure":@{@"min_size":floatNum,@"output_prob": boolNum}};
    return @{@"userId":KGetUserID,@"x-auth-token": KGetACCESSTOKEN,@"imgStr":[self configTheImage:_avatarImage]};
}

-(NSURLRequest *)buildCustomUrlRequest{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.requestArgument options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BaseUrl,self.requestUrl]]];
    WHLog(@"%@",request.URL);
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    return request;
}

-(NSString*)configTheImage:(UIImage*)image{
    UIImage *img = [self imageByScalingAndCroppingForSize:CGSizeMake(130, 130) withSourceImage:image];
    NSData* imageData = UIImageJPEGRepresentation(img, 0.5);
    
    NSString * base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
//NSDataBase64EncodingEndLineWithCarriageReturn 一直到最后不换行
    return base64Str;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end



